import 'package:flutter/material.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_brand_mark.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showBack: Navigator.of(context).canPop(),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          const AppBrandMark(size: 48),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).appName,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 12),
          AppText.title(title),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            AppText.subtitle(subtitle!),
          ],
          const SizedBox(height: 32),
          child,
        ],
      ),
    );
  }
}
