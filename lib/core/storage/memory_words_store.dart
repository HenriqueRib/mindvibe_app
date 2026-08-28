import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MemoryWordsStore {
  MemoryWordsStore({SharedPreferences? preferences})
    : _preferences = preferences;

  static const _key = 'mindvibe.memory_words';
  SharedPreferences? _preferences;

  Future<List<String>> read() async {
    final prefs = await _prefs();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) {
      return const [];
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .map((item) => item.toString().trim())
            .where((item) => item.isNotEmpty)
            .toList();
      }
    } catch (_) {}
    return const [];
  }

  Future<void> save(List<String> words) async {
    final prefs = await _prefs();
    final unique = <String>[];
    final seen = <String>{};
    for (final word in words) {
      final trimmed = word.trim();
      if (trimmed.isEmpty) {
        continue;
      }
      final key = trimmed.toLowerCase();
      if (seen.add(key)) {
        unique.add(trimmed);
      }
    }
    await prefs.setString(_key, jsonEncode(unique));
  }

  Future<SharedPreferences> _prefs() async {
    return _preferences ??= await SharedPreferences.getInstance();
  }
}
