import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/core/providers/core_providers.dart';
import 'package:mindvibe_app/features/audio_player/presentation/providers/now_playing_controller.dart';
import 'package:mindvibe_app/features/audio_player/presentation/widgets/cover_image.dart';
import 'package:mindvibe_app/features/audio_player/presentation/widgets/session_audio_player.dart';
import 'package:mindvibe_app/features/exercises/domain/breathing_cycle.dart';
import 'package:mindvibe_app/features/exercises/domain/exercise_parsers.dart';
import 'package:mindvibe_app/features/exercises/presentation/widgets/attention_exercise_view.dart';
import 'package:mindvibe_app/features/exercises/presentation/widgets/breathing_exercise_view.dart';
import 'package:mindvibe_app/features/exercises/presentation/widgets/memory_exercise_view.dart';
import 'package:mindvibe_app/features/exercises/presentation/widgets/memory_words_editor.dart';
import 'package:mindvibe_app/features/exercises/presentation/widgets/prepared_exercise.dart';
import 'package:mindvibe_app/features/exercises/presentation/widgets/rating_exercise_view.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/features/training/presentation/providers/session_runner.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';
import 'package:mindvibe_app/features/training/presentation/widgets/session_completing_view.dart';
import 'package:mindvibe_app/features/training/presentation/widgets/session_instruction_view.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class SessionPage extends ConsumerStatefulWidget {
  const SessionPage({
    super.key,
    required this.sessionId,
    this.skipPrepare = false,
  });

  final int sessionId;
  final bool skipPrepare;

  @override
  ConsumerState<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends ConsumerState<SessionPage> {
  bool _audioDone = false;
  bool _submitting = false;
  bool _prepareConsumed = false;
  bool _leaving = false;
  Timer? _clock;

  @override
  void initState() {
    super.initState();
    _clock = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _clock?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(liveSessionControllerProvider(widget.sessionId));
    final runner = ref.read(
      liveSessionControllerProvider(widget.sessionId).notifier,
    );
    ref.listen(liveSessionControllerProvider(widget.sessionId), (
      previous,
      next,
    ) {
      if (widget.skipPrepare &&
          !_prepareConsumed &&
          next.stage == SessionStage.prepare) {
        _prepareConsumed = true;
        runner.begin();
      }
      if (previous?.blockIndex != next.blockIndex) {
        _audioDone = false;
      }
      if (next.stage == SessionStage.completed) {
        ref.invalidate(pausedTrainingProvider);
      }
    });

    final night = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        }
        unawaited(_leaveTraining());
      },
      child: AppScaffold(
        showBack: state.stage != SessionStage.completing,
        title: state.stage == SessionStage.loading ||
                state.stage == SessionStage.completing
            ? null
            : state.session?.title,
        backgroundColor: night ? AppColors.nightBackground : null,
        actions: [
          if (state.stage == SessionStage.playing &&
              state.playingStartedAt != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  _elapsed(state.playingStartedAt!),
                  style: const TextStyle(
                    fontFeatures: [FontFeature.tabularFigures()],
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
        ],
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 380),
          switchInCurve: Curves.easeOutCubic,
          child: KeyedSubtree(
            key: ValueKey(
              '${state.stage}-${state.blockIndex}-${state.currentBlock?.id}',
            ),
            child: switch (state.stage) {
              SessionStage.loading => const SessionAtmosphereView.loading(),
              SessionStage.completing => const SessionAtmosphereView.completing(),
              SessionStage.error => AppError(
                message: failureMessage(state.failure!, l10n),
                retryLabel: l10n.actionRetry,
                onRetry: () {
                  if (state.failure?.isContentAccessDenied ?? false) {
                    context.go(AppRoutes.paywall);
                    return;
                  }
                  runner.start();
                },
              ),
              SessionStage.prepare => _prepare(l10n, state, runner),
              SessionStage.completed => _completed(l10n, state),
              SessionStage.playing => _playing(l10n, state, runner),
            },
          ),
        ),
      ),
    );
  }

  Future<void> _leaveTraining() async {
    if (_leaving) {
      return;
    }
    final state = ref.read(liveSessionControllerProvider(widget.sessionId));
    if (state.stage == SessionStage.completing) {
      return;
    }
    _leaving = true;
    try {
      if (state.stage == SessionStage.playing) {
        await ref.read(nowPlayingProvider.notifier).pauseIfPlaying();
        await ref
            .read(liveSessionControllerProvider(widget.sessionId).notifier)
            .pauseAway();
        ref.invalidate(pausedTrainingProvider);
      } else if (state.stage == SessionStage.prepare) {
        await ref
            .read(liveSessionControllerProvider(widget.sessionId).notifier)
            .pauseAway();
        ref.invalidate(pausedTrainingProvider);
      }
      if (!mounted) {
        return;
      }
      context.go(AppRoutes.home);
    } finally {
      _leaving = false;
    }
  }

  String _elapsed(DateTime startedAt) {
    final elapsed = DateTime.now().difference(startedAt);
    final minutes = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (elapsed.inHours > 0) {
      return '${elapsed.inHours}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  Widget _prepare(
    AppLocalizations l10n,
    LiveSessionState state,
    LiveSessionController runner,
  ) {
    return FadeSlideIn(
      child: Column(
        children: [
          const Spacer(),
          CoverImage(url: state.session?.coverUrl, size: 180, radius: 24),
          const SizedBox(height: 24),
          AppText.title(l10n.sessionPrepareTitle, align: TextAlign.center),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: AppText.subtitle(
              l10n.sessionPrepareBody(state.session?.estimatedMinutes ?? 0),
              align: TextAlign.center,
            ),
          ),
          const Spacer(),
          ScaleOnTap(
            child: AppButton(label: l10n.prepareStart, onPressed: runner.begin),
          ),
        ],
      ),
    );
  }

  Widget _completed(AppLocalizations l10n, LiveSessionState state) {
    final completion = state.completion;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.title(l10n.sessionCompleteTitle),
        const SizedBox(height: 12),
        AppText.subtitle(l10n.homeCompleted),
        if (completion != null) ...[
          const SizedBox(height: 24),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.sessionXpAwarded(completion.xpAwarded),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text('${l10n.homeStreak}: ${completion.streakDays}'),
                if (completion.levelName != null)
                  Text('${l10n.progressLevel}: ${completion.levelName}'),
              ],
            ),
          ),
          if (completion.perceivedFocusCopy != null) ...[
            const SizedBox(height: 16),
            AppCard(child: Text(completion.perceivedFocusCopy!)),
          ],
        ],
        const Spacer(),
        AppButton(
          label: l10n.sessionSeeYouTomorrow,
          onPressed: () {
            ref.invalidate(todayProvider);
            ref.invalidate(progressProvider);
            context.go(AppRoutes.home);
          },
        ),
        const SizedBox(height: 8),
        AppButton(
          label: l10n.homeSeePlan,
          variant: AppButtonVariant.ghost,
          onPressed: () {
            ref.invalidate(todayProvider);
            ref.invalidate(progressProvider);
            context.go(AppRoutes.plan);
          },
        ),
      ],
    );
  }

  Widget _playing(
    AppLocalizations l10n,
    LiveSessionState state,
    LiveSessionController runner,
  ) {
    final block = state.currentBlock;
    if (block == null) {
      return AppEmpty(title: l10n.emptyTitle);
    }
    if (!block.access.contentAccess) {
      return Column(
        children: [
          AppText.title(l10n.paywallTitle),
          const Spacer(),
          AppButton(
            label: l10n.actionSubscribe,
            onPressed: () => context.push(AppRoutes.paywall),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SessionProgressHeader(
          current: state.blockIndex + 1,
          total: state.totalBlocks,
          label: l10n.sessionBlockOf(state.blockIndex + 1, state.totalBlocks),
        ),
        const SizedBox(height: 18),
        Expanded(child: _block(l10n, block, runner)),
      ],
    );
  }

  Widget _block(
    AppLocalizations l10n,
    SessionBlock block,
    LiveSessionController runner,
  ) {
    return switch (block.type) {
      'instruction' => SessionInstructionView(
        body: block.body ?? '',
        continueLabel: l10n.actionContinue,
        onContinue: runner.next,
      ),
      'audio' => _audioBlock(l10n, block, runner),
      'exercise' => _exerciseBlock(l10n, block, runner),
      'assessment' => _assessmentBlock(l10n, block, runner),
      _ => Column(
        children: [
          AppText.subtitle(l10n.unknownExercise),
          const Spacer(),
          AppButton(label: l10n.actionSkip, onPressed: runner.next),
        ],
      ),
    };
  }

  Widget _audioBlock(
    AppLocalizations l10n,
    SessionBlock block,
    LiveSessionController runner,
  ) {
    final url = block.audio?.url;
    if (url == null || url.isEmpty) {
      return Column(
        children: [
          AppText.subtitle(l10n.errorGeneric),
          const Spacer(),
          AppButton(label: l10n.actionContinue, onPressed: runner.next),
        ],
      );
    }
    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: SessionAudioPlayer(
                      key: ValueKey(block.id),
                      url: url,
                      title: block.audio?.title ?? '',
                      autoPlay: false,
                      waitToPlayLabel: l10n.sessionAudioWait,
                      aboutTitle: l10n.sessionAudioObjectiveTitle,
                      aboutBody: block.body?.trim().isNotEmpty == true
                          ? block.body
                          : l10n.sessionAudioObjectiveFallback,
                      coverUrl:
                          block.audio?.coverUrl ??
                          ref
                              .read(
                                liveSessionControllerProvider(widget.sessionId),
                              )
                              .session
                              ?.coverUrl,
                      subtitle: ref
                          .read(liveSessionControllerProvider(widget.sessionId))
                          .session
                          ?.title,
                      onCompleted: () => setState(() => _audioDone = true),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        AppButton(
          label: l10n.actionContinue,
          onPressed: _audioDone
              ? () {
                  ref.read(nowPlayingProvider.notifier).stop();
                  setState(() => _audioDone = false);
                  runner.next();
                }
              : null,
        ),
      ],
    );
  }

  Widget _exerciseBlock(
    AppLocalizations l10n,
    SessionBlock block,
    LiveSessionController runner,
  ) {
    final exercise = block.exercise;
    if (exercise == null) {
      return AppButton(label: l10n.actionSkip, onPressed: runner.next);
    }
    Future<void> submit(Map<String, dynamic> payload) async {
      if (_submitting) {
        return;
      }
      _submitting = true;
      await ref
          .read(trainingRepositoryProvider)
          .submitExerciseResult(
            exerciseId: exercise.id,
            userSessionId: ref
                .read(liveSessionControllerProvider(widget.sessionId))
                .session
                ?.userSessionId,
            payload: payload,
          );
      _submitting = false;
      await runner.next();
    }

    return switch (exercise.type) {
      'rating' => RatingExerciseView(
        title: exercise.title,
        body: block.body,
        config: RatingConfig.fromJson(exercise.configuration),
        onSubmit: (value) => submit({'value': value, 'completed': true}),
      ),
      'breathing' => () {
        final config = BreathingCycleConfig.fromJson(
          exercise.configuration ?? const {},
        );
        return PreparedExercise(
          key: ValueKey('ex-${exercise.id}'),
          type: 'breathing',
          briefingBody: block.body,
          variant: config.variant.name,
          defaultSeconds: config.cycles * config.cycleSeconds,
          builder: (seconds) {
            return SizedBox.expand(
              child: ColoredBox(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.nightBackground
                    : Theme.of(context).scaffoldBackgroundColor,
                child: BreathingExerciseView(
                  config: config,
                  sessionSeconds: seconds,
                  onCompleted: (durationMs) => submit({
                    'cycles_completed': config.cycles,
                    'duration_ms': durationMs,
                    'completed': true,
                  }),
                ),
              ),
            );
          },
        );
      }(),
      'attention' => () {
        final attention = AttentionConfig.fromJson(exercise.configuration);
        return PreparedExercise(
          key: ValueKey('ex-${exercise.id}'),
          type: 'attention',
          briefingBody: block.body,
          defaultSeconds: attention.durationSeconds,
          target: attention.target,
          variant: attention.variant.name,
          builder: (seconds) => AttentionExerciseView(
            config: attention,
            sessionSeconds: seconds,
            onCompleted: (score) => submit({
              'hits': score.hits,
              'misses': score.misses,
              'duration_ms': score.durationMs,
              'completed': true,
            }),
          ),
        );
      }(),
      'memory' => () {
        final memory = MemoryConfig.fromJson(
          exercise.configuration,
          extraWords: ref.watch(memoryWordsProvider).valueOrNull ?? const [],
        );
        final showWords =
            memory.variant == MemoryVariant.words ||
            memory.variant == MemoryVariant.delayed;
        return PreparedExercise(
          key: ValueKey('ex-${exercise.id}'),
          type: 'memory',
          briefingBody: block.body,
          defaultSeconds: 60,
          variant: memory.variant.name,
          briefingExtra: showWords ? const MemoryWordsButton() : null,
          builder: (seconds) => MemoryExerciseView(
            config: memory,
            sessionSeconds: seconds,
            onCompleted: (score) => submit({
              'hits': score.hits,
              'misses': score.misses,
              'selected': score.selected,
              'completed': true,
            }),
          ),
        );
      }(),
      _ => Column(
        children: [
          AppText.subtitle(l10n.unknownExercise),
          const Spacer(),
          AppButton(label: l10n.actionSkip, onPressed: runner.next),
        ],
      ),
    };
  }

  Widget _assessmentBlock(
    AppLocalizations l10n,
    SessionBlock block,
    LiveSessionController runner,
  ) {
    final assessment = block.assessment;
    final question = assessment?.questions.isNotEmpty == true
        ? assessment!.questions.first
        : null;
    if (assessment == null || question == null) {
      return AppButton(label: l10n.actionSkip, onPressed: runner.next);
    }
    return RatingExerciseView(
      title: question.prompt,
      body: block.body,
      config: RatingConfig.fromJson(question.configuration),
      onSubmit: (value) async {
        if (_submitting) {
          return;
        }
        _submitting = true;
        await ref
            .read(trainingRepositoryProvider)
            .submitAssessment(
              assessmentId: assessment.id,
              userSessionId: ref
                  .read(liveSessionControllerProvider(widget.sessionId))
                  .session
                  ?.userSessionId,
              answers: [
                {'question_id': question.id, 'value': value},
              ],
            );
        _submitting = false;
        await runner.next();
      },
    );
  }
}

class _SessionProgressHeader extends StatelessWidget {
  const _SessionProgressHeader({
    required this.current,
    required this.total,
    required this.label,
  });

  final int current;
  final int total;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final value = total <= 0 ? 0.0 : current / total;
    return Column(
      children: [
        AppProgressBar(value: value),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(99),
            border: Border.all(color: scheme.outline),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
              color: scheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
