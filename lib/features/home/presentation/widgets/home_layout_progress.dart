import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/audio_player/presentation/widgets/cover_image.dart';
import 'package:mindvibe_app/features/auth/domain/entities/auth_entities.dart';
import 'package:mindvibe_app/features/billing/premium_access.dart';
import 'package:mindvibe_app/features/exercises/presentation/widgets/daily_practice_card.dart';
import 'package:mindvibe_app/features/home/presentation/home_actions.dart';
import 'package:mindvibe_app/features/home/presentation/widgets/home_shared.dart';
import 'package:mindvibe_app/features/tools/presentation/widgets/today_focus_card.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class HomeProgressLayout extends StatelessWidget {
  const HomeProgressLayout({
    super.key,
    required this.l10n,
    required this.name,
    required this.user,
    required this.programs,
    required this.onStart,
    this.training,
    this.progress,
    this.pausedSessionId,
  });

  final AppLocalizations l10n;
  final String name;
  final UserAccount? user;
  final TodayTraining? training;
  final ProgressSnapshot? progress;
  final List<ProgramSummary> programs;
  final int? pausedSessionId;
  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    final streak = progress?.streakDays ?? training?.streakDays ?? 0;
    final scheme = Theme.of(context).colorScheme;
    final ring = training != null && training!.program.durationDays > 0
        ? (training!.dayNumber / training!.program.durationDays).clamp(0.0, 1.0)
        : (streak / 21).clamp(0.0, 1.0);

    return AppScaffold(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
      body: ListView(
        children: [
          FadeSlideIn(
            child: HomeGreetingBar(l10n: l10n, name: name, user: user),
          ),
          const SizedBox(height: 20),
          FadeSlideIn(
            index: 1,
            child: AppCard(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.homeCurrentStreak,
                          style: TextStyle(
                            color: scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.local_fire_department,
                              color: scheme.secondary,
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$streak ${l10n.homeStatDays.toLowerCase()}',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 88,
                    height: 88,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 88,
                          height: 88,
                          child: CircularProgressIndicator(
                            value: ring <= 0 ? 0.08 : ring,
                            strokeWidth: 7,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.outline.withValues(alpha: 0.35),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Icon(
                          Icons.psychology_outlined,
                          color: Theme.of(context).colorScheme.primary,
                          size: 32,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (training != null) ...[
            const SizedBox(height: 24),
            FadeSlideIn(
              index: 2,
              child: Text(
                l10n.homeNextTraining,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 12),
            FadeSlideIn(
              index: 3,
              child: AppCard(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Row(
                  children: [
                    CoverImage(
                      url: training!.program.coverUrl,
                      size: 64,
                      radius: 14,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            training!.todayCompleted
                                ? (training!.nextDayTitle ?? training!.dayTitle)
                                : training!.dayTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            training!.todayCompleted
                                ? homeTodaySubtitle(l10n, training)
                                : '${training!.estimatedMinutes} ${l10n.homeMinutes}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: training!.todayCompleted
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                              fontWeight: training!.todayCompleted
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (training!.todayCompleted)
                      OutlinedButton(
                        onPressed: onStart,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                        ),
                        child: Text(
                          homeStartLabel(
                            l10n,
                            training,
                            pausedSessionId: pausedSessionId,
                          ),
                        ),
                      )
                    else
                      FilledButton(
                        onPressed: onStart,
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                        ),
                        child: Text(
                          homeStartLabel(
                            l10n,
                            training,
                            pausedSessionId: pausedSessionId,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          FadeSlideIn(
            index: 4,
            child: Text(
              l10n.homeAreaProgress,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 12),
          FadeSlideIn(
            index: 3,
            child: AppCard(
              child: Column(
                children: [
                  for (var i = 0; i < homeAreaItems.length; i++) ...[
                    if (i > 0) const SizedBox(height: 14),
                    _AreaBar(
                      item: homeAreaItems[i],
                      l10n: l10n,
                      value: programAreaProgress(
                        programForSlug(programs, homeAreaItems[i].slug),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          FadeSlideIn(
            index: 6,
            child: TodayFocusCard(l10n: l10n, focus: progress?.todayFocus),
          ),
          const SizedBox(height: 16),
          FadeSlideIn(
            index: 6,
            child: DailyPracticeCard(
              l10n: l10n,
              isPremium: isPremiumAccount(user),
              progress: progress,
            ),
          ),
          const SizedBox(height: 24),
          FadeSlideIn(
            index: 6,
            child: Text(
              l10n.homeMyTools,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 12),
          FadeSlideIn(
            index: 7,
            child: Column(
              children: [
                Row(
                  children: [
                    _tool(
                      context,
                      icon: Icons.spa_outlined,
                      label: l10n.homeToolCheckin,
                      onTap: () => context.push(AppRoutes.checkin),
                    ),
                    _tool(
                      context,
                      icon: Icons.edit_note_outlined,
                      label: l10n.homeToolJournal,
                      onTap: () => context.push(AppRoutes.journal),
                    ),
                    _tool(
                      context,
                      icon: Icons.push_pin_outlined,
                      label: l10n.homeToolThought,
                      locked: !isPremiumAccount(user),
                      onTap: () => openMaybePremium(
                        context,
                        isPremium: isPremiumAccount(user),
                        action: () => context.push(AppRoutes.thoughts),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _tool(
                      context,
                      icon: Icons.timer_outlined,
                      label: l10n.homeToolPomodoro,
                      locked: !isPremiumAccount(user),
                      onTap: () => openMaybePremium(
                        context,
                        isPremium: isPremiumAccount(user),
                        action: () => context.push(AppRoutes.pomodoro),
                      ),
                    ),
                    _tool(
                      context,
                      icon: Icons.self_improvement_outlined,
                      label: l10n.homeToolSilentRoom,
                      locked: !isPremiumAccount(user),
                      onTap: () => openMaybePremium(
                        context,
                        isPremium: isPremiumAccount(user),
                        action: () => context.push(AppRoutes.silentRoom),
                      ),
                    ),
                    _tool(
                      context,
                      icon: Icons.nights_stay_outlined,
                      label: l10n.homeToolDayClose,
                      locked: !isPremiumAccount(user),
                      onTap: () => openMaybePremium(
                        context,
                        isPremium: isPremiumAccount(user),
                        action: () => context.push(AppRoutes.dayClose),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _tool(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool locked = false,
  }) {
    return Expanded(
      child: ScaleOnTap(
        child: Semantics(
          button: true,
          label: label,
          hint: locked ? AppLocalizations.of(context).paywallTitle : null,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        child: Icon(
                          icon,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      if (locked)
                        const Positioned(
                          right: -2,
                          top: -2,
                          child: Icon(
                            Icons.lock_rounded,
                            size: 14,
                            color: AppColors.gold,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AreaBar extends StatelessWidget {
  const _AreaBar({required this.item, required this.l10n, required this.value});

  final HomeExploreItem item;
  final AppLocalizations l10n;
  final double value;

  @override
  Widget build(BuildContext context) {
    final percent = (value * 100).round();
    return Column(
      children: [
        Row(
          children: [
            Icon(item.icon, size: 18, color: item.accent),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                item.label(l10n),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              '$percent%',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: value <= 0 ? 0.04 : value,
            minHeight: 8,
            color: item.accent,
            backgroundColor: item.accent.withValues(alpha: 0.16),
          ),
        ),
      ],
    );
  }
}
