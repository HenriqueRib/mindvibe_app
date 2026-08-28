import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mindvibe_app/core/network/media_url.dart';
import 'package:mindvibe_app/features/audio_player/domain/playback_listen_meter.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';
import 'package:uuid/uuid.dart';

enum AudioPlayerUiState { idle, loading, playing, paused, completed, error }

class NowPlayingTrack {
  const NowPlayingTrack({
    required this.id,
    required this.url,
    required this.title,
    this.coverUrl,
    this.subtitle,
    this.audioId,
    this.countsForProgress = false,
  });

  final String id;
  final String url;
  final String title;
  final String? coverUrl;
  final String? subtitle;
  final int? audioId;
  final bool countsForProgress;
}

class NowPlayingState {
  const NowPlayingState({
    this.track,
    this.ui = AudioPlayerUiState.idle,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.queue = const [],
    this.index = 0,
    this.volume = 1,
    this.looping = false,
    this.sleepRemaining,
  });

  final NowPlayingTrack? track;
  final AudioPlayerUiState ui;
  final Duration position;
  final Duration duration;
  final List<NowPlayingTrack> queue;
  final int index;
  final double volume;
  final bool looping;
  final Duration? sleepRemaining;

  bool get hasTrack => track != null;
  bool get hasNext => index >= 0 && index < queue.length - 1;
  bool get hasPrevious => index > 0;

  NowPlayingState copyWith({
    NowPlayingTrack? track,
    AudioPlayerUiState? ui,
    Duration? position,
    Duration? duration,
    List<NowPlayingTrack>? queue,
    int? index,
    double? volume,
    bool? looping,
    Duration? sleepRemaining,
    bool clearTrack = false,
    bool clearSleep = false,
  }) {
    return NowPlayingState(
      track: clearTrack ? null : (track ?? this.track),
      ui: ui ?? this.ui,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      queue: clearTrack ? const [] : (queue ?? this.queue),
      index: clearTrack ? 0 : (index ?? this.index),
      volume: volume ?? this.volume,
      looping: looping ?? this.looping,
      sleepRemaining: clearSleep
          ? null
          : (sleepRemaining ?? this.sleepRemaining),
    );
  }
}

class NowPlayingController extends StateNotifier<NowPlayingState> {
  NowPlayingController({this.onListenSlice}) : super(const NowPlayingState()) {
    unawaited(_configurePlayback());
    _subs.add(
      _player.playerStateStream.listen((playerState) {
        if (state.track == null) {
          state = state.copyWith(ui: AudioPlayerUiState.idle);
          return;
        }
        if (playerState.processingState == ProcessingState.completed) {
          if (state.looping) {
            unawaited(_player.seek(Duration.zero));
            unawaited(_player.play());
            return;
          }
          if (_isSpuriousCompletion()) {
            return;
          }
          _stopListeningClock();
          if (state.hasNext) {
            unawaited(playNext());
            return;
          }
        }
        state = state.copyWith(ui: _map(playerState));
        _syncListeningClock();
      }),
    );
    _subs.add(
      _player.positionStream.listen((position) {
        state = state.copyWith(position: position);
      }),
    );
    _subs.add(
      _player.durationStream.listen((duration) {
        if (duration != null) {
          state = state.copyWith(duration: duration);
        }
      }),
    );
  }

  final Future<void> Function(int seconds, NowPlayingTrack track)?
  onListenSlice;
  final _player = AudioPlayer(
    handleInterruptions: false,
    androidAudioOffloadPreferences: const AndroidAudioOffloadPreferences(
      audioOffloadMode: AndroidAudioOffloadMode.disabled,
    ),
  );
  final _subs = <StreamSubscription<dynamic>>[];
  final _meter = PlaybackListenMeter();
  Timer? _heartbeat;
  Timer? _sleepTimer;
  Timer? _sleepTick;
  DateTime? _sleepEndsAt;
  DateTime? _sourceStartedAt;
  double _unmutedVolume = 1;

  Future<void> _configurePlayback() async {
    final session = await AudioSession.instance;
    await session.configure(
      const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.music,
          usage: AndroidAudioUsage.media,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: false,
      ),
    );
    await _player.setSkipSilenceEnabled(false);
    await _player.setVolume(state.volume);
  }

  void _syncListeningClock() {
    final playing =
        state.ui == AudioPlayerUiState.playing &&
        state.track?.countsForProgress == true;
    if (playing) {
      _startListeningClock();
      _heartbeat ??= Timer.periodic(const Duration(seconds: 30), (_) {
        _creditElapsed();
      });
      return;
    }
    _stopListeningClock();
    _heartbeat?.cancel();
    _heartbeat = null;
  }

  void _startListeningClock() {
    if (state.track?.countsForProgress != true) {
      return;
    }
    _meter.start(DateTime.now());
  }

  void _creditElapsed() {
    final track = state.track;
    if (track == null || !track.countsForProgress) {
      return;
    }
    final seconds = _meter.take(DateTime.now());
    if (seconds < 1) {
      return;
    }
    unawaited(onListenSlice?.call(seconds, track) ?? Future.value());
  }

  void _stopListeningClock() {
    final track = state.track;
    final seconds = _meter.pause(DateTime.now());
    _heartbeat?.cancel();
    _heartbeat = null;
    if (track == null || !track.countsForProgress || seconds < 1) {
      return;
    }
    unawaited(onListenSlice?.call(seconds, track) ?? Future.value());
  }

  bool _isSpuriousCompletion() {
    final started = _sourceStartedAt;
    if (started != null &&
        DateTime.now().difference(started) < const Duration(seconds: 2)) {
      return true;
    }
    final duration = state.duration;
    if (duration <= Duration.zero) {
      return false;
    }
    return state.position + const Duration(seconds: 3) < duration;
  }

  Future<void> play(
    NowPlayingTrack track, {
    List<NowPlayingTrack>? queue,
  }) async {
    var nextQueue = state.queue;
    var nextIndex = state.index;
    if (queue != null && queue.isNotEmpty) {
      nextQueue = queue;
      final found = queue.indexWhere((item) => item.id == track.id);
      nextIndex = found >= 0 ? found : 0;
    } else {
      final found = nextQueue.indexWhere((item) => item.id == track.id);
      if (found >= 0) {
        nextIndex = found;
      } else {
        nextQueue = [track];
        nextIndex = 0;
      }
    }

    final same = state.track?.id == track.id && state.track?.url == track.url;
    if (same && state.ui != AudioPlayerUiState.error) {
      if (state.ui == AudioPlayerUiState.completed) {
        await _player.seek(Duration.zero);
      }
      if (state.ui != AudioPlayerUiState.playing) {
        await _player.play();
      }
      state = state.copyWith(track: track, queue: nextQueue, index: nextIndex);
      _syncListeningClock();
      return;
    }
    _stopListeningClock();
    state = NowPlayingState(
      track: track,
      queue: nextQueue,
      index: nextIndex,
      ui: AudioPlayerUiState.loading,
      volume: state.volume,
      looping: state.looping,
      sleepRemaining: state.sleepRemaining,
    );
    try {
      _sourceStartedAt = DateTime.now();
      final duration = await _player.setUrl(MediaUrl.resolve(track.url));
      await _player.setVolume(state.volume);
      await _player.setLoopMode(state.looping ? LoopMode.one : LoopMode.off);
      state = state.copyWith(
        duration: duration ?? Duration.zero,
        position: Duration.zero,
      );
      await _player.play();
      _syncListeningClock();
    } catch (_) {
      state = state.copyWith(ui: AudioPlayerUiState.error);
      _syncListeningClock();
    }
  }

  Future<void> playNext() async {
    if (!state.hasNext) {
      return;
    }
    await play(state.queue[state.index + 1]);
  }

  Future<void> playPrevious() async {
    if (state.position.inSeconds >= 3 || !state.hasPrevious) {
      await seek(Duration.zero);
      if (state.ui != AudioPlayerUiState.playing) {
        await _player.play();
        _syncListeningClock();
      }
      return;
    }
    await play(state.queue[state.index - 1]);
  }

  Future<void> setLooping(bool looping) async {
    await _player.setLoopMode(looping ? LoopMode.one : LoopMode.off);
    state = state.copyWith(looping: looping);
  }

  Future<void> setSleepTimer(Duration? duration) async {
    _sleepTimer?.cancel();
    _sleepTick?.cancel();
    _sleepTimer = null;
    _sleepTick = null;
    _sleepEndsAt = null;
    if (duration == null || duration <= Duration.zero) {
      state = state.copyWith(clearSleep: true);
      return;
    }
    _sleepEndsAt = DateTime.now().add(duration);
    state = state.copyWith(sleepRemaining: duration);
    _sleepTimer = Timer(duration, () async {
      _sleepTimer = null;
      _sleepTick?.cancel();
      _sleepTick = null;
      _sleepEndsAt = null;
      if (state.ui == AudioPlayerUiState.playing) {
        _stopListeningClock();
        await _player.pause();
      }
      state = state.copyWith(clearSleep: true);
      _syncListeningClock();
    });
    _sleepTick = Timer.periodic(const Duration(seconds: 1), (_) {
      final ends = _sleepEndsAt;
      if (ends == null) {
        return;
      }
      final left = ends.difference(DateTime.now());
      if (left <= Duration.zero) {
        return;
      }
      state = state.copyWith(sleepRemaining: left);
    });
  }

  Future<void> pauseIfPlaying() async {
    if (state.ui == AudioPlayerUiState.playing) {
      await toggle();
    }
  }

  Future<void> toggle() async {
    if (state.ui == AudioPlayerUiState.playing) {
      _stopListeningClock();
      await _player.pause();
      _syncListeningClock();
      return;
    }
    if (state.ui == AudioPlayerUiState.completed) {
      await _player.seek(Duration.zero);
    }
    await _player.play();
    _syncListeningClock();
  }

  Future<void> setVolume(double value) async {
    final volume = value.clamp(0.0, 1.0);
    if (volume > 0) {
      _unmutedVolume = volume;
    }
    await _player.setVolume(volume);
    state = state.copyWith(volume: volume);
  }

  Future<void> toggleMute() async {
    if (state.volume == 0) {
      await setVolume(_unmutedVolume <= 0 ? 1 : _unmutedVolume);
      return;
    }
    _unmutedVolume = state.volume;
    await setVolume(0);
  }

  Future<void> seek(Duration position) {
    return _player.seek(position);
  }

  Future<void> stop() async {
    _stopListeningClock();
    _heartbeat?.cancel();
    _heartbeat = null;
    _sleepTimer?.cancel();
    _sleepTick?.cancel();
    _sleepTimer = null;
    _sleepTick = null;
    _sleepEndsAt = null;
    await _player.stop();
    state = NowPlayingState(volume: state.volume, looping: state.looping);
  }

  AudioPlayerUiState _map(PlayerState playerState) {
    if (playerState.processingState == ProcessingState.completed) {
      return AudioPlayerUiState.completed;
    }
    if (playerState.playing) {
      return AudioPlayerUiState.playing;
    }
    if (playerState.processingState == ProcessingState.loading ||
        playerState.processingState == ProcessingState.buffering) {
      return AudioPlayerUiState.loading;
    }
    if (playerState.processingState == ProcessingState.idle) {
      return AudioPlayerUiState.idle;
    }
    return AudioPlayerUiState.paused;
  }

  @override
  void dispose() {
    _stopListeningClock();
    _heartbeat?.cancel();
    _sleepTimer?.cancel();
    _sleepTick?.cancel();
    for (final sub in _subs) {
      unawaited(sub.cancel());
    }
    unawaited(_player.dispose());
    super.dispose();
  }
}

final nowPlayingProvider =
    StateNotifierProvider<NowPlayingController, NowPlayingState>((ref) {
      return NowPlayingController(
        onListenSlice: (seconds, track) async {
          await ref
              .read(trainingRepositoryProvider)
              .recordListen(
                seconds: seconds,
                clientEventId: const Uuid().v4(),
                audioId: track.audioId,
              );
          ref.invalidate(progressProvider);
          ref.invalidate(historyProvider);
        },
      );
    });
