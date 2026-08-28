import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/features/auth/domain/auth_validators.dart';
import 'package:mindvibe_app/features/auth/presentation/providers/session_controller.dart';
import 'package:mindvibe_app/features/auth/presentation/widgets/auth_layout.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _loading = false;
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _loading = true);
    final result = await ref
        .read(sessionControllerProvider.notifier)
        .forgotPassword(_email.text.trim());
    if (!mounted) {
      return;
    }
    setState(() => _loading = false);
    result.when(
      success: (_) => setState(() => _sent = true),
      failure: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failureMessage(error, AppLocalizations.of(context))),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AuthLayout(
      title: l10n.forgotTitle,
      subtitle: l10n.forgotSubtitle,
      child: _sent
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.subtitle(l10n.forgotSent),
                const SizedBox(height: 24),
                AppButton(
                  label: l10n.resetTitle,
                  onPressed: () => context.push(AppRoutes.resetPassword),
                ),
              ],
            )
          : Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: l10n.fieldEmail),
                    validator: (value) => switch (AuthValidators.email(value)) {
                      'required' => l10n.validationRequired,
                      'email' => l10n.validationEmail,
                      _ => null,
                    },
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: l10n.actionSend,
                    loading: _loading,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
    );
  }
}
