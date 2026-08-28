import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/features/auth/domain/auth_validators.dart';
import 'package:mindvibe_app/features/auth/presentation/providers/session_controller.dart';
import 'package:mindvibe_app/features/auth/presentation/widgets/app_password_field.dart';
import 'package:mindvibe_app/features/auth/presentation/widgets/auth_layout.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _loading = true);
    final result = await ref
        .read(sessionControllerProvider.notifier)
        .login(email: _email.text.trim(), password: _password.text);
    if (!mounted) {
      return;
    }
    setState(() => _loading = false);
    result.when(
      success: (_) {},
      failure: (error) {
        if (error.isDeviceHasAccount) {
          return;
        }
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
      title: l10n.loginTitle,
      subtitle: l10n.loginSubtitle,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              decoration: InputDecoration(labelText: l10n.fieldEmail),
              validator: (value) => switch (AuthValidators.email(value)) {
                'required' => l10n.validationRequired,
                'email' => l10n.validationEmail,
                _ => null,
              },
            ),
            const SizedBox(height: 12),
            AppPasswordField(
              controller: _password,
              label: l10n.fieldPassword,
              autofillHints: const [AutofillHints.password],
              validator: (value) => switch (AuthValidators.password(value)) {
                'required' => l10n.validationRequired,
                'password' => l10n.validationPasswordMin,
                _ => null,
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.push(AppRoutes.forgotPassword),
                child: Text(l10n.actionForgotPassword),
              ),
            ),
            const SizedBox(height: 8),
            AppButton(
              label: l10n.actionLogin,
              loading: _loading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
