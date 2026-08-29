import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class XpInfoPage extends ConsumerWidget {
  const XpInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final snapshot = ref
        .watch(progressProvider)
        .maybeWhen(data: (result) => result.valueOrNull, orElse: () => null);

    return AppScaffold(
      showBack: true,
      title: l10n.xpInfoTitle,
      body: ListView(
        children: [
          if (snapshot != null) ...[
            AppCard(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.rankingXp(snapshot.xp),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          snapshot.levelName == null ||
                                  snapshot.levelName!.isEmpty
                              ? l10n.progressXpCardBody
                              : l10n.progressLevelName(snapshot.levelName!),
                          style: TextStyle(
                            color: scheme.onSurfaceVariant,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.progressStreakDays(snapshot.streakDays),
                          style: TextStyle(
                            color: scheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.star_outline_rounded,
                    size: 36,
                    color: scheme.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
          AppText.subtitle(l10n.xpInfoLead),
          const SizedBox(height: 24),
          _Block(
            icon: Icons.star_outline_rounded,
            title: l10n.xpInfoGivesTitle,
            body: l10n.xpInfoGivesBody,
          ),
          const SizedBox(height: 12),
          _Block(
            icon: Icons.horizontal_rule_rounded,
            title: l10n.xpInfoSkipsTitle,
            body: l10n.xpInfoSkipsBody,
          ),
          const SizedBox(height: 12),
          _Block(
            icon: Icons.place_outlined,
            title: l10n.xpInfoWhereTitle,
            body: l10n.xpInfoWhereBody,
          ),
          const SizedBox(height: 12),
          _Block(
            icon: Icons.local_fire_department_outlined,
            title: l10n.xpInfoStreakTitle,
            body: l10n.xpInfoStreakBody,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: scheme.primary, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            body,
            style: TextStyle(color: scheme.onSurfaceVariant, height: 1.45),
          ),
        ],
      ),
    );
  }
}
