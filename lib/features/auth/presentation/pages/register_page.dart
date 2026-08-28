import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/features/auth/domain/auth_validators.dart';
import 'package:mindvibe_app/features/auth/presentation/providers/session_controller.dart';
import 'package:mindvibe_app/features/auth/presentation/widgets/app_password_field.dart';
import 'package:mindvibe_app/features/auth/presentation/widgets/auth_layout.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _loading = true);
    final result = await ref
        .read(sessionControllerProvider.notifier)
        .register(
          name: _name.text.trim(),
          email: _email.text.trim(),
          password: _password.text,
        );
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
      title: l10n.registerTitle,
      subtitle: l10n.registerSubtitle,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: l10n.fieldName),
              validator: (value) => AuthValidators.required(value) == null
                  ? null
                  : l10n.validationRequired,
            ),
            const SizedBox(height: 12),
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
            const SizedBox(height: 12),
            AppPasswordField(
              controller: _password,
              label: l10n.fieldPassword,
              validator: (value) => switch (AuthValidators.password(value)) {
                'required' => l10n.validationRequired,
                'password' => l10n.validationPasswordMin,
                _ => null,
              },
            ),
            const SizedBox(height: 12),
            AppPasswordField(
              controller: _confirm,
              label: l10n.fieldPasswordConfirm,
              validator: (value) {
                if (value != _password.text) {
                  return l10n.validationPasswordMatch;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            AppButton(
              label: l10n.actionRegister,
              loading: _loading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
