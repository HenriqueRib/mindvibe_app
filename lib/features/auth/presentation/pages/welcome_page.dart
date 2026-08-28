import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_brand_mark.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          const FadeSlideIn(child: AppBrandMark(size: 72, pulse: true)),
          const SizedBox(height: 20),
          FadeSlideIn(
            index: 1,
            child: Text(
              l10n.appName,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
            ),
          ),
          const SizedBox(height: 12),
          FadeSlideIn(index: 2, child: AppText.title(l10n.welcomeTitle)),
          const SizedBox(height: 12),
          FadeSlideIn(index: 3, child: AppText.subtitle(l10n.welcomeBody)),
          const Spacer(),
          FadeSlideIn(
            index: 4,
            child: AppButton(
              label: l10n.welcomeRegister,
              onPressed: () => context.push(AppRoutes.register),
            ),
          ),
          const SizedBox(height: 12),
          FadeSlideIn(
            index: 5,
            child: AppButton(
              label: l10n.welcomeLogin,
              variant: AppButtonVariant.secondary,
              onPressed: () => context.push(AppRoutes.login),
            ),
          ),
        ],
      ),
    );
  }
}
