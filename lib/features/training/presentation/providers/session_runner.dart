import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindvibe_app/core/error/app_failure.dart';
import 'package:mindvibe_app/core/providers/core_providers.dart';
import 'package:mindvibe_app/core/storage/paused_training_store.dart';
import 'package:mindvibe_app/core/storage/pending_session_store.dart';
import 'package:mindvibe_app/features/analytics/data/analytics_client.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/features/training/domain/repositories/training_repository.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';

enum SessionStage { loading, prepare, playing, completing, completed, error }

class LiveSessionState {
  const LiveSessionState({
    required this.stage,
    this.session,
    this.blockIndex = 0,
    this.completion,
    this.failure,
    this.playingStartedAt,
  });

  final SessionStage stage;
  final TrainingSessionDetail? session;
  final int blockIndex;
  final SessionCompletion? completion;
  final AppFailure? failure;
  final DateTime? playingStartedAt;

  SessionBlock? get currentBlock {
    final blocks = session?.blocks;
    if (blocks == null || blockIndex < 0 || blockIndex >= blocks.length) {
      return null;
    }
    return blocks[blockIndex];
  }

  int get totalBlocks => session?.blocks.length ?? 0;
}

class LiveSessionController extends StateNotifier<LiveSessionState> {
  LiveSessionController({
    required this.sessionId,
    required TrainingRepository training,
    required AnalyticsClient analytics,
    required PendingSessionStore pending,
    required PausedTrainingStore paused,
  }) : _training = training,
       _analytics = analytics,
       _pending = pending,
       _paused = paused,
       super(const LiveSessionState(stage: SessionStage.loading)) {
    unawaited(start());
  }

  final int sessionId;
  final TrainingRepository _training;
  final AnalyticsClient _analytics;
  final PendingSessionStore _pending;
  final PausedTrainingStore _paused;

  Future<void> start() async {
    state = const LiveSessionState(stage: SessionStage.loading);
    final result = await _training.startSession(sessionId);
    final session = result.valueOrNull;
    if (session == null) {
      state = LiveSessionState(
        stage: SessionStage.error,
        failure: result.failureOrNull,
      );
      return;
    }
    await _analytics.track('session_started', {
      'session_id': session.id,
      'user_session_id': session.userSessionId,
    });
    final paused = await _paused.read();
    if (paused != null &&
        paused.sessionId == sessionId &&
        session.blocks.isNotEmpty) {
      final index = paused.blockIndex.clamp(0, session.blocks.length - 1);
      state = LiveSessionState(
        stage: SessionStage.playing,
        session: session,
        blockIndex: index,
        playingStartedAt: paused.startedAtMs == null
            ? DateTime.now()
            : DateTime.fromMillisecondsSinceEpoch(paused.startedAtMs!),
      );
      _trackBlockStarted();
      return;
    }
    state = LiveSessionState(stage: SessionStage.prepare, session: session);
  }

  void begin() {
    final session = state.session;
    if (session == null) {
      return;
    }
    if (session.blocks.isEmpty) {
      complete();
      return;
    }
    state = LiveSessionState(
      stage: SessionStage.playing,
      session: session,
      playingStartedAt: DateTime.now(),
    );
    _trackBlockStarted();
  }

  Future<void> pauseAway() async {
    final session = state.session;
    if (state.stage != SessionStage.playing || session == null) {
      if (state.stage == SessionStage.prepare) {
        await _paused.clear();
      }
      return;
    }
    await _paused.save(
      PausedTraining(
        sessionId: sessionId,
        blockIndex: state.blockIndex,
        startedAtMs: state.playingStartedAt?.millisecondsSinceEpoch,
      ),
    );
  }

  Future<void> next() async {
    final session = state.session;
    if (session == null) {
      return;
    }
    final nextIndex = state.blockIndex + 1;
    if (nextIndex >= session.blocks.length) {
      await complete();
      return;
    }
    state = LiveSessionState(
      stage: SessionStage.playing,
      session: session,
      blockIndex: nextIndex,
      playingStartedAt: state.playingStartedAt,
    );
    _trackBlockStarted();
  }

  Future<void> complete() async {
    final session = state.session;
    state = LiveSessionState(
      stage: SessionStage.completing,
      session: session,
      blockIndex: state.blockIndex,
      playingStartedAt: state.playingStartedAt,
    );
    final result = await _training.completeSession(sessionId);
    final completion = result.valueOrNull;
    if (completion == null) {
      if (result.failureOrNull?.type == AppFailureType.offline) {
        await _pending.save(sessionId);
      }
      state = LiveSessionState(
        stage: SessionStage.error,
        session: session,
        failure: result.failureOrNull,
      );
      return;
    }
    await _pending.clear();
    await _paused.clear();
    await _analytics.track('session_completed', {
      'session_id': sessionId,
      'user_session_id': completion.userSessionId,
    });
    var enriched = completion;
    if (completion.programStatus == 'completed') {
      final report = await _training.weeklyReport();
      enriched = SessionCompletion(
        userSessionId: completion.userSessionId,
        idempotent: completion.idempotent,
        currentDayNumber: completion.currentDayNumber,
        programStatus: completion.programStatus,
        xpAwarded: completion.xpAwarded,
        xpTotal: completion.xpTotal,
        streakDays: completion.streakDays,
        levelName: completion.levelName,
        perceivedFocusCopy: report.valueOrNull?.perceivedFocusCopy,
      );
    }
    state = LiveSessionState(
      stage: SessionStage.completed,
      session: session,
      completion: enriched,
    );
  }

  void _trackBlockStarted() {
    final block = state.currentBlock;
    if (block == null) {
      return;
    }
    final event = switch (block.type) {
      'audio' => 'audio_started',
      'exercise' => 'exercise_started',
      'assessment' => 'assessment_started',
      _ => null,
    };
    if (event != null) {
      unawaited(
        _analytics.track(event, {
          'session_id': sessionId,
          'block_id': block.id,
        }),
      );
    }
  }
}

final liveSessionControllerProvider = StateNotifierProvider.autoDispose
    .family<LiveSessionController, LiveSessionState, int>((ref, sessionId) {
      return LiveSessionController(
        sessionId: sessionId,
        training: ref.watch(trainingRepositoryProvider),
        analytics: ref.watch(analyticsClientProvider),
        pending: ref.watch(pendingSessionStoreProvider),
        paused: ref.watch(pausedTrainingStoreProvider),
      );
    });
