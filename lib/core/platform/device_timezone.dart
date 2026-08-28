import 'package:flutter/services.dart';

class DeviceTimezone {
  const DeviceTimezone();

  static const _channel = MethodChannel('br.mindvibe.app/timezone');

  Future<String> id() async {
    final value = await _channel.invokeMethod<String>('getLocalTimezone');
    if (value == null || value.isEmpty) {
      throw StateError('Fuso horário indisponível');
    }
    return value;
  }
}
