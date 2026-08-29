import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/features/exercises/domain/exercise_groups.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class LibraryExercisesPage extends ConsumerWidget {
  const LibraryExercisesPage({super.key, this.typeFilter});

  final String? typeFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final exercises = ref.watch(libraryExercisesProvider);
    final filter = typeFilter == 'breathing' ? null : typeFilter;

    return AppScaffold(
      showBack: true,
      title: filter == null
          ? l10n.libraryExercisesTitle
          : exerciseTypeLabel(l10n, filter),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
      body: exercises.when(
        loading: () => AppLoading(label: l10n.loadingLabel),
        error: (_, _) => AppError(
          title: l10n.errorLoadTitle,
          message: l10n.errorGeneric,
          retryLabel: l10n.actionRetry,
          onRetry: () => ref.invalidate(libraryExercisesProvider),
        ),
        data: (result) => result.when(
          failure: (failure) => AppError(
            title: l10n.errorLoadTitle,
            message: failureMessage(failure, l10n),
            retryLabel: l10n.actionRetry,
            onRetry: () => ref.invalidate(libraryExercisesProvider),
          ),
          success: (items) {
            final visible = filter == null
                ? items
                : items.where((item) => item.type == filter).toList();
            final groups = groupExercisesByType(visible);
            if (groups.isEmpty) {
              return AppEmpty(
                title: l10n.emptyTitle,
                body: l10n.libraryExercisesEmpty,
                icon: Icons.self_improvement_outlined,
              );
            }
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: AppText.subtitle(l10n.libraryExercisesBody),
                ),
                for (final group in groups) ...[
                  if (group.type == 'breathing' && filter == null)
                    _breathingRoom(context, l10n),
                  if (group.type == 'daily' && filter == null)
                    _dailyRoom(context, l10n),
                  if (group.type == 'daily' && filter == null)
                    const SizedBox.shrink()
                  else ...[
                    if (filter == null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Text(
                          exerciseTypeLabel(l10n, group.type),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    for (final exercise
                        in group.type == 'memory'
                            ? sortedMemoryExercises(group.items)
                            : group.type == 'attention'
                            ? sortedAttentionExercises(group.items)
                            : group.type == 'breathing'
                            ? sortedBreathingExercises(group.items)
                            : group.type == 'daily'
                            ? sortedDailyExercises(group.items)
                            : group.items)
                      _exerciseCard(context, l10n, exercise),
                  ],
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _dailyRoom(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: AppCard(
        onTap: () => context.push(AppRoutes.daily),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.12),
              foregroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(exerciseTypeIcon('daily'), size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.dailyHubTitle,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.dailyHubBody,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _breathingRoom(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: AppCard(
        onTap: () => context.push(AppRoutes.breathing),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.12),
              foregroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(exerciseTypeIcon('breathing'), size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.libraryBreathingRoom,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.libraryBreathingRoomBody,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _exerciseCard(
    BuildContext context,
    AppLocalizations l10n,
    ExerciseSpec exercise,
  ) {
    final look = switch (exercise.type) {
      'memory' => memoryLook(exercise),
      'attention' => attentionLook(exercise),
      'breathing' => breathingLook(exercise),
      'daily' => dailyLook(exercise),
      _ => (
        accent: AppColors.primarySoft,
        icon: exerciseTypeIcon(exercise.type),
      ),
    };
    final subtitle = switch (exercise.type) {
      'memory' => memoryMeta(l10n, exercise),
      'attention' => attentionMeta(l10n, exercise),
      'breathing' => breathingMeta(l10n, exercise),
      'daily' => dailyMeta(l10n, exercise),
      _ => exerciseTypeLabel(l10n, exercise.type),
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: AppCard(
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
                    subtitle,
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
      ),
    );
  }
}
