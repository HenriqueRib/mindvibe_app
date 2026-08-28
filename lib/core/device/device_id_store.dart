import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class DeviceIdStore {
  DeviceIdStore({FlutterSecureStorage? storage, Uuid? uuid})
    : _storage = storage ?? const FlutterSecureStorage(),
      _uuid = uuid ?? const Uuid();

  static const _key = 'mindvibe.device_uuid';
  final FlutterSecureStorage _storage;
  final Uuid _uuid;

  Future<String> getOrCreate() async {
    final existing = await _storage.read(key: _key);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }
    final created = _uuid.v4();
    await _storage.write(key: _key, value: created);
    return created;
  }
}

String currentPlatformName() {
  if (kIsWeb) {
    return 'android';
  }
  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS:
      return 'ios';
    default:
      return 'android';
  }
}
