import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/features/home/presentation/home_actions.dart';
import 'package:mindvibe_app/features/progress/domain/progress_milestones.dart';
import 'package:mindvibe_app/features/progress/presentation/activity_presentation.dart';
import 'package:mindvibe_app/features/progress/presentation/widgets/checkin_week_strip.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class ProgressPage extends ConsumerWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final progress = ref.watch(progressProvider);
    final weekly = ref.watch(weeklyReportProvider);
    final history = ref.watch(historyProvider);
    final today = ref
        .watch(todayProvider)
        .maybeWhen(data: (result) => result.valueOrNull, orElse: () => null);

    return AppScaffold(
      title: l10n.progressTitle,
      body: progress.when(
        loading: () => AppLoading(label: l10n.loadingLabel),
        error: (error, _) => AppError(
          message: l10n.errorGeneric,
          retryLabel: l10n.actionRetry,
          onRetry: () {
            ref.invalidate(progressProvider);
            ref.invalidate(weeklyReportProvider);
            ref.invalidate(historyProvider);
          },
        ),
        data: (result) {
          return result.when(
            failure: (failure) => AppError(
              message: failureMessage(failure, l10n),
              retryLabel: l10n.actionRetry,
              onRetry: () => ref.invalidate(progressProvider),
            ),
            success: (snapshot) {
              final weekDays = weekly.maybeWhen(
                data: (result) =>
                    result.valueOrNull?.weekDays ?? const <WeekDayTime>[],
                orElse: () => const <WeekDayTime>[],
              );
              final days = weekDays.length == 7 ? weekDays : snapshot.weekDays;
              final items = history.maybeWhen(
                data: (result) => result.valueOrNull ?? const <ActivityItem>[],
                orElse: () => const <ActivityItem>[],
              );
              return ListView(
                children: snapshot.isFreshStart
                    ? _fresh(context, l10n, snapshot, today)
                    : _journey(context, l10n, snapshot, days, items),
              );
            },
          );
        },
      ),
    );
  }

  List<Widget> _fresh(
    BuildContext context,
    AppLocalizations l10n,
    ProgressSnapshot snapshot,
    TodayTraining? today,
  ) {
    return [
      Text(
        l10n.progressEmptyTitle,
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          height: 1.2,
          letterSpacing: -0.4,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        l10n.progressEmptyBody,
        style: const TextStyle(
          color: AppColors.muted,
          height: 1.45,
          fontSize: 16,
        ),
      ),
      const SizedBox(height: 24),
      AppButton(
        label: l10n.progressEmptyCta,
        onPressed: () => _continue(context, l10n, snapshot, today),
      ),
      const SizedBox(height: 28),
      AppCard(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: CheckinClimateRow(
          l10n: l10n,
          checkin: snapshot.checkin,
          onTap: () => context.push(AppRoutes.checkin),
        ),
      ),
    ];
  }

  List<Widget> _journey(
    BuildContext context,
    AppLocalizations l10n,
    ProgressSnapshot snapshot,
    List<WeekDayTime> days,
    List<ActivityItem> items,
  ) {
    final weekSeconds = days.fold<int>(0, (sum, day) => sum + day.seconds);
    final lastWeek = previousWeekSeconds(items);
    final trainedDays = trainedDaysThisWeek(days);
    final insight = _weekInsight(l10n, weekSeconds, lastWeek, trainedDays);
    final milestone = resolveProgressMilestone(snapshot);
    final recent = items.take(3).toList();

    return [
      Text(
        l10n.progressStreakDays(snapshot.streakDays),
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          height: 1.2,
          letterSpacing: -0.4,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        l10n.progressHeroStats(
          _formatTime(l10n, snapshot.totalSeconds),
          snapshot.sessionsCompleted,
        ),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.success,
        ),
      ),
      const SizedBox(height: 14),
      _WeekLine(days: days),
      if (insight != null) ...[
        const SizedBox(height: 10),
        Text(
          insight,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withValues(
              alpha: 0.7,
            ),
            height: 1.4,
            fontSize: 15,
          ),
        ),
      ],
      const SizedBox(height: 28),
      AppCard(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          children: [
            CheckinClimateRow(
              l10n: l10n,
              checkin: snapshot.checkin,
              onTap: () => context.push(AppRoutes.checkin),
            ),
            Divider(
              height: 1,
              color: Theme.of(context).colorScheme.outline.withValues(
                alpha: 0.7,
              ),
            ),
            if (recent.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Text(
                  l10n.historyEmpty,
                  style: const TextStyle(color: AppColors.muted, height: 1.4),
                ),
              )
            else
              for (var i = 0; i < recent.length; i++) ...[
                if (i > 0)
                  Divider(
                    height: 1,
                    color: Theme.of(context).colorScheme.outline.withValues(
                      alpha: 0.7,
                    ),
                  ),
                _ActivityLine(l10n: l10n, item: recent[i]),
              ],
            Divider(
              height: 1,
              color: Theme.of(context).colorScheme.outline.withValues(
                alpha: 0.7,
              ),
            ),
            _LinkRow(
              label: l10n.progressSeeHistory,
              onTap: () => context.push(AppRoutes.history),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      _MoreFold(
        title: l10n.progressMoreTitle,
        children: [
          _LinkRow(
            label: l10n.rankingXp(snapshot.xp),
            hint: snapshot.levelName == null || snapshot.levelName!.isEmpty
                ? l10n.progressXpCardBody
                : l10n.progressLevelName(snapshot.levelName!),
            onTap: () => context.push(AppRoutes.xpInfo),
          ),
          _LinkRow(
            label: _milestoneTitle(l10n, milestone),
            hint: _milestoneHint(l10n, snapshot, milestone),
            onTap: milestone.kind == ProgressMilestoneKind.level
                ? () => context.push(AppRoutes.xpInfo)
                : null,
          ),
          if (snapshot.program != null)
            _LinkRow(
              label: snapshot.program!.title,
              hint: _programHint(l10n, snapshot.program!),
              onTap: () => context.push(AppRoutes.plan),
            ),
          _LinkRow(
            label: l10n.rankingCardTitle,
            hint: l10n.rankingCardBody,
            onTap: () => context.push(AppRoutes.ranking),
          ),
        ],
      ),
    ];
  }

  Future<void> _continue(
    BuildContext context,
    AppLocalizations l10n,
    ProgressSnapshot snapshot,
    TodayTraining? today,
  ) async {
    if (today != null) {
      await startTodayTraining(context, l10n, today);
      return;
    }
    if (!context.mounted) {
      return;
    }
    final program = snapshot.program;
    if (program != null) {
      await context.push(AppRoutes.programPath(program.id));
      return;
    }
    await context.push(AppRoutes.choosePlan);
  }

  String? _weekInsight(
    AppLocalizations l10n,
    int weekSeconds,
    int lastWeekSeconds,
    int trainedDays,
  ) {
    if (weekSeconds == 0) {
      return null;
    }
    if (lastWeekSeconds == 0) {
      return l10n.progressWeekDaysTrained(trainedDays);
    }
    final delta = weekSeconds - lastWeekSeconds;
    if (delta > 59) {
      return l10n.progressWeekDeltaUp(_formatTime(l10n, delta));
    }
    if (delta < -59) {
      return l10n.progressWeekDeltaDown(_formatTime(l10n, -delta));
    }
    return l10n.progressWeekDaysTrained(trainedDays);
  }

  String _programHint(AppLocalizations l10n, ProgramSummary program) {
    final total = program.durationDays;
    final done = program.daysCompleted ?? 0;
    final current = program.currentDayNumber ?? (done + 1);
    if (done >= total && total > 0) {
      return l10n.progressProgramDaysDone(done, total);
    }
    return l10n.progressProgramDay(
      current.clamp(1, total == 0 ? 1 : total),
      total,
    );
  }
}

String _milestoneTitle(AppLocalizations l10n, ProgressMilestone milestone) {
  return switch (milestone.kind) {
    ProgressMilestoneKind.firstSession => l10n.progressEmptyCta,
    ProgressMilestoneKind.streak => l10n.progressMilestoneStreak(
      milestone.target,
    ),
    ProgressMilestoneKind.level => l10n.progressMilestoneXp(milestone.remaining),
    ProgressMilestoneKind.minutes => l10n.progressMilestoneMinutes(
      milestone.target,
    ),
  };
}

String _milestoneHint(
  AppLocalizations l10n,
  ProgressSnapshot snapshot,
  ProgressMilestone milestone,
) {
  return switch (milestone.kind) {
    ProgressMilestoneKind.firstSession => l10n.progressEmptyBody,
    ProgressMilestoneKind.streak => l10n.progressMilestoneStreakRemain(
      milestone.remaining,
    ),
    ProgressMilestoneKind.level => l10n.progressMilestoneXpBar(
      snapshot.xp,
      milestone.target,
    ),
    ProgressMilestoneKind.minutes => l10n.progressMilestoneMinutesBar(
      milestone.current,
      milestone.target,
    ),
  };
}

class _WeekLine extends StatelessWidget {
  const _WeekLine({required this.days});

  final List<WeekDayTime> days;

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) {
      return const SizedBox.shrink();
    }
    final track = Theme.of(context).colorScheme.outline.withValues(alpha: 0.28);
    return Row(
      children: [
        for (var i = 0; i < days.length; i++) ...[
          if (i > 0) const SizedBox(width: 5),
          Expanded(
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                color: days[i].seconds > 0 ? AppColors.success : track,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ActivityLine extends StatelessWidget {
  const _ActivityLine({required this.l10n, required this.item});

  final AppLocalizations l10n;
  final ActivityItem item;

  @override
  Widget build(BuildContext context) {
    final title = switch (item.type) {
      'journal' => l10n.journalPrompt(item.prompt ?? ''),
      'thought' => l10n.historyTypeThought,
      'clear_mind' => l10n.historyTypeClearMind,
      'day_close' => l10n.historyTypeDayClose,
      _ => item.title,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            activityDayLabel(l10n, item.occurredAt),
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({required this.label, this.hint, this.onTap});

  final String label;
  final String? hint;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  if (hint != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      hint!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 13,
                        height: 1.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (onTap != null)
              const Icon(Icons.chevron_right, color: AppColors.muted),
          ],
        ),
      ),
    );
  }
}

class _MoreFold extends StatefulWidget {
  const _MoreFold({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  State<_MoreFold> createState() => _MoreFoldState();
}

class _MoreFoldState extends State<_MoreFold> {
  var _open = false;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            title: Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            trailing: Icon(
              _open ? Icons.expand_less_rounded : Icons.expand_more_rounded,
            ),
            onTap: () => setState(() => _open = !_open),
          ),
          if (_open)
            Column(
              children: [
                for (var i = 0; i < widget.children.length; i++) ...[
                  if (i > 0)
                    Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: Theme.of(context).colorScheme.outline.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  widget.children[i],
                ],
              ],
            ),
        ],
      ),
    );
  }
}

String _formatTime(AppLocalizations l10n, int totalSeconds) {
  if (totalSeconds < 60) {
    return l10n.progressTimeUnderMinute;
  }
  final hours = totalSeconds ~/ 3600;
  final minutes = (totalSeconds % 3600) ~/ 60;
  if (hours == 0) {
    return l10n.progressTimeCompactMinutes(minutes);
  }
  return l10n.progressTimeCompactHours(hours, minutes);
}
