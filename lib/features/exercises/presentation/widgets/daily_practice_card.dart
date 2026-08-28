import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/billing/premium_access.dart';
import 'package:mindvibe_app/features/exercises/domain/daily_drills.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class DailyPracticeCard extends StatelessWidget {
  const DailyPracticeCard({
    super.key,
    required this.l10n,
    required this.isPremium,
    this.progress,
  });

  final AppLocalizations l10n;
  final bool isPremium;
  final ProgressSnapshot? progress;

  @override
  Widget build(BuildContext context) {
    final checkin = progress?.checkin.today;
    final saturated = progressLooksSaturated(
      mood: checkin?.mood,
      energy: checkin?.energy,
      hasTodayFocus: progress?.todayFocus != null,
    );
    final families = saturated
        ? [l10n.dailyMetaSenses, l10n.dailyMetaSort, l10n.dailyMetaSilence]
        : [
            '5 min · ${l10n.dailyFamilyFocus}',
            '5 min · ${l10n.dailyFamilyMemory}',
            '5 min · ${l10n.dailyFamilyCreate}',
          ];
    return AppCard(
      onTap: () => openMaybePremium(
        context,
        isPremium: isPremium,
        action: () => context.push(AppRoutes.daily),
      ),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.dailyHomeCta.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    fontSize: 12,
                  ),
                ),
              ),
              if (!isPremium)
                const Icon(
                  Icons.lock_outline_rounded,
                  size: 18,
                  color: Color(0xFFD7B49A),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            saturated ? l10n.dailyCircuitSaturated : l10n.dailyCircuitFocus,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final family in families)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    family,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
