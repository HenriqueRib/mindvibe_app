import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/audio_player/presentation/widgets/cover_image.dart';
import 'package:mindvibe_app/features/auth/domain/entities/auth_entities.dart';
import 'package:mindvibe_app/features/billing/premium_access.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

Future<void> showAcademyMenu(
  BuildContext host, {
  required AppLocalizations l10n,
  required UserAccount? user,
}) {
  HapticFeedback.mediumImpact();
  return showGeneralDialog<void>(
    context: host,
    barrierLabel: l10n.menuClose,
    barrierDismissible: true,
    barrierColor: const Color(0x99000000),
    transitionDuration: const Duration(milliseconds: 520),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Align(
        alignment: Alignment.centerLeft,
        child: AcademyMenuPanel(
          l10n: l10n,
          user: user,
          navContext: host,
          onClose: () => Navigator.of(context).pop(),
          onSelect: (action) {
            Navigator.of(context).pop();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (host.mounted) {
                action();
              }
            });
          },
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return SlideTransition(
        position: Tween(
          begin: const Offset(-1.04, 0),
          end: Offset.zero,
        ).animate(curved),
        child: FadeTransition(opacity: curved, child: child),
      );
    },
  );
}

class AcademyMenuButton extends StatelessWidget {
  const AcademyMenuButton({
    super.key,
    required this.l10n,
    required this.user,
    this.foreground,
  });

  final AppLocalizations l10n;
  final UserAccount? user;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final color = foreground ?? Theme.of(context).colorScheme.onSurface;
    return ScaleOnTap(
      child: Tooltip(
        message: l10n.menuOpen,
        child: InkWell(
          onTap: () => showAcademyMenu(context, l10n: l10n, user: user),
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 44,
            height: 44,
            child: Center(child: _MenuMark(color: color)),
          ),
        ),
      ),
    );
  }
}

class AcademyMenuPanel extends StatelessWidget {
  const AcademyMenuPanel({
    super.key,
    required this.l10n,
    required this.user,
    required this.navContext,
    required this.onClose,
    required this.onSelect,
  });

  final AppLocalizations l10n;
  final UserAccount? user;
  final BuildContext navContext;
  final VoidCallback onClose;
  final void Function(VoidCallback action) onSelect;

  static const _ink = Color(0xFFF6F1E8);
  static const _muted = Color(0xFFC9D0CC);
  static const _panel = Color(0xFF16302C);

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.sizeOf(context).width * 0.86).clamp(280.0, 360.0);
    var index = 0;

    Widget section(String title) {
      final current = index;
      index += 1;
      return FadeSlideIn(
        index: current.clamp(0, 10),
        offset: 14,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 18, 4, 8),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFFD7B49A),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
            ),
          ),
        ),
      );
    }

    final premium = isPremiumAccount(user);

    Widget item({
      required IconData icon,
      required Color accent,
      required String title,
      required String hint,
      required VoidCallback action,
      bool requiresPremium = false,
    }) {
      final current = index;
      index += 1;
      final locked = requiresPremium && !premium;
      return FadeSlideIn(
        index: current.clamp(0, 10),
        offset: 16,
        child: _MenuRow(
          icon: icon,
          accent: accent,
          title: title,
          hint: hint,
          locked: locked,
          onTap: () => onSelect(
            locked ? () => navContext.push(AppRoutes.paywall) : action,
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: width,
        height: MediaQuery.sizeOf(context).height,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: _panel,
            borderRadius: BorderRadius.horizontal(right: Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 40,
                offset: Offset(8, 0),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(32),
            ),
            child: Stack(
              children: [
                const Positioned(
                  right: -40,
                  bottom: 80,
                  child: Icon(
                    Icons.self_improvement_outlined,
                    size: 180,
                    color: Color(0x14F6F1E8),
                  ),
                ),
                const Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: ColoredBox(
                    color: AppColors.accent,
                    child: SizedBox(width: 3),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 8, 16, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.spa_outlined,
                              color: AppColors.accent,
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                l10n.menuTitle,
                                style: const TextStyle(
                                  color: _ink,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: l10n.menuClose,
                              onPressed: onClose,
                              color: _muted,
                              icon: const Icon(Icons.close_rounded),
                            ),
                          ],
                        ),
                        Text(
                          l10n.menuSubtitle,
                          style: const TextStyle(color: _muted, height: 1.35),
                        ),
                        const SizedBox(height: 18),
                        _MenuIdentity(
                          user: user,
                          l10n: l10n,
                          onTap: () => onSelect(
                            () => StatefulNavigationShell.of(
                              navContext,
                            ).goBranch(2),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.only(bottom: 12),
                            children: [
                              section(l10n.menuSectionTrain),
                              item(
                                icon: Icons.calendar_month_outlined,
                                accent: AppColors.accent,
                                title: l10n.menuMyPlan,
                                hint: l10n.menuMyPlanHint,
                                action: () => navContext.push(AppRoutes.plan),
                              ),
                              item(
                                icon: Icons.account_balance_outlined,
                                accent: const Color(0xFFD7B49A),
                                title: l10n.menuPlans,
                                hint: l10n.menuPlansHint,
                                action: () =>
                                    navContext.push(AppRoutes.explore),
                              ),
                              section(l10n.menuSectionAudio),
                              item(
                                icon: Icons.headphones_outlined,
                                accent: const Color(0xFF8FB4A8),
                                title: l10n.menuAudios,
                                hint: l10n.menuAudiosHint,
                                requiresPremium: true,
                                action: () =>
                                    navContext.push(AppRoutes.moments),
                              ),
                              section(l10n.menuSectionExercise),
                              item(
                                icon: Icons.fitness_center_outlined,
                                accent: const Color(0xFF6B8A7A),
                                title: l10n.dailyHubTitle,
                                hint: l10n.menuDailyHint,
                                requiresPremium: true,
                                action: () => navContext.push(AppRoutes.daily),
                              ),
                              item(
                                icon: Icons.psychology_outlined,
                                accent: const Color(0xFF3A6EA5),
                                title: l10n.homeExercisesTitle,
                                hint: l10n.menuExercisesHint,
                                requiresPremium: true,
                                action: () =>
                                    navContext.push(AppRoutes.exerciseLibrary),
                              ),
                              section(l10n.menuSectionTools),
                              item(
                                icon: Icons.spa_outlined,
                                accent: const Color(0xFFC46A3A),
                                title: l10n.homeToolCheckin,
                                hint: l10n.menuCheckinHint,
                                action: () =>
                                    navContext.push(AppRoutes.checkin),
                              ),
                              item(
                                icon: Icons.psychology_alt_outlined,
                                accent: const Color(0xFF6B8A7A),
                                title: l10n.homeToolClearMind,
                                hint: l10n.menuClearMindHint,
                                action: () =>
                                    navContext.push(AppRoutes.clearMind),
                              ),
                              item(
                                icon: Icons.edit_note_outlined,
                                accent: const Color(0xFFD7B49A),
                                title: l10n.homeToolJournal,
                                hint: l10n.menuJournalHint,
                                action: () =>
                                    navContext.push(AppRoutes.journal),
                              ),
                              item(
                                icon: Icons.push_pin_outlined,
                                accent: const Color(0xFFA8B4C8),
                                title: l10n.homeToolThought,
                                hint: l10n.menuThoughtHint,
                                requiresPremium: true,
                                action: () =>
                                    navContext.push(AppRoutes.thoughts),
                              ),
                              item(
                                icon: Icons.timer_outlined,
                                accent: AppColors.accent,
                                title: l10n.homeToolPomodoro,
                                hint: l10n.menuPomodoroHint,
                                requiresPremium: true,
                                action: () =>
                                    navContext.push(AppRoutes.pomodoro),
                              ),
                              item(
                                icon: Icons.self_improvement_outlined,
                                accent: const Color(0xFF8FB4A8),
                                title: l10n.silentRoomTitle,
                                hint: l10n.menuSilentRoomHint,
                                requiresPremium: true,
                                action: () =>
                                    navContext.push(AppRoutes.silentRoom),
                              ),
                              item(
                                icon: Icons.nights_stay_outlined,
                                accent: const Color(0xFF6B6B8A),
                                title: l10n.dayCloseTitle,
                                hint: l10n.menuDayCloseHint,
                                requiresPremium: true,
                                action: () =>
                                    navContext.push(AppRoutes.dayClose),
                              ),
                              section(l10n.menuSectionJourney),
                              item(
                                icon: Icons.history_rounded,
                                accent: const Color(0xFFD7B49A),
                                title: l10n.historyTitle,
                                hint: l10n.menuHistoryHint,
                                action: () =>
                                    navContext.push(AppRoutes.history),
                              ),
                              item(
                                icon: Icons.public_outlined,
                                accent: const Color(0xFFC46A3A),
                                title: l10n.rankingTitle,
                                hint: l10n.menuRankingHint,
                                action: () =>
                                    navContext.push(AppRoutes.ranking),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuIdentity extends StatelessWidget {
  const _MenuIdentity({required this.user, required this.l10n, this.onTap});

  final UserAccount? user;
  final AppLocalizations l10n;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final name = user?.name.trim() ?? '';
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
          decoration: BoxDecoration(
            color: const Color(0x14F6F1E8),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0x22F6F1E8)),
          ),
          child: Row(
            children: [
              _MenuAvatar(user: user),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.isEmpty ? l10n.appName : name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFF6F1E8),
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isPremiumAccount(user)
                          ? l10n.profilePlanPremium
                          : l10n.profilePlanFree,
                      style: const TextStyle(
                        color: Color(0xFFC9D0CC),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Color(0x66F6F1E8)),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuAvatar extends StatelessWidget {
  const _MenuAvatar({required this.user});

  final UserAccount? user;

  @override
  Widget build(BuildContext context) {
    const size = 44.0;
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
        color: const Color(0x33F6F1E8),
        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 18))),
      );
    } else {
      child = ColoredBox(
        color: AppColors.accent.withValues(alpha: 0.22),
        child: Center(
          child: Text(
            initial,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFFF6F1E8),
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

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.accent,
    required this.title,
    required this.hint,
    required this.onTap,
    this.locked = false,
  });

  final IconData icon;
  final Color accent;
  final String title;
  final String hint;
  final VoidCallback onTap;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: ScaleOnTap(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: accent, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Color(0xFFF6F1E8),
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          hint,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFFC9D0CC),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0x66F6F1E8),
                  ),
                  if (locked) ...[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.lock_outline_rounded,
                      color: Color(0x99F6F1E8),
                      size: 16,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuMark extends StatelessWidget {
  const _MenuMark({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    Widget bar(double width) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: width,
          height: 2.2,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }

    return SizedBox(
      width: 22,
      height: 16,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [bar(22), bar(16), bar(20)],
      ),
    );
  }
}
