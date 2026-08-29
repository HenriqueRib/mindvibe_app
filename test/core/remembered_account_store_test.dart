import 'package:flutter_test/flutter_test.dart';
import 'package:mindvibe_app/core/storage/remembered_account_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('guarda e-mail quando lembrar está ligado', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final store = RememberedAccountStore(preferences: prefs);

    await store.setFromLogin(email: 'ana@gmail.com', remember: true);
    final remembered = await store.read();

    expect(remembered.remember, isTrue);
    expect(remembered.email, 'ana@gmail.com');
  });

  test('apaga e-mail quando lembrar está desligado', () async {
    SharedPreferences.setMockInitialValues({
      'mindvibe.remembered_email': 'ana@gmail.com',
      'mindvibe.remember_account': true,
    });
    final prefs = await SharedPreferences.getInstance();
    final store = RememberedAccountStore(preferences: prefs);

    await store.setFromLogin(email: 'ana@gmail.com', remember: false);
    final remembered = await store.read();

    expect(remembered.remember, isFalse);
    expect(remembered.email, isEmpty);
  });

  test('não regrava e-mail se o usuário desligou lembrar', () async {
    SharedPreferences.setMockInitialValues({
      'mindvibe.remember_account': false,
    });
    final prefs = await SharedPreferences.getInstance();
    final store = RememberedAccountStore(preferences: prefs);

    await store.keepEmail('ana@gmail.com');
    final remembered = await store.read();

    expect(remembered.email, isEmpty);
    expect(remembered.remember, isFalse);
  });
}
