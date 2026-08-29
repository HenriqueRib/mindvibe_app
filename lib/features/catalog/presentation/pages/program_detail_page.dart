import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/features/audio_player/presentation/widgets/cover_image.dart';
import 'package:mindvibe_app/features/catalog/presentation/enroll_program.dart';
import 'package:mindvibe_app/features/catalog/presentation/widgets/catalog_plan_card.dart';
import 'package:mindvibe_app/features/catalog/presentation/widgets/plan_goal_picker.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class ProgramDetailPage extends ConsumerWidget {
  const ProgramDetailPage({super.key, required this.programId});

  final int programId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final detail = ref.watch(programDetailProvider(programId));
    final current = ref
        .watch(todayProvider)
        .maybeWhen(data: (result) => result.valueOrNull, orElse: () => null);
    final loadedTitle = detail.maybeWhen(
      data: (result) => result.valueOrNull?.summary.title,
      orElse: () => null,
    );

    return AppScaffold(
      showBack: true,
      title: loadedTitle ?? l10n.catalogTitle,
      padding: EdgeInsets.zero,
      body: detail.when(
        loading: () => AppLoading(label: l10n.loadingLabel),
        error: (_, _) => AppError(
          title: l10n.errorLoadTitle,
          message: l10n.errorGeneric,
          retryLabel: l10n.actionRetry,
          onRetry: () => ref.invalidate(programDetailProvider(programId)),
        ),
        data: (result) => result.when(
          failure: (failure) => AppError(
            title: l10n.errorLoadTitle,
            message: failureMessage(failure, l10n),
            retryLabel: l10n.actionRetry,
            onRetry: () => ref.invalidate(programDetailProvider(programId)),
          ),
          success: (program) =>
              _DetailBody(program: program, current: current, l10n: l10n),
        ),
      ),
    );
  }
}

class _DetailBody extends ConsumerWidget {
  const _DetailBody({required this.program, required this.l10n, this.current});

  final ProgramDetail program;
  final TodayTraining? current;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = program.summary;
    final scheme = Theme.of(context).colorScheme;
    final accent = planAccentForSlug(summary.categorySlug);
    final isCurrent = current?.program.id == summary.id;
    final (lead, rest) = _splitLead(summary.description);
    final minutes = summary.estimatedMinutes;

    return ListView(
      children: [
        Stack(
          children: [
            CoverImage(
              url: summary.coverUrl,
              width: double.infinity,
              height: 228,
              radius: 0,
              icon: planGoalIcon(summary.categorySlug ?? ''),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 88,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Theme.of(context).scaffoldBackgroundColor,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 24,
              top: 16,
              child: PlanSlugBadge(slug: summary.slug, accent: accent),
            ),
            if (isCurrent)
              Positioned(
                right: 24,
                top: 16,
                child: CoverLabelBadge(label: l10n.catalogEnrollCurrent),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                summary.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _MetaChip(
                    icon: Icons.calendar_today_outlined,
                    label: l10n.catalogDays(summary.durationDays),
                    accent: accent,
                  ),
                  if (minutes != null && minutes > 0)
                    _MetaChip(
                      icon: Icons.schedule_outlined,
                      label: '$minutes ${l10n.homeMinutes}',
                      accent: accent,
                    ),
                  if (summary.freeDays > 0)
                    _MetaChip(
                      icon: Icons.favorite_border_rounded,
                      label: l10n.catalogFreeDays(summary.freeDays),
                      accent: AppColors.success,
                    ),
                ],
              ),
              if (isCurrent && summary.durationDays > 0) ...[
                const SizedBox(height: 20),
                AppProgressBar(
                  value: ((summary.daysCompleted ?? 0) / summary.durationDays)
                      .clamp(0.0, 1.0),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.homeDayProgress(
                    (summary.currentDayNumber ?? summary.daysCompleted ?? 1)
                        .clamp(1, summary.durationDays),
                    summary.durationDays,
                  ),
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              if (lead.isNotEmpty) ...[
                const SizedBox(height: 22),
                Text(
                  lead,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                    letterSpacing: -0.2,
                    color: scheme.onSurface,
                  ),
                ),
                if (rest.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    rest,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.55,
                      fontWeight: FontWeight.w500,
                      color: scheme.onSurface.withValues(alpha: 0.82),
                    ),
                  ),
                ],
              ],
              const SizedBox(height: 24),
              AppButton(
                label: isCurrent
                    ? l10n.homeSeePlan
                    : catalogEnrollLabel(
                        l10n: l10n,
                        program: summary,
                        current: current,
                      ),
                onPressed: isCurrent
                    ? () => context.push(AppRoutes.plan)
                    : () => enrollInProgram(
                        context: context,
                        ref: ref,
                        l10n: l10n,
                        program: summary,
                        current: current,
                      ),
              ),
              if (current != null && !isCurrent) ...[
                const SizedBox(height: 10),
                Text(
                  l10n.catalogBrowseHint,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: scheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              Text(
                l10n.catalogPlanDays,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                  color: accent,
                ),
              ),
              const SizedBox(height: 12),
              AppCard(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  children: [
                    for (var i = 0; i < program.days.length; i++) ...[
                      if (i > 0)
                        Divider(
                          height: 1,
                          color: scheme.outline.withValues(alpha: 0.7),
                        ),
                      _DayRow(day: program.days[i], l10n: l10n, accent: accent),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static (String, String) _splitLead(String? raw) {
    final text = raw?.trim() ?? '';
    if (text.isEmpty) {
      return ('', '');
    }
    final match = RegExp(r'^(.*?[.!?])\s+(.+)$', dotAll: true).firstMatch(text);
    if (match == null) {
      return (text, '');
    }
    return (match.group(1)!.trim(), match.group(2)!.trim());
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: accent.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: accent),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({required this.day, required this.l10n, required this.accent});

  final ProgramDayPreview day;
  final AppLocalizations l10n;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '${day.dayNumber}',
              style: TextStyle(fontWeight: FontWeight.w800, color: accent),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                if (day.subtitle != null && day.subtitle!.trim().isNotEmpty)
                  Text(
                    day.subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${day.estimatedMinutes} ${l10n.homeMinutes}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}
