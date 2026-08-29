import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
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
    final scheme = Theme.of(context).colorScheme;
    return ScaleOnTap(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: scheme.primary.withValues(alpha: 0.14),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: scheme.primary,
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
                          color: scheme.onPrimary.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(
                          Icons.psychology_alt_outlined,
                          color: scheme.onPrimary,
                          size: 30,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: scheme.onPrimary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    l10n.clearMindTitle,
                    style: TextStyle(
                      color: scheme.onPrimary,
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
                      color: scheme.onPrimary.withValues(alpha: 0.88),
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: scheme.onPrimary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Text(
                        l10n.clearMindStart,
                        style: TextStyle(
                          color: scheme.primary,
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
    final scheme = Theme.of(context).colorScheme;
    return ScaleOnTap(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: scheme.primary.withValues(alpha: 0.10),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: scheme.primary.withValues(alpha: 0.12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: scheme.primary.withValues(alpha: 0.35),
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
                          color: scheme.primary.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.psychology_alt_outlined,
                          color: scheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.clearMindHomeCard.toUpperCase(),
                          style: TextStyle(
                            color: scheme.primary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward_rounded, color: scheme.primary),
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
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
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
