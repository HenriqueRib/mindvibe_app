import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindvibe_app/features/auth/domain/auth_validators.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

void main() {
  test('valida e-mail e senha sem acoplar na UI', () {
    expect(AuthValidators.email(null), 'required');
    expect(AuthValidators.email('abc'), 'email');
    expect(AuthValidators.email('ana@gmail.com'), isNull);
    expect(AuthValidators.password('123'), 'password');
    expect(AuthValidators.password('secret12'), isNull);
  });

  testWidgets('formulário de login mostra validação em pt-BR', (tester) async {
    final formKey = GlobalKey<FormState>();
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pt', 'BR'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Builder(
          builder: (context) {
            final l10n = AppLocalizations.of(context);
            return Scaffold(
              body: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: l10n.fieldEmail),
                      validator: (value) =>
                          switch (AuthValidators.email(value)) {
                            'required' => l10n.validationRequired,
                            'email' => l10n.validationEmail,
                            _ => null,
                          },
                    ),
                    TextButton(
                      onPressed: () => formKey.currentState?.validate(),
                      child: Text(l10n.actionLogin),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Entrar'));
    await tester.pump();
    expect(find.text('Preencha este campo.'), findsOneWidget);
  });
}
