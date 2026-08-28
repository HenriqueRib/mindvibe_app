import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PausedTraining {
  const PausedTraining({
    required this.sessionId,
    required this.blockIndex,
    this.startedAtMs,
  });

  final int sessionId;
  final int blockIndex;
  final int? startedAtMs;

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'block_index': blockIndex,
      'started_at_ms': startedAtMs,
    };
  }

  static PausedTraining? fromJson(Map<String, dynamic> json) {
    final sessionId = _asInt(json['session_id']);
    if (sessionId == null) {
      return null;
    }
    return PausedTraining(
      sessionId: sessionId,
      blockIndex: _asInt(json['block_index']) ?? 0,
      startedAtMs: _asInt(json['started_at_ms']),
    );
  }

  static int? _asInt(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse('$value');
  }
}

class PausedTrainingStore {
  PausedTrainingStore({SharedPreferences? preferences})
    : _preferences = preferences;

  static const _key = 'mindvibe.paused_training';
  SharedPreferences? _preferences;

  Future<void> save(PausedTraining paused) async {
    final prefs = await _prefs();
    await prefs.setString(_key, jsonEncode(paused.toJson()));
  }

  Future<PausedTraining?> read() async {
    final prefs = await _prefs();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return PausedTraining.fromJson(decoded);
      }
      if (decoded is Map) {
        return PausedTraining.fromJson(Map<String, dynamic>.from(decoded));
      }
    } catch (_) {}
    return null;
  }

  Future<void> clear() async {
    final prefs = await _prefs();
    await prefs.remove(_key);
  }

  Future<SharedPreferences> _prefs() async {
    return _preferences ??= await SharedPreferences.getInstance();
  }
}
