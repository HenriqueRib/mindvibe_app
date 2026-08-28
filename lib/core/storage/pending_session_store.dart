import 'package:shared_preferences/shared_preferences.dart';

class PendingSessionStore {
  PendingSessionStore({SharedPreferences? preferences})
    : _preferences = preferences;

  static const _key = 'mindvibe.pending_complete_session_id';
  SharedPreferences? _preferences;

  Future<void> save(int sessionId) async {
    final prefs = await _prefs();
    await prefs.setInt(_key, sessionId);
  }

  Future<int?> read() async {
    final prefs = await _prefs();
    return prefs.getInt(_key);
  }

  Future<void> clear() async {
    final prefs = await _prefs();
    await prefs.remove(_key);
  }

  Future<SharedPreferences> _prefs() async {
    return _preferences ??= await SharedPreferences.getInstance();
  }
}
