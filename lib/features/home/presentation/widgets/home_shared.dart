import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/audio_player/presentation/widgets/cover_image.dart';
import 'package:mindvibe_app/features/auth/domain/entities/auth_entities.dart';
import 'package:mindvibe_app/features/billing/premium_access.dart';
import 'package:mindvibe_app/features/home/presentation/home_actions.dart';
import 'package:mindvibe_app/features/home/presentation/widgets/academy_menu.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class HomeExploreItem {
  const HomeExploreItem({
    required this.slug,
    required this.icon,
    required this.accent,
  });

  final String slug;
  final IconData icon;
  final Color accent;

  String label(AppLocalizations l10n) {
    return switch (slug) {
      'focus' => l10n.homeNowFocus,
      'breathing' => l10n.homeNowBreathe,
      'relaxation' => l10n.homeNowRelax,
      'sleep' => l10n.homeNowSleep,
      'memory' => l10n.homeNowMemory,
      'mindfulness' => l10n.homeNowMindfulness,
      _ => slug,
    };
  }
}

const homeExploreItems = [
  HomeExploreItem(
    slug: 'focus',
    icon: Icons.psychology_outlined,
    accent: Color(0xFFC46A3A),
  ),
  HomeExploreItem(
    slug: 'breathing',
    icon: Icons.air,
    accent: Color(0xFF2F7A8A),
  ),
  HomeExploreItem(
    slug: 'relaxation',
    icon: Icons.spa_outlined,
    accent: Color(0xFF3D7A5A),
  ),
  HomeExploreItem(
    slug: 'sleep',
    icon: Icons.bedtime_outlined,
    accent: Color(0xFF6B5B95),
  ),
  HomeExploreItem(
    slug: 'memory',
    icon: Icons.menu_book_outlined,
    accent: Color(0xFF3A6EA5),
  ),
  HomeExploreItem(
    slug: 'mindfulness',
    icon: Icons.self_improvement_outlined,
    accent: Color(0xFF2F5D56),
  ),
];

const homeAreaItems = [
  HomeExploreItem(
    slug: 'focus',
    icon: Icons.psychology_outlined,
    accent: Color(0xFFC46A3A),
  ),
  HomeExploreItem(
    slug: 'breathing',
    icon: Icons.air,
    accent: Color(0xFF2F7A8A),
  ),
  HomeExploreItem(
    slug: 'relaxation',
    icon: Icons.spa_outlined,
    accent: Color(0xFF3D7A5A),
  ),
  HomeExploreItem(
    slug: 'sleep',
    icon: Icons.bedtime_outlined,
    accent: Color(0xFF6B5B95),
  ),
  HomeExploreItem(
    slug: 'memory',
    icon: Icons.menu_book_outlined,
    accent: Color(0xFF3A6EA5),
  ),
];

class HomeUserAvatar extends StatelessWidget {
  const HomeUserAvatar({super.key, required this.user, this.size = 40});

  final UserAccount? user;
  final double size;

  @override
  Widget build(BuildContext context) {
    final url = user?.avatarUrl;
    final emoji = user?.avatarEmoji;
    final letter = (user?.name ?? '?').trim();
    final initial = letter.isEmpty
        ? '?'
        : String.fromCharCodes(letter.runes.take(1)).toUpperCase();

    Widget child;
    if (url != null && url.isNotEmpty) {
      child = CoverImage(
        url: url,
        size: size,
        radius: size / 2,
        icon: Icons.person,
      );
    } else if (emoji != null && emoji.isNotEmpty) {
      child = ColoredBox(
        color: AppColors.surfaceMuted,
        child: Center(
          child: Text(emoji, style: TextStyle(fontSize: size * 0.42)),
        ),
      );
    } else {
      child = ColoredBox(
        color: AppColors.primary.withValues(alpha: 0.18),
        child: Center(
          child: Text(
            initial,
            style: TextStyle(
              fontSize: size * 0.38,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
      );
    }

    return ClipOval(
      child: SizedBox(width: size, height: size, child: child),
    );
  }
}

class HomeGreetingBar extends StatelessWidget {
  const HomeGreetingBar({
    super.key,
    required this.l10n,
    required this.name,
    required this.user,
    this.foreground,
    this.tagline,
  });

  final AppLocalizations l10n;
  final String name;
  final UserAccount? user;
  final Color? foreground;
  final String? tagline;

  @override
  Widget build(BuildContext context) {
    final color = foreground ?? Theme.of(context).colorScheme.onSurface;
    return Row(
      children: [
        AcademyMenuButton(l10n: l10n, user: user, foreground: color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.isEmpty ? l10n.appName : l10n.homeGreeting(name),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (tagline != null) ...[
                const SizedBox(height: 2),
                Text(
                  tagline!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color.withValues(alpha: 0.78),
                    fontSize: 13,
                  ),
                ),
              ],
            ],
          ),
        ),
        ScaleOnTap(
          child: GestureDetector(
            onTap: () => StatefulNavigationShell.of(context).goBranch(2),
            child: HomeUserAvatar(user: user),
          ),
        ),
      ],
    );
  }
}

class HomeStatsStrip extends StatelessWidget {
  const HomeStatsStrip({
    super.key,
    required this.l10n,
    required this.progress,
    this.asCards = true,
  });

  final AppLocalizations l10n;
  final ProgressSnapshot? progress;
  final bool asCards;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final xp = NumberFormat.decimalPattern(
      l10n.localeName,
    ).format(progress?.xp ?? 0);
    final items = [
      (
        Icons.local_fire_department_outlined,
        '${progress?.streakDays ?? 0}',
        l10n.homeStatDays,
      ),
      (
        Icons.schedule_outlined,
        compactDuration(progress?.totalSeconds ?? 0),
        l10n.homeStatTrained,
      ),
      (
        Icons.insights_outlined,
        '${progress?.sessionsCompleted ?? 0}',
        l10n.progressSessions,
      ),
      (Icons.star_outline_rounded, xp, l10n.progressXp),
    ];

    if (!asCards) {
      return Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(
              child: Column(
                children: [
                  Text(
                    items[i].$2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    items[i].$3,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: muted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    }

    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: AppCard(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              child: Column(
                children: [
                  Icon(items[i].$1, color: AppColors.primary, size: 20),
                  const SizedBox(height: 8),
                  Text(
                    items[i].$2,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    items[i].$3,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: muted, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class HomeExploreGrid extends StatelessWidget {
  const HomeExploreGrid({
    super.key,
    required this.l10n,
    required this.programs,
    this.isPremium = false,
  });

  final AppLocalizations l10n;
  final List<ProgramSummary> programs;
  final bool isPremium;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 10.0;
        final width = (constraints.maxWidth - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final item in homeExploreItems)
              SizedBox(
                width: width,
                child: ScaleOnTap(
                  child: AppCard(
                    onTap: () => openHomeDestination(
                      context,
                      slug: item.slug,
                      programs: programs,
                      isPremium: isPremium,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 12,
                    ),
                    child: Row(
                      children: [
                        Icon(item.icon, color: item.accent),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item.label(l10n),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (homeSlugRequiresPremium(item.slug) && !isPremium)
                          const Icon(
                            Icons.lock_outline_rounded,
                            size: 16,
                            color: Color(0xFFD7B49A),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class HomeCategoryStrip extends StatelessWidget {
  const HomeCategoryStrip({
    super.key,
    required this.l10n,
    required this.programs,
    this.foreground,
    this.isPremium = false,
  });

  final AppLocalizations l10n;
  final List<ProgramSummary> programs;
  final Color? foreground;
  final bool isPremium;

  @override
  Widget build(BuildContext context) {
    final color = foreground ?? Theme.of(context).colorScheme.onSurface;
    return Row(
      children: [
        for (final item in homeAreaItems)
          Expanded(
            child: ScaleOnTap(
              child: InkWell(
                onTap: () => openHomeDestination(
                  context,
                  slug: item.slug,
                  programs: programs,
                  isPremium: isPremium,
                ),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: color.withValues(alpha: 0.28),
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(item.icon, color: color, size: 22),
                            if (homeSlugRequiresPremium(item.slug) &&
                                !isPremium)
                              const Positioned(
                                right: 2,
                                bottom: 2,
                                child: Icon(
                                  Icons.lock_rounded,
                                  size: 12,
                                  color: Color(0xFFD7B49A),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.label(l10n),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: color,
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
      ],
    );
  }
}

class HomeStartButton extends StatelessWidget {
  const HomeStartButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.completed = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      child: AppButton(
        label: label,
        onPressed: onPressed,
        variant: completed
            ? AppButtonVariant.secondary
            : AppButtonVariant.primary,
      ),
    );
  }
}

String homeStartLabel(
  AppLocalizations l10n,
  TodayTraining? training, {
  int? pausedSessionId,
}) {
  if (training == null) {
    return l10n.homeChoosePlan;
  }
  if (training.todayCompleted) {
    return l10n.homeSeePlan;
  }
  if (!training.access.contentAccess) {
    return l10n.actionSubscribe;
  }
  if (pausedSessionId != null &&
      training.sessions.isNotEmpty &&
      training.sessions.first.id == pausedSessionId) {
    return l10n.homeResumeTraining;
  }
  final done = training.program.daysCompleted ?? 0;
  if (training.dayNumber <= 1 && done == 0) {
    return l10n.homeStartFirst;
  }
  return l10n.homeStartToday;
}

String homeTodayEyebrow(AppLocalizations l10n, TodayTraining? training) {
  if (training?.todayCompleted == true) {
    return l10n.homeCompletedEyebrow;
  }
  return l10n.homeTodayEyebrow;
}

String homeTodaySubtitle(AppLocalizations l10n, TodayTraining? training) {
  if (training == null) {
    return l10n.homeNoProgramBody;
  }
  if (training.todayCompleted) {
    final title = training.nextDayTitle;
    if (title != null && title.isNotEmpty) {
      if (civilDateIsTomorrow(training.nextAvailableOn)) {
        return l10n.homeTomorrowTraining(training.nextDayNumber ?? 2, title);
      }
      final date = formatCivilDayMonth(training.nextAvailableOn);
      if (date.isNotEmpty) {
        return l10n.homeNextUnlocksOn(date, training.nextDayNumber ?? 2, title);
      }
      return l10n.homeTomorrowTraining(training.nextDayNumber ?? 2, title);
    }
    return l10n.homeCompleted;
  }
  if (training.daySubtitle != null && training.daySubtitle!.isNotEmpty) {
    return '${training.daySubtitle} · ${training.estimatedMinutes} ${l10n.homeMinutes}';
  }
  return '${training.estimatedMinutes} ${l10n.homeMinutes}';
}

DateTime? parseCivilDate(String? iso) {
  if (iso == null || iso.isEmpty) {
    return null;
  }
  final parts = iso.split('-');
  if (parts.length != 3) {
    return null;
  }
  final year = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final day = int.tryParse(parts[2]);
  if (year == null || month == null || day == null) {
    return null;
  }
  return DateTime(year, month, day);
}

bool civilDateIsTomorrow(String? iso) {
  final date = parseCivilDate(iso);
  if (date == null) {
    return false;
  }
  final now = DateTime.now();
  final tomorrow = DateTime(
    now.year,
    now.month,
    now.day,
  ).add(const Duration(days: 1));
  return date.year == tomorrow.year &&
      date.month == tomorrow.month &&
      date.day == tomorrow.day;
}

String formatCivilDayMonth(String? iso) {
  final date = parseCivilDate(iso);
  if (date == null) {
    return '';
  }
  return DateFormat('dd/MM').format(date);
}
