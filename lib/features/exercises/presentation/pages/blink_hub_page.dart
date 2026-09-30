import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/features/exercises/domain/exercise_groups.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class BlinkHubPage extends ConsumerWidget {
  const BlinkHubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final exercises = ref.watch(libraryExercisesProvider);

    return AppScaffold(
      showBack: true,
      title: l10n.blinkHubTitle,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
      body: exercises.when(
        loading: () => AppLoading(label: l10n.loadingLabel),
        error: (_, _) => AppError(
          title: l10n.errorLoadTitle,
          message: l10n.errorGeneric,
          retryLabel: l10n.actionRetry,
          onRetry: () => ref.invalidate(libraryExercisesProvider),
        ),
        data: (exerciseResult) {
          if (!exerciseResult.isSuccess) {
            return AppError(
              title: l10n.errorLoadTitle,
              message: failureMessage(exerciseResult.failureOrNull!, l10n),
              retryLabel: l10n.actionRetry,
              onRetry: () => ref.invalidate(libraryExercisesProvider),
            );
          }
          final rooms = (exerciseResult.valueOrNull ?? const <ExerciseSpec>[])
              .where((item) => item.type == 'blink')
              .toList();
          if (rooms.isEmpty) {
            return AppEmpty(
              title: l10n.blinkHubEmpty,
              body: l10n.blinkHubBody,
              icon: Icons.remove_red_eye_outlined,
            );
          }
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: AppText.subtitle(l10n.blinkHubBody),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Text(
                  l10n.blinkDisclaimer,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ),
              for (final exercise in sortedBlinkExercises(rooms))
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: _exerciseCard(context, l10n, exercise),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _exerciseCard(
    BuildContext context,
    AppLocalizations l10n,
    ExerciseSpec exercise,
  ) {
    final look = blinkLook(exercise);
    return AppCard(
      onTap: () => context.push(AppRoutes.practice, extra: exercise),
      padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: look.accent.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: look.accent.withValues(alpha: 0.55)),
            ),
            child: Icon(look.icon, color: look.accent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  blinkMeta(l10n, exercise),
                  style: TextStyle(
                    color: look.accent,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_rounded, color: look.accent, size: 20),
        ],
      ),
    );
  }
}
