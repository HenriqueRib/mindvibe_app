import 'package:flutter_test/flutter_test.dart';
import 'package:mindvibe_app/features/audio_player/domain/playback_listen_meter.dart';

void main() {
  test('credits wall-clock time while playing, not track duration', () {
    final meter = PlaybackListenMeter();
    final start = DateTime(2026, 8, 20, 12, 11);

    meter.start(start);
    expect(meter.take(start.add(const Duration(minutes: 60))), 3600);
  });

  test('does not credit time while paused', () {
    final meter = PlaybackListenMeter();
    final start = DateTime(2026, 8, 20, 12, 11);

    meter.start(start);
    expect(meter.pause(start.add(const Duration(minutes: 2))), 120);

    expect(meter.take(start.add(const Duration(minutes: 40))), 0);
    meter.start(start.add(const Duration(minutes: 40)));
    expect(meter.take(start.add(const Duration(minutes: 41))), 60);
  });

  test('seeking does not create extra credit on its own', () {
    final meter = PlaybackListenMeter();
    final start = DateTime(2026, 8, 20, 12, 11);

    meter.start(start);
    expect(meter.take(start.add(const Duration(seconds: 90))), 90);
  });

  test(
    'caps a stuck slice so one event cannot dump hours beyond the limit',
    () {
      final meter = PlaybackListenMeter(maxSliceSeconds: 120);
      final start = DateTime(2026, 8, 20, 12);

      meter.start(start);
      expect(meter.pause(start.add(const Duration(hours: 3))), 120);
    },
  );
}
