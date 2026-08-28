import 'package:flutter/material.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/audio_player/presentation/widgets/cover_image.dart';
import 'package:mindvibe_app/features/catalog/presentation/widgets/plan_goal_picker.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class CatalogPlanCard extends StatelessWidget {
  const CatalogPlanCard({
    super.key,
    required this.program,
    required this.l10n,
    required this.onTap,
    this.isCurrent = false,
    this.index = 0,
  });

  final ProgramSummary program;
  final AppLocalizations l10n;
  final VoidCallback onTap;
  final bool isCurrent;
  final int index;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = planAccentForSlug(program.categorySlug);
    final minutes = program.estimatedMinutes;

    return FadeSlideIn(
      index: index.clamp(0, 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          boxShadow: isCurrent
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.28),
                    blurRadius: 22,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: AppCard(
          padding: EdgeInsets.zero,
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CoverImage(
                    url: program.coverUrl,
                    width: double.infinity,
                    height: 148,
                    radius: 0,
                    icon: planGoalIcon(program.categorySlug ?? ''),
                  ),
                  Positioned(
                    left: 14,
                    top: 14,
                    child: PlanSlugBadge(slug: program.slug, accent: accent),
                  ),
                  if (isCurrent)
                    Positioned(
                      right: 14,
                      top: 14,
                      child: _CurrentBadge(label: l10n.catalogEnrollCurrent),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 16, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        letterSpacing: -0.3,
                      ),
                    ),
                    if (program.description != null &&
                        program.description!.trim().isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        program.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: scheme.onSurface.withValues(alpha: 0.72),
                          height: 1.45,
                          fontSize: 14,
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 15,
                          color: accent,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.catalogDays(program.durationDays),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurface,
                          ),
                        ),
                        if (minutes != null && minutes > 0) ...[
                          const SizedBox(width: 14),
                          Icon(Icons.schedule_outlined, size: 16, color: accent),
                          const SizedBox(width: 6),
                          Text(
                            '$minutes ${l10n.homeMinutes}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: scheme.onSurface,
                            ),
                          ),
                        ],
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: accent,
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlanSlugBadge extends StatelessWidget {
  const PlanSlugBadge({super.key, required this.slug, required this.accent});

  final String slug;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: accent.withValues(alpha: 0.85)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.45),
            blurRadius: 14,
            spreadRadius: 0.4,
          ),
        ],
      ),
      child: Text(
        slug,
        style: TextStyle(
          color: Color.lerp(accent, Colors.white, 0.35),
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
          height: 1,
        ),
      ),
    );
  }
}

class _CurrentBadge extends StatelessWidget {
  const _CurrentBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xE6F6F1E8),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
