import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/auth/presentation/providers/session_controller.dart';
import 'package:mindvibe_app/features/auth/presentation/widgets/auth_layout.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class DeviceAssociatedPage extends ConsumerWidget {
  const DeviceAssociatedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(sessionControllerProvider);
    final email = session.maskedEmail ?? '—';

    return AuthLayout(
      title: l10n.deviceAssociatedTitle,
      subtitle: l10n.deviceAssociatedBody(email),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.subtitle(l10n.deviceAssociatedHint),
          const SizedBox(height: 32),
          AppButton(
            label: l10n.actionLogin,
            onPressed: () {
              ref
                  .read(sessionControllerProvider.notifier)
                  .prepareAssociatedLogin();
              context.push(AppRoutes.login);
            },
          ),
          const SizedBox(height: 12),
          AppButton(
            label: l10n.actionForgotPassword,
            variant: AppButtonVariant.secondary,
            onPressed: () => context.push(AppRoutes.forgotPassword),
          ),
          const SizedBox(height: 12),
          AppButton(
            label: l10n.actionTransferDevice,
            variant: AppButtonVariant.ghost,
            onPressed: () {
              ref
                  .read(sessionControllerProvider.notifier)
                  .markPendingTransfer();
              context.push(AppRoutes.login);
            },
          ),
        ],
      ),
    );
  }
}
