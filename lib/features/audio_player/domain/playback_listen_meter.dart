class PlaybackListenMeter {
  PlaybackListenMeter({this.maxSliceSeconds = 7200});

  final int maxSliceSeconds;
  DateTime? _since;
  bool _active = false;

  bool get isActive => _active;

  void start(DateTime now) {
    if (_active) {
      return;
    }
    _active = true;
    _since = now;
  }

  int take(DateTime now) {
    if (!_active || _since == null) {
      return 0;
    }
    final elapsed = now.difference(_since!).inSeconds;
    _since = now;
    if (elapsed < 1) {
      return 0;
    }
    return elapsed > maxSliceSeconds ? maxSliceSeconds : elapsed;
  }

  int pause(DateTime now) {
    final seconds = take(now);
    _active = false;
    _since = null;
    return seconds;
  }
}
