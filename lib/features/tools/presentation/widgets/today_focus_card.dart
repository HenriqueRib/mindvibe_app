import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class TodayFocusCard extends StatelessWidget {
  const TodayFocusCard({super.key, required this.l10n, this.focus});

  final AppLocalizations l10n;
  final DailyFocus? focus;

  @override
  Widget build(BuildContext context) {
    final hasFocus = focus != null && focus!.body.isNotEmpty;
    return hasFocus ? _chosen(context) : _invite(context);
  }

  Widget _invite(BuildContext context) {
    return ScaleOnTap(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.28),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Material(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(24),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => context.push(AppRoutes.clearMind),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.onPrimary.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.psychology_alt_outlined,
                          color: AppColors.onPrimary,
                          size: 30,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.onPrimary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    l10n.clearMindTitle,
                    style: const TextStyle(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 26,
                      height: 1.15,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.clearMindHomeCta,
                    style: TextStyle(
                      color: AppColors.onPrimary.withValues(alpha: 0.88),
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.onPrimary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Text(
                        l10n.clearMindStart,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
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

  Widget _chosen(BuildContext context) {
    final parked = focus!.parkedCount;
    return ScaleOnTap(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.16),
              blurRadius: 22,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: AppColors.primary.withValues(alpha: 0.12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: AppColors.primary.withValues(alpha: 0.35),
              width: 1.4,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => context.push(AppRoutes.clearMind),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.psychology_alt_outlined,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.clearMindHomeCard.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    focus!.body,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      height: 1.3,
                      letterSpacing: -0.3,
                    ),
                  ),
                  if (parked > 0) ...[
                    const SizedBox(height: 12),
                    Text(
                      l10n.clearMindParked(parked),
                      style: const TextStyle(
                        color: AppColors.muted,
                        height: 1.4,
                        fontSize: 14,
                      ),
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
