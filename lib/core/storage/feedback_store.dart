import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackPrefs {
  const FeedbackPrefs({
    this.hapticsEnabled = true,
    this.sfxEnabled = true,
    this.audioVolume = 1,
  });

  final bool hapticsEnabled;
  final bool sfxEnabled;
  final double audioVolume;

  FeedbackPrefs copyWith({
    bool? hapticsEnabled,
    bool? sfxEnabled,
    double? audioVolume,
  }) {
    return FeedbackPrefs(
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      sfxEnabled: sfxEnabled ?? this.sfxEnabled,
      audioVolume: audioVolume ?? this.audioVolume,
    );
  }
}

final feedbackProvider =
    StateNotifierProvider<FeedbackController, FeedbackPrefs>((ref) {
      return FeedbackController();
    });

class FeedbackController extends StateNotifier<FeedbackPrefs> {
  FeedbackController() : super(const FeedbackPrefs()) {
    _load();
  }

  static const _hapticsKey = 'feedback_haptics';
  static const _sfxKey = 'feedback_sfx';
  static const _volumeKey = 'feedback_audio_volume';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) {
      return;
    }
    state = FeedbackPrefs(
      hapticsEnabled: prefs.getBool(_hapticsKey) ?? true,
      sfxEnabled: prefs.getBool(_sfxKey) ?? true,
      audioVolume: (prefs.getDouble(_volumeKey) ?? 1).clamp(0.0, 1.0),
    );
    AppFeedback.sync(state);
  }

  Future<void> setHaptics(bool enabled) async {
    state = state.copyWith(hapticsEnabled: enabled);
    AppFeedback.sync(state);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hapticsKey, enabled);
  }

  Future<void> setSfx(bool enabled) async {
    state = state.copyWith(sfxEnabled: enabled);
    AppFeedback.sync(state);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sfxKey, enabled);
  }

  Future<void> setAudioVolume(double volume) async {
    final value = volume.clamp(0.0, 1.0);
    state = state.copyWith(audioVolume: value);
    AppFeedback.sync(state);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_volumeKey, value);
  }
}

class AppFeedback {
  static bool hapticsEnabled = true;
  static bool sfxEnabled = true;
  static double audioVolume = 1;

  static void sync(FeedbackPrefs prefs) {
    hapticsEnabled = prefs.hapticsEnabled;
    sfxEnabled = prefs.sfxEnabled;
    audioVolume = prefs.audioVolume;
  }

  static Future<void> selection() async {
    if (!hapticsEnabled) {
      return;
    }
    await HapticFeedback.selectionClick();
  }

  static Future<void> light() async {
    if (!hapticsEnabled) {
      return;
    }
    await HapticFeedback.lightImpact();
  }

  static Future<void> medium() async {
    if (!hapticsEnabled) {
      return;
    }
    await HapticFeedback.mediumImpact();
  }

  static Future<void> heavy() async {
    if (!hapticsEnabled) {
      return;
    }
    await HapticFeedback.heavyImpact();
  }

  static Future<void> completion() async {
    if (hapticsEnabled) {
      await HapticFeedback.mediumImpact();
    }
    if (sfxEnabled) {
      await SystemSound.play(SystemSoundType.click);
    }
  }
}
