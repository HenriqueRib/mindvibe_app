import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mindvibe_app/core/platform/device_timezone.dart';
import 'package:mindvibe_app/features/analytics/data/analytics_client.dart';
import 'package:mindvibe_app/features/auth/domain/entities/auth_entities.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationScheduler {
  NotificationScheduler(
    this._analytics, {
    FlutterLocalNotificationsPlugin? plugin,
    DeviceTimezone timezone = const DeviceTimezone(),
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin(),
       _timezone = timezone;

  static const _id = 43;
  final AnalyticsClient _analytics;
  final FlutterLocalNotificationsPlugin _plugin;
  final DeviceTimezone _timezone;
  bool _ready = false;

  Future<void> initialize() async {
    if (_ready) {
      return;
    }
    tzdata.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation(await _timezone.id()));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (_) {
        _analytics.track('notification_opened');
      },
    );
    _ready = true;
  }

  Future<void> sync(
    UserAccount user, {
    required String title,
    required String body,
  }) async {
    await initialize();
    final enabled = user.notificationEnabled ?? false;
    final time = user.notificationTime;
    if (!enabled || time == null || time.isEmpty) {
      await _plugin.cancel(id: _id);
      return;
    }
    final parts = time.split(':');
    if (parts.length < 2) {
      return;
    }
    final hour = int.tryParse(parts[0]) ?? 8;
    final minute = int.tryParse(parts[1]) ?? 0;
    final status = await Permission.notification.request();
    if (!status.isGranted) {
      return;
    }
    await _plugin.zonedSchedule(
      id: _id,
      title: title,
      body: body,
      scheduledDate: _nextInstance(hour, minute),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'mindvibe_daily',
          'Treino diário',
          channelDescription: 'Lembrete local do treino de hoje',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    await _analytics.track('notification_scheduled', {
      'hour': hour,
      'minute': minute,
    });
  }

  tz.TZDateTime _nextInstance(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  Future<void> showNow({
    required String title,
    required String body,
    int id = 44,
  }) async {
    await initialize();
    final status = await Permission.notification.request();
    if (!status.isGranted) {
      return;
    }
    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'mindvibe_tools',
          'Ferramentas',
          channelDescription: 'Pomodoro, sala silenciosa e alertas de foco',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
