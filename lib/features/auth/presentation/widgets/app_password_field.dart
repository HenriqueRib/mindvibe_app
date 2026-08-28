import 'package:flutter/material.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.autofillHints,
  });

  final TextEditingController controller;
  final String label;
  final FormFieldValidator<String>? validator;
  final Iterable<String>? autofillHints;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      autofillHints: widget.autofillHints,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: IconButton(
          onPressed: () => setState(() => _obscure = !_obscure),
          tooltip: _obscure ? l10n.passwordShow : l10n.passwordHide,
          icon: Icon(
            _obscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
        ),
      ),
      validator: widget.validator,
    );
  }
}
