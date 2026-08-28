import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/storage/favorite_store.dart';
import 'package:mindvibe_app/features/audio_player/presentation/providers/now_playing_controller.dart';
import 'package:mindvibe_app/features/audio_player/presentation/widgets/audio_briefing_modal.dart';
import 'package:mindvibe_app/features/audio_player/presentation/widgets/cover_image.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class SessionAudioPlayer extends ConsumerStatefulWidget {
  const SessionAudioPlayer({
    super.key,
    required this.url,
    required this.title,
    required this.onCompleted,
    this.coverUrl,
    this.subtitle,
    this.onFailed,
    this.queue = const [],
    this.followNowPlaying = false,
    this.audioId,
    this.countsForProgress = false,
    this.autoPlay = true,
    this.aboutTitle,
    this.aboutBody,
    this.waitToPlayLabel,
  });

  final String url;
  final String title;
  final String? coverUrl;
  final String? subtitle;
  final VoidCallback onCompleted;
  final VoidCallback? onFailed;
  final List<NowPlayingTrack> queue;
  final bool followNowPlaying;
  final int? audioId;
  final bool countsForProgress;
  final bool autoPlay;
  final String? aboutTitle;
  final String? aboutBody;
  final String? waitToPlayLabel;

  @override
  ConsumerState<SessionAudioPlayer> createState() => _SessionAudioPlayerState();
}

class _SessionAudioPlayerState extends ConsumerState<SessionAudioPlayer> {
  bool _completedNotified = false;
  double? _dragProgress;
  bool _briefingReady = false;
  bool _briefingOpen = false;

  String get _trackId => '${widget.url}|${widget.title}';

  NowPlayingTrack get _track => NowPlayingTrack(
    id: _trackId,
    url: widget.url,
    title: widget.title,
    coverUrl: widget.coverUrl,
    subtitle: widget.subtitle,
    audioId: widget.audioId,
    countsForProgress: widget.countsForProgress,
  );

  @override
  void initState() {
    super.initState();
    _briefingReady = !_needsBriefing;
    WidgetsBinding.instance.addPostFrameCallback((_) => _onReady());
  }

  bool get _needsBriefing =>
      !widget.autoPlay &&
      widget.waitToPlayLabel != null &&
      widget.waitToPlayLabel!.trim().isNotEmpty;

  @override
  void didUpdateWidget(covariant SessionAudioPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _completedNotified = false;
      _briefingReady = !_needsBriefing;
      _onReady();
    }
  }

  Future<void> _onReady() async {
    if (widget.autoPlay) {
      await _ensurePlaying();
      return;
    }
    final playing = ref.read(nowPlayingProvider);
    if (playing.track != null && playing.track!.id != _trackId) {
      await ref.read(nowPlayingProvider.notifier).stop();
    }
    await _ensureBriefing();
  }

  Future<void> _ensureBriefing() async {
    if (!_needsBriefing || _briefingReady || _briefingOpen || !mounted) {
      return;
    }
    _briefingOpen = true;
    final l10n = AppLocalizations.of(context);
    await showAudioBriefingModal(
      context: context,
      title: widget.aboutTitle ?? l10n.sessionAudioObjectiveTitle,
      objective: (widget.aboutBody ?? l10n.sessionAudioObjectiveFallback)
          .trim(),
      waitHint: widget.waitToPlayLabel!,
      confirmLabel: l10n.prepareStart,
      coverUrl: widget.coverUrl,
    );
    _briefingOpen = false;
    if (mounted) {
      setState(() => _briefingReady = true);
    }
  }

  Future<void> _playOrResume() async {
    await _ensureBriefing();
    if (!mounted) {
      return;
    }
    final playing = ref.read(nowPlayingProvider);
    if (playing.track?.id != _trackId) {
      await _ensurePlaying();
      return;
    }
    await ref.read(nowPlayingProvider.notifier).toggle();
  }

  Future<void> _ensurePlaying() async {
    await ref
        .read(nowPlayingProvider.notifier)
        .play(_track, queue: widget.queue.isEmpty ? null : widget.queue);
  }

  Object get _coverTag => 'cover-$_trackId';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final playing = ref.watch(nowPlayingProvider);
    final favorites = ref.watch(favoriteTracksProvider);
    ref.listen(nowPlayingProvider, (previous, next) {
      if (next.track?.id != _trackId) {
        return;
      }
      if (next.ui == AudioPlayerUiState.completed && !_completedNotified) {
        _completedNotified = true;
        widget.onCompleted();
      }
      if (next.ui == AudioPlayerUiState.error) {
        widget.onFailed?.call();
      }
    });
    final display = widget.followNowPlaying ? playing.track ?? _track : _track;
    final active = playing.track?.id == display.id;
    final ui = active
        ? playing.ui
        : (widget.autoPlay
              ? AudioPlayerUiState.loading
              : AudioPlayerUiState.idle);
    final aboutTitle = widget.aboutTitle ?? l10n.playerAboutTitle;
    final aboutBody = widget.aboutBody ?? l10n.playerAboutBody;
    final showAboutCard = !_needsBriefing;
    final position = active ? playing.position : Duration.zero;
    final duration = active ? playing.duration : Duration.zero;
    final progress =
        _dragProgress ??
        (duration.inMilliseconds == 0
            ? 0.0
            : position.inMilliseconds / duration.inMilliseconds);
    final volume = playing.volume.clamp(0.0, 1.0);
    final favorited = favorites.contains(display.id);
    final scheme = Theme.of(context).colorScheme;
    final night = Theme.of(context).brightness == Brightness.dark;
    final player = ref.read(nowPlayingProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _CoverProgress(
          progress: progress.clamp(0, 1),
          playing: ui == AudioPlayerUiState.playing,
          child: ScaleOnTap(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => showCoverLightbox(
                context,
                url: display.coverUrl,
                heroTag: _coverTag,
              ),
              child: Hero(
                tag: _coverTag,
                child: CoverImage(
                  url: display.coverUrl,
                  size: 236,
                  circular: true,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          child: Text(
            display.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              height: 1.2,
              letterSpacing: -0.3,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: Text(
            [
              if (display.subtitle != null && display.subtitle!.isNotEmpty)
                display.subtitle,
              if (duration > Duration.zero)
                l10n.exerciseDurationMinutes(
                  duration.inMinutes == 0 ? 1 : duration.inMinutes,
                ),
            ].join(' · '),
            textAlign: TextAlign.center,
            style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 14),
          ),
        ),
        const SizedBox(height: 28),
        if (ui == AudioPlayerUiState.error)
          AppError(
            message: l10n.playerLoadError,
            retryLabel: l10n.actionRetry,
            onRetry: _ensurePlaying,
          )
        else ...[
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primarySoft,
              inactiveTrackColor: night
                  ? Colors.white.withValues(alpha: 0.12)
                  : AppColors.surfaceMuted,
              thumbColor: AppColors.primarySoft,
              overlayColor: AppColors.primarySoft.withValues(alpha: 0.12),
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            ),
            child: Slider(
              value: progress.clamp(0, 1),
              onChanged: (value) => setState(() => _dragProgress = value),
              onChangeEnd: (value) {
                setState(() => _dragProgress = null);
                if (duration.inMilliseconds == 0) {
                  return;
                }
                player.seek(
                  Duration(
                    milliseconds: (duration.inMilliseconds * value).round(),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Text(
                  _format(position),
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontSize: 12,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const Spacer(),
                Text(
                  _format(duration),
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontSize: 12,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const SizedBox(width: 48),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      tooltip: l10n.playerPrevious,
                      onPressed: player.playPrevious,
                      icon: const Icon(Icons.skip_previous_rounded),
                      iconSize: 36,
                      color: scheme.onSurface,
                    ),
                    const SizedBox(width: 8),
                    ScaleOnTap(
                      child: FilledButton(
                        onPressed: _playOrResume,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(76, 76),
                          maximumSize: const Size(76, 76),
                          padding: EdgeInsets.zero,
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          shape: const CircleBorder(),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          transitionBuilder: fadeScaleSwitcher,
                          child: ui == AudioPlayerUiState.loading
                              ? const AppLoading.compact(
                                  key: ValueKey('loading'),
                                  color: AppColors.onPrimary,
                                  compactSize: 26,
                                )
                              : Icon(
                                  ui == AudioPlayerUiState.playing
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  key: ValueKey(
                                    ui == AudioPlayerUiState.playing,
                                  ),
                                  size: 36,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: l10n.playerNext,
                      onPressed: playing.hasNext ? player.playNext : null,
                      icon: const Icon(Icons.skip_next_rounded),
                      iconSize: 36,
                      color: scheme.onSurface,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 48,
                child: IconButton(
                  tooltip: l10n.playerRepeat,
                  onPressed: () => player.setLooping(!playing.looping),
                  icon: Icon(
                    playing.looping
                        ? Icons.repeat_one_rounded
                        : Icons.repeat_rounded,
                  ),
                  color: playing.looping
                      ? AppColors.primarySoft
                      : scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _QuickAction(
                icon: favorited
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                label: favorited ? l10n.playerFavorited : l10n.playerFavorite,
                active: favorited,
                onTap: () => ref
                    .read(favoriteTracksProvider.notifier)
                    .toggle(display.id),
              ),
              const SizedBox(width: 40),
              _QuickAction(
                icon: Icons.timer_outlined,
                label: playing.sleepRemaining == null
                    ? l10n.playerTimer
                    : _format(playing.sleepRemaining!),
                active: playing.sleepRemaining != null,
                onTap: () => _openTimerSheet(l10n),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                tooltip: l10n.playerVolume,
                onPressed: player.toggleMute,
                icon: Icon(
                  volume == 0
                      ? Icons.volume_off_rounded
                      : volume < 0.4
                      ? Icons.volume_down_rounded
                      : Icons.volume_up_rounded,
                  color: AppColors.accent,
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.accent,
                    inactiveTrackColor: night
                        ? Colors.white.withValues(alpha: 0.12)
                        : AppColors.border,
                    thumbColor: AppColors.accent,
                    overlayColor: AppColors.accent.withValues(alpha: 0.12),
                    trackHeight: 3,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                  ),
                  child: Slider(value: volume, onChanged: player.setVolume),
                ),
              ),
            ],
          ),
          if (showAboutCard) ...[
            const SizedBox(height: 8),
            AppCard(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
              child: Row(
                children: [
                  Icon(
                    Icons.nights_stay_outlined,
                    color: scheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          aboutTitle,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          aboutBody,
                          style: TextStyle(
                            color: scheme.onSurfaceVariant,
                            fontSize: 13,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ],
    );
  }

  Future<void> _openTimerSheet(AppLocalizations l10n) async {
    final player = ref.read(nowPlayingProvider.notifier);
    final chosen = await showModalBottomSheet<Duration?>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(l10n.playerTimerOff),
                onTap: () => Navigator.pop(context, Duration.zero),
              ),
              for (final minutes in const [5, 10, 15, 30, 45])
                ListTile(
                  title: Text(l10n.exerciseDurationMinutes(minutes)),
                  onTap: () =>
                      Navigator.pop(context, Duration(minutes: minutes)),
                ),
            ],
          ),
        );
      },
    );
    if (chosen == null) {
      return;
    }
    await player.setSleepTimer(chosen == Duration.zero ? null : chosen);
  }

  String _format(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }
}

class _CoverProgress extends StatelessWidget {
  const _CoverProgress({
    required this.progress,
    required this.playing,
    required this.child,
  });

  final double progress;
  final bool playing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Pulse(
        enabled: playing,
        minScale: 0.985,
        maxScale: 1.015,
        duration: const Duration(milliseconds: 2400),
        child: SizedBox(
          width: 268,
          height: 268,
          child: CustomPaint(
            painter: _ProgressRingPainter(
              progress: progress,
              color: AppColors.primarySoft,
              track: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withValues(alpha: 0.12)
                  : AppColors.surfaceMuted,
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  const _ProgressRingPainter({
    required this.progress,
    required this.color,
    required this.track,
  });

  final double progress;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) / 2) - 5;
    final trackPaint = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress.clamp(0, 1),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.track != track;
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active
        ? AppColors.primarySoft
        : Theme.of(context).colorScheme.onSurfaceVariant;
    return ScaleOnTap(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: SizedBox(
            width: 96,
            child: Column(
              children: [
                Icon(icon, color: color),
                const SizedBox(height: 6),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: color, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
