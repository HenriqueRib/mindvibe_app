import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindvibe_app/core/notifications/notification_scheduler.dart';
import 'package:mindvibe_app/core/providers/core_providers.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';
import 'package:uuid/uuid.dart';

enum PomodoroPhase { focus, rest }

class PomodoroPreset {
  const PomodoroPreset({required this.focus, required this.rest});

  final Duration focus;
  final Duration rest;

  static const classic = PomodoroPreset(
    focus: Duration(minutes: 25),
    rest: Duration(minutes: 5),
  );
  static const short = PomodoroPreset(
    focus: Duration(minutes: 15),
    rest: Duration(minutes: 5),
  );
  static const long = PomodoroPreset(
    focus: Duration(minutes: 50),
    rest: Duration(minutes: 10),
  );
}

class PomodoroState {
  const PomodoroState({
    this.phase = PomodoroPhase.focus,
    this.running = false,
    this.preset = PomodoroPreset.classic,
    this.remaining = const Duration(minutes: 25),
    this.endsAt,
    this.rounds = 0,
  });

  final PomodoroPhase phase;
  final bool running;
  final PomodoroPreset preset;
  final Duration remaining;
  final DateTime? endsAt;
  final int rounds;

  Duration get total =>
      phase == PomodoroPhase.focus ? preset.focus : preset.rest;

  double get progress {
    final totalMs = total.inMilliseconds;
    if (totalMs <= 0) {
      return 1;
    }
    return (1 - remaining.inMilliseconds / totalMs).clamp(0.0, 1.0);
  }

  PomodoroState copyWith({
    PomodoroPhase? phase,
    bool? running,
    PomodoroPreset? preset,
    Duration? remaining,
    DateTime? endsAt,
    int? rounds,
    bool clearEndsAt = false,
  }) {
    return PomodoroState(
      phase: phase ?? this.phase,
      running: running ?? this.running,
      preset: preset ?? this.preset,
      remaining: remaining ?? this.remaining,
      endsAt: clearEndsAt ? null : (endsAt ?? this.endsAt),
      rounds: rounds ?? this.rounds,
    );
  }
}

class PomodoroController extends StateNotifier<PomodoroState> {
  PomodoroController(this._notifications, {this.onFocusCompleted})
    : super(const PomodoroState());

  final NotificationScheduler _notifications;
  final Future<void> Function(Duration focus)? onFocusCompleted;
  Timer? _tick;
  bool _completing = false;

  void setPreset(PomodoroPreset preset) {
    if (state.running) {
      return;
    }
    state = PomodoroState(preset: preset, remaining: preset.focus);
  }

  void start() {
    if (state.running) {
      return;
    }
    final remaining = state.remaining <= Duration.zero
        ? state.total
        : state.remaining;
    state = state.copyWith(
      running: true,
      remaining: remaining,
      endsAt: DateTime.now().add(remaining),
    );
    _syncTick();
  }

  void pause() {
    if (!state.running) {
      return;
    }
    state = state.copyWith(
      running: false,
      remaining: _left(),
      clearEndsAt: true,
    );
    _syncTick();
  }

  void toggle() {
    if (state.running) {
      pause();
    } else {
      start();
    }
  }

  void reset() {
    _completing = false;
    state = PomodoroState(preset: state.preset, remaining: state.preset.focus);
    _syncTick();
  }

  Duration _left() {
    final endsAt = state.endsAt;
    if (!state.running || endsAt == null) {
      return state.remaining;
    }
    final left = endsAt.difference(DateTime.now());
    return left.isNegative ? Duration.zero : left;
  }

  void _syncTick() {
    if (!state.running) {
      _tick?.cancel();
      _tick = null;
      return;
    }
    _tick ??= Timer.periodic(const Duration(milliseconds: 250), (_) {
      final left = _left();
      if (left <= Duration.zero) {
        if (_completing) {
          return;
        }
        _completing = true;
        unawaited(_completePhase());
        return;
      }
      state = state.copyWith(remaining: left);
    });
  }

  Future<void> _completePhase() async {
    _tick?.cancel();
    _tick = null;
    try {
      await HapticFeedback.mediumImpact();
      final wasFocus = state.phase == PomodoroPhase.focus;
      final focusDuration = state.preset.focus;
      try {
        await _notifications.showNow(
          title: 'Pomodoro',
          body: wasFocus
              ? 'Foco concluído. Hora da pausa.'
              : 'Pausa concluída. Pronto para outro bloco.',
        );
      } catch (_) {}
      if (wasFocus) {
        unawaited(onFocusCompleted?.call(focusDuration) ?? Future.value());
      }
      final nextPhase = wasFocus ? PomodoroPhase.rest : PomodoroPhase.focus;
      final preset = state.preset;
      final nextRemaining = nextPhase == PomodoroPhase.focus
          ? preset.focus
          : preset.rest;
      state = state.copyWith(
        phase: nextPhase,
        running: true,
        remaining: nextRemaining,
        endsAt: DateTime.now().add(nextRemaining),
        rounds: wasFocus ? state.rounds + 1 : state.rounds,
      );
    } finally {
      _completing = false;
      _syncTick();
    }
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }
}

final pomodoroProvider =
    StateNotifierProvider<PomodoroController, PomodoroState>((ref) {
      return PomodoroController(
        ref.watch(notificationSchedulerProvider),
        onFocusCompleted: (focus) async {
          await ref
              .read(trainingRepositoryProvider)
              .recordActivity(
                type: 'pomodoro',
                clientEventId: const Uuid().v4(),
                durationSeconds: focus.inSeconds,
                meta: {'focus_minutes': focus.inMinutes},
              );
          ref.invalidate(historyProvider);
        },
      );
    });
