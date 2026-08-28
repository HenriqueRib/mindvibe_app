import 'package:flutter/material.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class XpInfoPage extends StatelessWidget {
  const XpInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppScaffold(
      showBack: true,
      title: l10n.xpInfoTitle,
      body: ListView(
        children: [
          AppText.subtitle(l10n.xpInfoLead, align: TextAlign.center),
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
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 22),
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
            style: const TextStyle(color: AppColors.muted, height: 1.45),
          ),
        ],
      ),
    );
  }
}
