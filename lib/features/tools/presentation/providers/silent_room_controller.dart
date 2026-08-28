import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindvibe_app/core/notifications/notification_scheduler.dart';
import 'package:mindvibe_app/core/providers/core_providers.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';
import 'package:uuid/uuid.dart';

class SilentRoomState {
  const SilentRoomState({
    this.minutes = 5,
    this.running = false,
    this.remaining = const Duration(minutes: 5),
    this.endsAt,
    this.completed = false,
  });

  final int minutes;
  final bool running;
  final Duration remaining;
  final DateTime? endsAt;
  final bool completed;

  Duration get total => Duration(minutes: minutes);

  double get progress {
    final totalMs = total.inMilliseconds;
    if (totalMs <= 0) {
      return 1;
    }
    return (1 - remaining.inMilliseconds / totalMs).clamp(0.0, 1.0);
  }

  SilentRoomState copyWith({
    int? minutes,
    bool? running,
    Duration? remaining,
    DateTime? endsAt,
    bool? completed,
    bool clearEndsAt = false,
  }) {
    return SilentRoomState(
      minutes: minutes ?? this.minutes,
      running: running ?? this.running,
      remaining: remaining ?? this.remaining,
      endsAt: clearEndsAt ? null : (endsAt ?? this.endsAt),
      completed: completed ?? this.completed,
    );
  }
}

class SilentRoomController extends StateNotifier<SilentRoomState> {
  SilentRoomController(this._notifications, {this.onCompleted})
    : super(const SilentRoomState());

  static const lengths = [1, 5, 10, 20];

  final NotificationScheduler _notifications;
  final Future<void> Function(Duration block)? onCompleted;
  Timer? _tick;
  bool _completing = false;

  void setMinutes(int minutes) {
    if (state.running || !lengths.contains(minutes)) {
      return;
    }
    state = SilentRoomState(
      minutes: minutes,
      remaining: Duration(minutes: minutes),
    );
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
      completed: false,
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
    state = SilentRoomState(
      minutes: state.minutes,
      remaining: Duration(minutes: state.minutes),
    );
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
        unawaited(_complete());
        return;
      }
      state = state.copyWith(remaining: left);
    });
  }

  Future<void> _complete() async {
    _tick?.cancel();
    _tick = null;
    final block = state.total;
    try {
      await HapticFeedback.mediumImpact();
      try {
        await _notifications.showNow(
          title: 'Sala silenciosa',
          body: 'Bloco concluído. Pode voltar quando quiser.',
          id: 45,
        );
      } catch (_) {}
      unawaited(onCompleted?.call(block) ?? Future.value());
      state = SilentRoomState(
        minutes: state.minutes,
        remaining: Duration.zero,
        completed: true,
      );
    } finally {
      _completing = false;
    }
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }
}

final silentRoomProvider =
    StateNotifierProvider<SilentRoomController, SilentRoomState>((ref) {
      return SilentRoomController(
        ref.watch(notificationSchedulerProvider),
        onCompleted: (block) async {
          await ref
              .read(trainingRepositoryProvider)
              .recordActivity(
                type: 'silent_room',
                clientEventId: const Uuid().v4(),
                durationSeconds: block.inSeconds,
                meta: {'minutes': block.inMinutes},
              );
          ref.invalidate(historyProvider);
        },
      );
    });
