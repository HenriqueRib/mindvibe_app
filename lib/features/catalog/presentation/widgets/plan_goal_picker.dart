import 'package:flutter/material.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/config/app_config.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

const featuredPlanGoals = ['focus', 'mindfulness', 'memory'];
const otherPlanGoals = ['breathing', 'sleep', 'relaxation'];

String planGoalTitle(AppLocalizations l10n, String goal) {
  return switch (goal) {
    'focus' => l10n.goalFocus,
    'memory' => l10n.goalMemory,
    'mindfulness' => l10n.goalMindfulness,
    'breathing' => l10n.goalBreathing,
    'sleep' => l10n.goalSleep,
    'relaxation' => l10n.goalRelaxation,
    _ => l10n.goalHabit,
  };
}

String planGoalBody(AppLocalizations l10n, String goal) {
  return switch (goal) {
    'focus' => l10n.onboardingGoalFocusBody,
    'mindfulness' => l10n.onboardingGoalMindfulnessBody,
    'memory' => l10n.onboardingGoalMemoryBody,
    _ => l10n.onboardingGoalHint,
  };
}

IconData planGoalIcon(String goal) {
  return switch (goal) {
    'focus' => Icons.center_focus_strong_outlined,
    'mindfulness' => Icons.self_improvement_outlined,
    'memory' => Icons.psychology_outlined,
    'breathing' => Icons.air,
    'sleep' => Icons.nightlight_round,
    'relaxation' => Icons.spa_outlined,
    _ => Icons.flag_outlined,
  };
}

Color planAccentForSlug(String? categorySlug) {
  return switch (categorySlug) {
    'focus' => const Color(0xFFE08A58),
    'breathing' => const Color(0xFF5CB8C4),
    'relaxation' => const Color(0xFF7EC49A),
    'sleep' => const Color(0xFFB5A4E0),
    'memory' => const Color(0xFF6EA8E8),
    'mindfulness' => const Color(0xFF6FB5A8),
    _ => const Color(0xFFD7B49A),
  };
}

ProgramSummary? programForGoal(List<ProgramSummary> programs, String goal) {
  final slug = AppConfig.programSlugByGoal[goal];
  if (slug == null) {
    return null;
  }
  return programs.where((program) => program.slug == slug).firstOrNull;
}

class PlanGoalPicker extends StatelessWidget {
  const PlanGoalPicker({
    super.key,
    required this.l10n,
    required this.onSelected,
    this.selectedGoal,
    this.programs = const [],
    this.showOthers = true,
  });

  final AppLocalizations l10n;
  final String? selectedGoal;
  final List<ProgramSummary> programs;
  final ValueChanged<String> onSelected;
  final bool showOthers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final goal in featuredPlanGoals) ...[
          _GoalCard(
            l10n: l10n,
            goal: goal,
            program: programForGoal(programs, goal),
            selected: selectedGoal == goal,
            onTap: () => onSelected(goal),
          ),
          const SizedBox(height: 10),
        ],
        if (showOthers) ...[
          const SizedBox(height: 8),
          Text(
            l10n.onboardingGoalOthers,
            style: const TextStyle(
              color: AppColors.muted,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final goal in otherPlanGoals)
                ChoiceChip(
                  label: Text(planGoalTitle(l10n, goal)),
                  selected: selectedGoal == goal,
                  onSelected: (_) => onSelected(goal),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.l10n,
    required this.goal,
    required this.selected,
    required this.onTap,
    this.program,
  });

  final AppLocalizations l10n;
  final String goal;
  final ProgramSummary? program;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final title = program?.title ?? planGoalTitle(l10n, goal);
    final body = program?.description?.trim().isNotEmpty == true
        ? program!.description!
        : planGoalBody(l10n, goal);
    final meta = program == null
        ? null
        : l10n.catalogDays(program!.durationDays);

    return AppCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            planGoalIcon(goal),
            color: selected ? AppColors.primary : AppColors.muted,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  planGoalTitle(l10n, goal).toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: const TextStyle(color: AppColors.muted, height: 1.4),
                ),
                if (meta != null) ...[
                  const SizedBox(height: 8),
                  Text(meta, style: const TextStyle(color: AppColors.muted)),
                ],
              ],
            ),
          ),
          Icon(
            selected ? Icons.check_circle : Icons.circle_outlined,
            color: selected ? AppColors.primary : AppColors.muted,
          ),
        ],
      ),
    );
  }
}
