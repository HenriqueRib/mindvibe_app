import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/auth/domain/entities/auth_entities.dart';
import 'package:mindvibe_app/features/billing/premium_access.dart';
import 'package:mindvibe_app/features/exercises/presentation/widgets/daily_practice_card.dart';
import 'package:mindvibe_app/features/home/presentation/home_hero.dart';
import 'package:mindvibe_app/features/home/presentation/widgets/home_shared.dart';
import 'package:mindvibe_app/features/tools/presentation/widgets/today_focus_card.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class HomeTodayLayout extends StatelessWidget {
  const HomeTodayLayout({
    super.key,
    required this.l10n,
    required this.name,
    required this.user,
    required this.programs,
    required this.onStart,
    this.training,
    this.progress,
  });

  final AppLocalizations l10n;
  final String name;
  final UserAccount? user;
  final TodayTraining? training;
  final ProgressSnapshot? progress;
  final List<ProgramSummary> programs;
  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    final period = HomeHero.periodAt();
    final heroHeight = MediaQuery.sizeOf(context).height * 0.52;
    final ring = training == null || training!.program.durationDays <= 0
        ? 0.0
        : (training!.dayNumber / training!.program.durationDays).clamp(
            0.0,
            1.0,
          );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: AppScaffold(
        useSafeArea: false,
        padding: EdgeInsets.zero,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: heroHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      HomeHero.assetFor(period),
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x66000000),
                            Color(0x14000000),
                            Color(0xCC050505),
                          ],
                          stops: [0, 0.38, 1],
                        ),
                      ),
                    ),
                    SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HomeGreetingBar(
                              l10n: l10n,
                              name: name,
                              user: user,
                              foreground: Colors.white,
                              tagline: l10n.homeTagline,
                            ),
                            const Spacer(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        homeTodayEyebrow(
                                          l10n,
                                          training,
                                        ).toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.2,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (training?.todayCompleted ==
                                              true) ...[
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                top: 4,
                                                right: 8,
                                              ),
                                              child: Icon(
                                                Icons.check_circle_rounded,
                                                color: Color(0xFF7CBA6F),
                                                size: 26,
                                              ),
                                            ),
                                          ],
                                          Expanded(
                                            child: Text(
                                              training?.dayTitle ??
                                                  l10n.homeNoProgram,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 26,
                                                fontWeight: FontWeight.w700,
                                                height: 1.2,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        homeTodaySubtitle(l10n, training),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color:
                                              training?.todayCompleted == true
                                              ? Colors.white
                                              : Colors.white70,
                                          height: 1.35,
                                          fontWeight:
                                              training?.todayCompleted == true
                                              ? FontWeight.w700
                                              : FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                _PlayRing(
                                  value: ring,
                                  onPressed: onStart,
                                  completed: training?.todayCompleted == true,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              sliver: SliverList.list(
                children: [
                  FadeSlideIn(
                    child: TodayFocusCard(
                      l10n: l10n,
                      focus: progress?.todayFocus,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeSlideIn(
                    child: DailyPracticeCard(
                      l10n: l10n,
                      isPremium: isPremiumAccount(user),
                      progress: progress,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeSlideIn(
                    child: HomeCategoryStrip(
                      l10n: l10n,
                      programs: programs,
                      isPremium: isPremiumAccount(user),
                    ),
                  ),
                  const SizedBox(height: 28),
                  FadeSlideIn(
                    index: 1,
                    child: Text(
                      l10n.homeNumbersTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  FadeSlideIn(
                    index: 2,
                    child: HomeStatsStrip(
                      l10n: l10n,
                      progress: progress,
                      asCards: false,
                    ),
                  ),
                  const SizedBox(height: 28),
                  FadeSlideIn(
                    index: 3,
                    child: AppCard(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.eco_outlined,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.homeQuote,
                              style: const TextStyle(
                                height: 1.45,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayRing extends StatelessWidget {
  const _PlayRing({
    required this.value,
    required this.onPressed,
    this.completed = false,
  });

  final double value;
  final VoidCallback? onPressed;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      child: GestureDetector(
        onTap: onPressed,
        child: SizedBox(
          width: 72,
          height: 72,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: CircularProgressIndicator(
                  value: value <= 0 ? 0.08 : value,
                  strokeWidth: 3.5,
                  backgroundColor: Colors.white24,
                  color: const Color(0xFF7CBA6F),
                ),
              ),
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFF3D7A5A),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  completed ? Icons.check_rounded : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
