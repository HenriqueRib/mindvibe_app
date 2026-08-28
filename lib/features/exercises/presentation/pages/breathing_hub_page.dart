import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/features/audio_player/presentation/widgets/cover_image.dart';
import 'package:mindvibe_app/features/catalog/domain/audio_category.dart';
import 'package:mindvibe_app/features/catalog/presentation/pages/listen_page.dart';
import 'package:mindvibe_app/features/exercises/domain/exercise_groups.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class BreathingHubPage extends ConsumerWidget {
  const BreathingHubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final exercises = ref.watch(libraryExercisesProvider);
    final moments = ref.watch(momentsProvider);

    return AppScaffold(
      showBack: true,
      title: l10n.breathingHubTitle,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
      body: exercises.when(
        loading: () => AppLoading(label: l10n.loadingLabel),
        error: (_, _) => AppError(
          message: l10n.errorGeneric,
          retryLabel: l10n.actionRetry,
          onRetry: () {
            ref.invalidate(libraryExercisesProvider);
            ref.invalidate(momentsProvider);
          },
        ),
        data: (exerciseResult) {
          if (!exerciseResult.isSuccess) {
            return AppError(
              message: failureMessage(exerciseResult.failureOrNull!, l10n),
              retryLabel: l10n.actionRetry,
              onRetry: () => ref.invalidate(libraryExercisesProvider),
            );
          }
          final rooms = (exerciseResult.valueOrNull ?? const <ExerciseSpec>[])
              .where((item) => item.type == 'breathing')
              .toList();
          final audios =
              (moments.asData?.value.valueOrNull ?? const <ListenMoment>[])
                  .where((item) => item.categorySlug == 'breathing')
                  .toList();
          if (rooms.isEmpty && audios.isEmpty) {
            if (moments.isLoading) {
              return AppLoading(label: l10n.loadingLabel);
            }
            return AppEmpty(
              title: l10n.breathingHubEmpty,
              body: l10n.breathingHubBody,
            );
          }
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: AppText.subtitle(l10n.breathingHubBody),
              ),
              if (rooms.isNotEmpty) ...[
                _sectionTitle(l10n.breathingHubExercises),
                for (final exercise in sortedBreathingExercises(rooms))
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: _exerciseCard(context, l10n, exercise),
                  ),
              ],
              if (audios.isNotEmpty) ...[
                _sectionTitle(l10n.breathingHubAudios),
                for (final audio in audios)
                  _audioTile(context, l10n, audio, audios),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
    );
  }

  Widget _exerciseCard(
    BuildContext context,
    AppLocalizations l10n,
    ExerciseSpec exercise,
  ) {
    final look = breathingLook(exercise);
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
                  breathingMeta(l10n, exercise),
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

  Widget _audioTile(
    BuildContext context,
    AppLocalizations l10n,
    ListenMoment moment,
    List<ListenMoment> queue,
  ) {
    final minutes = ((moment.durationSeconds ?? 0) / 60).round();
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CoverImage(
        url: moment.coverUrl,
        size: 52,
        radius: 12,
        icon: audioCategoryIcon(moment.categorySlug),
      ),
      title: Text(
        moment.title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        minutes <= 0
            ? l10n.homeExerciseBreathing
            : '$minutes ${l10n.homeMinutes}',
        style: const TextStyle(color: AppColors.muted),
      ),
      trailing: const Icon(Icons.play_arrow_rounded, color: AppColors.primary),
      onTap: () => context.push(
        AppRoutes.listen,
        extra: ListenLaunch(moment: moment, queue: queue),
      ),
    );
  }
}
