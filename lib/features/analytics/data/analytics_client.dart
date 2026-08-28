import 'dart:convert';

import 'package:mindvibe_app/core/device/device_id_store.dart';
import 'package:mindvibe_app/core/network/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AnalyticsClient {
  AnalyticsClient({
    required ApiClient apiClient,
    required DeviceIdStore deviceIdStore,
    SharedPreferences? preferences,
    Uuid? uuid,
  }) : _api = apiClient,
       _deviceIdStore = deviceIdStore,
       _uuid = uuid ?? const Uuid(),
       _preferences = preferences;

  static const _queueKey = 'mindvibe.analytics_queue';
  static const _sensitive = {'email', 'password', 'token', 'authorization'};

  final ApiClient _api;
  final DeviceIdStore _deviceIdStore;
  final Uuid _uuid;
  SharedPreferences? _preferences;

  Future<void> track(
    String event, [
    Map<String, dynamic> properties = const {},
  ]) async {
    final item = {
      'event': event,
      'properties': _sanitize(properties),
      'client_event_id': _uuid.v4(),
      'device_uuid': await _deviceIdStore.getOrCreate(),
    };
    final queue = await _readQueue();
    queue.add(item);
    await _writeQueue(queue);
    await flush();
  }

  Future<void> flush() async {
    final queue = await _readQueue();
    if (queue.isEmpty) {
      return;
    }
    final result = await _api.post<void>(
      '/analytics/events',
      body: {'events': queue},
      parse: (_) {},
    );
    if (result.isSuccess) {
      await _writeQueue([]);
    }
  }

  Map<String, dynamic> _sanitize(Map<String, dynamic> properties) {
    return Map.fromEntries(
      properties.entries.where(
        (entry) => !_sensitive.contains(entry.key.toLowerCase()),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _readQueue() async {
    final prefs = await _prefs();
    final raw = prefs.getString(_queueKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }
    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      return [];
    }
    return decoded.whereType<Map>().map(Map<String, dynamic>.from).toList();
  }

  Future<void> _writeQueue(List<Map<String, dynamic>> queue) async {
    final prefs = await _prefs();
    await prefs.setString(_queueKey, jsonEncode(queue));
  }

  Future<SharedPreferences> _prefs() async {
    return _preferences ??= await SharedPreferences.getInstance();
  }
}
