import 'package:shared_preferences/shared_preferences.dart';

class RememberedAccount {
  const RememberedAccount({required this.email, required this.remember});

  final String email;
  final bool remember;
}

class RememberedAccountStore {
  RememberedAccountStore({SharedPreferences? preferences})
    : _preferences = preferences;

  static const _emailKey = 'mindvibe.remembered_email';
  static const _rememberKey = 'mindvibe.remember_account';

  SharedPreferences? _preferences;

  Future<RememberedAccount> read() async {
    final prefs = await _prefs();
    return RememberedAccount(
      email: prefs.getString(_emailKey)?.trim() ?? '',
      remember: prefs.getBool(_rememberKey) ?? true,
    );
  }

  Future<void> setFromLogin({
    required String email,
    required bool remember,
  }) async {
    final prefs = await _prefs();
    if (!remember) {
      await prefs.remove(_emailKey);
      await prefs.setBool(_rememberKey, false);
      return;
    }
    await prefs.setString(_emailKey, email.trim());
    await prefs.setBool(_rememberKey, true);
  }

  Future<void> keepEmail(String email) async {
    final current = await read();
    if (!current.remember) {
      return;
    }
    final trimmed = email.trim();
    if (trimmed.isEmpty) {
      return;
    }
    await setFromLogin(email: trimmed, remember: true);
  }

  Future<void> clear() async {
    final prefs = await _prefs();
    await prefs.remove(_emailKey);
    await prefs.remove(_rememberKey);
  }

  Future<SharedPreferences> _prefs() async {
    return _preferences ??= await SharedPreferences.getInstance();
  }
}
