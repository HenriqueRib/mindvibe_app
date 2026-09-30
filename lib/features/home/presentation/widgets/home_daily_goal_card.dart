import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/auth/presentation/providers/session_controller.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class HomeDailyGoalCard extends ConsumerWidget {
  const HomeDailyGoalCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final goal = ref.watch(sessionControllerProvider).user?.dailyGoalMinutes;
    if (goal == null || goal <= 0) {
      return const SizedBox.shrink();
    }
    final weekDays = ref
        .watch(weeklyReportProvider)
        .maybeWhen(
          data: (result) => result.valueOrNull?.weekDays ?? const [],
          orElse: () => const [],
        );
    final todaySeconds = weekDays
        .where((day) => day.isToday())
        .map((day) => day.seconds)
        .firstOrNull;
    final done = (todaySeconds ?? 0) ~/ 60;
    final ratio = (done / goal).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AppCard(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.profileDailyGoalProgress(done, goal),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 8,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
