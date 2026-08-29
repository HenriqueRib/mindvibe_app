import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/features/exercises/domain/daily_drills.dart';
import 'package:mindvibe_app/features/exercises/domain/exercise_groups.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class DailyHubPage extends ConsumerStatefulWidget {
  const DailyHubPage({super.key});

  @override
  ConsumerState<DailyHubPage> createState() => _DailyHubPageState();
}

class _DailyHubPageState extends ConsumerState<DailyHubPage> {
  bool? _restOverride;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final exercises = ref.watch(libraryExercisesProvider);
    final progress = ref
        .watch(progressProvider)
        .maybeWhen(data: (result) => result.valueOrNull, orElse: () => null);
    final history = ref
        .watch(historyProvider)
        .maybeWhen(data: (result) => result.valueOrNull, orElse: () => null);
    final checkin = progress?.checkin.today;
    final autoSaturated = progressLooksSaturated(
      mood: checkin?.mood,
      energy: checkin?.energy,
      hasTodayFocus: progress?.todayFocus != null,
    );
    final saturated = _restOverride ?? autoSaturated;
    final doneTitles = _titlesDoneToday(history ?? const []);

    return AppScaffold(
      showBack: true,
      title: l10n.dailyHubTitle,
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
            final rooms = items.where((item) => item.type == 'daily').toList();
            if (rooms.isEmpty) {
              return AppEmpty(
                title: l10n.dailyHubTitle,
                body: l10n.dailyHubBody,
                icon: Icons.fitness_center_outlined,
              );
            }
            final steps = pickCircuit(rooms, saturated: saturated);
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: AppText.subtitle(l10n.dailyHubBody),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: AppCard(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.dailyCircuitTitle.toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          saturated
                              ? l10n.dailyCircuitSaturated
                              : l10n.dailyCircuitFocus,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 14),
                        for (var i = 0; i < steps.length; i++) ...[
                          _CircuitStepRow(
                            index: i + 1,
                            title: steps[i].title,
                            family: _familyLabel(
                              l10n,
                              dailyFamilyOf(
                                dailyVariantFrom(exerciseVariantOf(steps[i])),
                              ),
                            ),
                            done: doneTitles.contains(steps[i].title),
                          ),
                          if (i < steps.length - 1) const SizedBox(height: 8),
                        ],
                        const SizedBox(height: 16),
                        SegmentedButton<bool>(
                          showSelectedIcon: false,
                          expandedInsets: EdgeInsets.zero,
                          segments: [
                            ButtonSegment(
                              value: false,
                              label: Text(l10n.dailyModeTrain),
                            ),
                            ButtonSegment(
                              value: true,
                              label: Text(l10n.dailyModeRest),
                            ),
                          ],
                          selected: {saturated},
                          onSelectionChanged: (next) {
                            setState(() => _restOverride = next.first);
                          },
                        ),
                        const SizedBox(height: 4),
                        AppButton(
                          label: l10n.dailyCircuitCta,
                          onPressed: steps.length < 3
                              ? null
                              : () => context.push(
                                  AppRoutes.dailyCircuit,
                                  extra: steps,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(
                    l10n.dailyHubList,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                for (final family in DailyFamily.values)
                  ..._familySection(context, l10n, family, rooms, doneTitles),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _familySection(
    BuildContext context,
    AppLocalizations l10n,
    DailyFamily family,
    List<ExerciseSpec> rooms,
    Set<String> doneTitles,
  ) {
    final items = sortedDailyExercises(rooms)
        .where(
          (item) =>
              dailyFamilyOf(dailyVariantFrom(exerciseVariantOf(item))) ==
              family,
        )
        .toList();
    if (items.isEmpty) {
      return const [];
    }
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Text(
          _familyLabel(l10n, family),
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      for (final exercise in items)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: _DrillCard(
            exercise: exercise,
            meta: dailyMeta(l10n, exercise),
            done: doneTitles.contains(exercise.title),
            doneLabel: l10n.dailyDoneToday,
            onTap: () => context.push(AppRoutes.practice, extra: exercise),
          ),
        ),
    ];
  }

  String _familyLabel(AppLocalizations l10n, DailyFamily family) {
    return switch (family) {
      DailyFamily.focus => l10n.dailyFamilyFocus,
      DailyFamily.memory => l10n.dailyFamilyMemory,
      DailyFamily.presence => l10n.dailyFamilyPresence,
      DailyFamily.create => l10n.dailyFamilyCreate,
    };
  }
}

Set<String> _titlesDoneToday(List<ActivityItem> items) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return {
    for (final item in items)
      if (item.type == 'exercise')
        if (_isToday(item.occurredAt, today)) item.title,
  };
}

bool _isToday(DateTime occurredAt, DateTime today) {
  final local = occurredAt.toLocal();
  return DateTime(local.year, local.month, local.day) == today;
}

class _CircuitStepRow extends StatelessWidget {
  const _CircuitStepRow({
    required this.index,
    required this.title,
    required this.family,
    required this.done,
  });

  final int index;
  final String title;
  final String family;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: done
                ? AppColors.success.withValues(alpha: 0.18)
                : Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: done
              ? const Icon(
                  Icons.check_rounded,
                  size: 16,
                  color: AppColors.success,
                )
              : Text(
                  '$index',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(
                '5 min · $family',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DrillCard extends StatelessWidget {
  const _DrillCard({
    required this.exercise,
    required this.meta,
    required this.done,
    required this.doneLabel,
    required this.onTap,
  });

  final ExerciseSpec exercise;
  final String meta;
  final bool done;
  final String doneLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final look = dailyLook(exercise);
    return AppCard(
      onTap: onTap,
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
            child: Icon(
              done ? Icons.check_rounded : look.icon,
              color: look.accent,
            ),
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
                  done ? doneLabel : meta,
                  style: TextStyle(
                    color: look.accent,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_rounded, color: look.accent),
        ],
      ),
    );
  }
}
