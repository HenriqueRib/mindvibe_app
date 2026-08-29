import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/core/providers/core_providers.dart';
import 'package:mindvibe_app/features/exercises/domain/breathing_cycle.dart';
import 'package:mindvibe_app/features/exercises/domain/exercise_parsers.dart';
import 'package:mindvibe_app/features/exercises/presentation/widgets/attention_exercise_view.dart';
import 'package:mindvibe_app/features/exercises/presentation/widgets/breathing_exercise_view.dart';
import 'package:mindvibe_app/features/exercises/presentation/widgets/daily_drill_view.dart';
import 'package:mindvibe_app/features/exercises/presentation/widgets/memory_exercise_view.dart';
import 'package:mindvibe_app/features/exercises/presentation/widgets/memory_words_editor.dart';
import 'package:mindvibe_app/features/exercises/presentation/widgets/prepared_exercise.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class PracticeExercisePage extends ConsumerStatefulWidget {
  const PracticeExercisePage({super.key, required this.exercise});

  final ExerciseSpec exercise;

  @override
  ConsumerState<PracticeExercisePage> createState() =>
      _PracticeExercisePageState();
}

class _PracticeExercisePageState extends ConsumerState<PracticeExercisePage> {
  bool _submitting = false;
  MemoryConfig? _memory;

  MemoryConfig _memoryOf(Map<String, dynamic> config, List<String> extra) {
    return _memory ??= MemoryConfig.fromJson(config, extraWords: extra);
  }

  Future<void> _submit(Map<String, dynamic> payload) async {
    if (_submitting) {
      return;
    }
    _submitting = true;
    final l10n = AppLocalizations.of(context);
    final result = await ref
        .read(trainingRepositoryProvider)
        .submitExerciseResult(
          exerciseId: widget.exercise.id,
          userSessionId: null,
          payload: payload,
        );
    if (!mounted) {
      return;
    }
    _submitting = false;
    if (!result.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failureMessage(result.failureOrNull!, l10n))),
      );
      return;
    }
    ref.invalidate(progressProvider);
    ref.invalidate(historyProvider);
    final barStyle = Theme.of(context).snackBarTheme.contentTextStyle;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: barStyle?.color),
            const SizedBox(width: 12),
            Expanded(child: Text(l10n.exerciseRoomDone, style: barStyle)),
          ],
        ),
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final exercise = widget.exercise;
    final config = <String, dynamic>{
      ...?exercise.configuration,
      if ((exercise.variant ?? '').isNotEmpty) 'variant': exercise.variant,
    };
    final attention = AttentionConfig.fromJson(config);
    final extraWords = ref.watch(memoryWordsProvider);
    final memory = extraWords.isLoading && _memory == null
        ? MemoryConfig.fromJson(
            config,
            extraWords: extraWords.valueOrNull ?? const [],
          )
        : _memoryOf(config, extraWords.valueOrNull ?? const []);
    final breathing = BreathingCycleConfig.fromJson(config);

    final showMemoryWords =
        memory.variant == MemoryVariant.words ||
        memory.variant == MemoryVariant.delayed;

    final child = switch (exercise.type) {
      'daily' => DailyDrillView(exercise: exercise, onCompleted: _submit),
      'breathing' || 'attention' || 'memory' => PreparedExercise(
        type: exercise.type,
        target: exercise.type == 'attention' ? attention.target : null,
        variant: switch (exercise.type) {
          'attention' => attention.variant.name,
          'memory' => memory.variant.name,
          'breathing' => breathing.variant.name,
          _ => null,
        },
        briefingExtra: exercise.type == 'memory' && showMemoryWords
            ? const MemoryWordsButton()
            : null,
        builder: (seconds) => switch (exercise.type) {
          'breathing' => BreathingExerciseView(
            config: breathing.copyWith(cycles: _cyclesFor(breathing, seconds)),
            sessionSeconds: seconds,
            onCompleted: (durationMs) => _submit({
              'cycles_completed': _cyclesFor(breathing, seconds),
              'duration_ms': durationMs,
              'completed': true,
            }),
          ),
          'attention' => AttentionExerciseView(
            config: attention,
            sessionSeconds: seconds,
            onCompleted: (score) => _submit({
              'hits': score.hits,
              'misses': score.misses,
              'duration_ms': score.durationMs,
              'completed': true,
            }),
          ),
          _ => MemoryExerciseView(
            config: memory,
            sessionSeconds: seconds,
            onCompleted: (score) => _submit({
              'hits': score.hits,
              'misses': score.misses,
              'selected': score.selected,
              'completed': true,
            }),
          ),
        },
      ),
      _ => AppEmpty(
        title: l10n.unknownExercise,
        body: l10n.emptyBody,
        icon: Icons.help_outline_rounded,
        actionLabel: l10n.actionBack,
        onAction: () => context.pop(),
      ),
    };

    return AppScaffold(showBack: true, title: exercise.title, body: child);
  }

  int _cyclesFor(BreathingCycleConfig config, int seconds) {
    final raw = seconds ~/ config.cycleSeconds;
    if (raw < 1) {
      return 1;
    }
    if (raw > 40) {
      return 40;
    }
    return raw;
  }
}
