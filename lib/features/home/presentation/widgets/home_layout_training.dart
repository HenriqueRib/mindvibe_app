import 'package:flutter/material.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/audio_player/presentation/widgets/cover_image.dart';
import 'package:mindvibe_app/features/auth/domain/entities/auth_entities.dart';
import 'package:mindvibe_app/features/billing/premium_access.dart';
import 'package:mindvibe_app/features/exercises/presentation/widgets/daily_practice_card.dart';
import 'package:mindvibe_app/features/home/presentation/widgets/home_shared.dart';
import 'package:mindvibe_app/features/tools/presentation/widgets/today_focus_card.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class HomeTrainingLayout extends StatelessWidget {
  const HomeTrainingLayout({
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
  final VoidCallback? onStart;
  final int? pausedSessionId;

  @override
  Widget build(BuildContext context) {
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
            child: TodayFocusCard(l10n: l10n, focus: progress?.todayFocus),
          ),
          const SizedBox(height: 16),
          FadeSlideIn(
            index: 1,
            child: DailyPracticeCard(
              l10n: l10n,
              isPremium: isPremiumAccount(user),
              progress: progress,
            ),
          ),
          const SizedBox(height: 20),
          FadeSlideIn(
            index: 1,
            child: AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CoverImage(
                    url: training?.program.coverUrl,
                    width: double.infinity,
                    height: 150,
                    radius: 0,
                    icon: Icons.spa_outlined,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          homeTodayEyebrow(l10n, training).toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (training?.todayCompleted == true) ...[
                              const Padding(
                                padding: EdgeInsets.only(top: 2, right: 8),
                                child: Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.success,
                                  size: 22,
                                ),
                              ),
                            ],
                            Expanded(
                              child: Text(
                                training?.dayTitle ?? l10n.homeNoProgram,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          homeTodaySubtitle(l10n, training),
                          style: TextStyle(
                            color: training?.todayCompleted == true
                                ? Theme.of(context).colorScheme.onSurface
                                : AppColors.muted,
                            fontWeight: training?.todayCompleted == true
                                ? FontWeight.w700
                                : FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 18),
                        HomeStartButton(
                          label: homeStartLabel(
                            l10n,
                            training,
                            pausedSessionId: pausedSessionId,
                          ),
                          onPressed: onStart,
                          completed: training?.todayCompleted == true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          FadeSlideIn(
            index: 2,
            child: Text(
              l10n.homeProgressSection,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 12),
          FadeSlideIn(
            index: 3,
            child: HomeStatsStrip(l10n: l10n, progress: progress),
          ),
          const SizedBox(height: 24),
          FadeSlideIn(
            index: 4,
            child: Text(
              l10n.homeKeepExploring,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 12),
          FadeSlideIn(
            index: 5,
            child: HomeExploreGrid(
              l10n: l10n,
              programs: programs,
              isPremium: isPremiumAccount(user),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
