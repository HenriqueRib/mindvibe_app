enum BlinkPhase { lookAway, close, squeeze, open }

enum BlinkVariant { closeSqueezeOpen, completeBlinks, screenBreak20 }

BlinkVariant blinkVariantFrom(String? raw) {
  return switch ((raw ?? '').toLowerCase()) {
    'complete_blinks' || 'complete' || 'micro' => BlinkVariant.completeBlinks,
    'screen_break_20' || 'screen_break' || '202020' || '20-20-20' =>
      BlinkVariant.screenBreak20,
    'close_squeeze_open' || 'cso' || 'squeeze' => BlinkVariant.closeSqueezeOpen,
    _ => BlinkVariant.closeSqueezeOpen,
  };
}

class BlinkCycleConfig {
  const BlinkCycleConfig({
    required this.reps,
    this.closeSeconds = 2,
    this.squeezeSeconds = 2,
    this.openSeconds = 2,
    this.lookAwaySeconds = 0,
    this.setsPerDay = 1,
    this.variant = BlinkVariant.closeSqueezeOpen,
    this.disclaimer = false,
  });

  factory BlinkCycleConfig.fromJson(Map<String, dynamic> json) {
    final phases = json['phase_seconds'];
    final phaseMap = phases is Map
        ? Map<String, dynamic>.from(phases)
        : const <String, dynamic>{};
    final variant = blinkVariantFrom(json['variant'] as String?);
    final close = (phaseMap['close'] as num?)?.toInt() ?? 2;
    final squeezeRaw = (phaseMap['squeeze'] as num?)?.toInt();
    final open = (phaseMap['open'] as num?)?.toInt() ?? 2;
    final squeeze =
        squeezeRaw ?? (variant == BlinkVariant.closeSqueezeOpen ? 2 : 0);
    final lookAway = variant == BlinkVariant.screenBreak20
        ? ((json['duration_seconds'] as num?)?.toInt() ?? 20)
        : ((json['look_away_seconds'] as num?)?.toInt() ?? 0);
    final setsRaw = (json['sets_per_day'] as num?)?.toInt() ?? 0;
    final setsPerDay = setsRaw > 0
        ? setsRaw
        : (variant == BlinkVariant.closeSqueezeOpen ? 3 : 1);

    return BlinkCycleConfig(
      reps:
          (json['reps'] as num?)?.toInt() ??
          switch (variant) {
            BlinkVariant.closeSqueezeOpen => 15,
            BlinkVariant.completeBlinks => 8,
            BlinkVariant.screenBreak20 => 5,
          },
      closeSeconds: close < 1 ? 1 : close,
      squeezeSeconds: squeeze < 0 ? 0 : squeeze,
      openSeconds: open < 1 ? 1 : open,
      lookAwaySeconds: lookAway < 0 ? 0 : lookAway,
      setsPerDay: setsPerDay.clamp(1, 12),
      variant: variant,
      disclaimer: json['disclaimer'] == true,
    );
  }

  final int reps;
  final int closeSeconds;
  final int squeezeSeconds;
  final int openSeconds;
  final int lookAwaySeconds;
  final int setsPerDay;
  final BlinkVariant variant;
  final bool disclaimer;

  bool get hasMultipleSets => setsPerDay > 1;

  List<BlinkPhase> get cyclePhases {
    return [
      if (closeSeconds > 0) BlinkPhase.close,
      if (squeezeSeconds > 0) BlinkPhase.squeeze,
      if (openSeconds > 0) BlinkPhase.open,
    ];
  }

  int durationOf(BlinkPhase phase) {
    return switch (phase) {
      BlinkPhase.lookAway => lookAwaySeconds,
      BlinkPhase.close => closeSeconds,
      BlinkPhase.squeeze => squeezeSeconds,
      BlinkPhase.open => openSeconds,
    };
  }

  int get cycleSeconds {
    final total = closeSeconds + squeezeSeconds + openSeconds;
    return total <= 0 ? 1 : total;
  }

  int get totalSeconds => lookAwaySeconds + (reps * cycleSeconds);

  BlinkCycleConfig copyWith({int? reps, int? setsPerDay}) {
    return BlinkCycleConfig(
      reps: reps ?? this.reps,
      closeSeconds: closeSeconds,
      squeezeSeconds: squeezeSeconds,
      openSeconds: openSeconds,
      lookAwaySeconds: lookAwaySeconds,
      setsPerDay: setsPerDay ?? this.setsPerDay,
      variant: variant,
      disclaimer: disclaimer,
    );
  }
}

class BlinkCycleState {
  const BlinkCycleState({
    required this.phase,
    required this.cycleIndex,
    required this.secondsLeft,
    required this.completed,
    required this.inLookAway,
  });

  final BlinkPhase phase;
  final int cycleIndex;
  final int secondsLeft;
  final bool completed;
  final bool inLookAway;
}

class BlinkCycleEngine {
  BlinkCycleEngine(this.config)
    : assert(config.reps > 0, 'reps must be > 0'),
      _cyclePhases = config.cyclePhases,
      _inLookAway = config.lookAwaySeconds > 0,
      _secondsLeft = config.lookAwaySeconds > 0
          ? config.lookAwaySeconds
          : (config.cyclePhases.isEmpty
                ? 0
                : config.durationOf(config.cyclePhases.first)) {
    if (_cyclePhases.isEmpty && config.lookAwaySeconds <= 0) {
      _completed = true;
    }
  }

  final BlinkCycleConfig config;
  final List<BlinkPhase> _cyclePhases;
  int _cycleIndex = 1;
  int _phaseIndex = 0;
  bool _inLookAway;
  bool _completed = false;
  int _secondsLeft;

  BlinkCycleState get state {
    if (_completed) {
      return BlinkCycleState(
        phase: _cyclePhases.isEmpty ? BlinkPhase.open : _cyclePhases.last,
        cycleIndex: config.reps,
        secondsLeft: 0,
        completed: true,
        inLookAway: false,
      );
    }
    if (_inLookAway) {
      return BlinkCycleState(
        phase: BlinkPhase.lookAway,
        cycleIndex: 0,
        secondsLeft: _secondsLeft,
        completed: false,
        inLookAway: true,
      );
    }
    final phase = _cyclePhases[_phaseIndex];
    return BlinkCycleState(
      phase: phase,
      cycleIndex: _cycleIndex,
      secondsLeft: _secondsLeft,
      completed: false,
      inLookAway: false,
    );
  }

  BlinkCycleState tick() {
    if (_completed) {
      return state;
    }
    if (_secondsLeft > 1) {
      _secondsLeft -= 1;
      return state;
    }

    if (_inLookAway) {
      _inLookAway = false;
      if (_cyclePhases.isEmpty) {
        _completed = true;
        _secondsLeft = 0;
        return state;
      }
      _phaseIndex = 0;
      _cycleIndex = 1;
      _secondsLeft = config.durationOf(_cyclePhases.first);
      return state;
    }

    if (_phaseIndex < _cyclePhases.length - 1) {
      _phaseIndex += 1;
      _secondsLeft = config.durationOf(_cyclePhases[_phaseIndex]);
      return state;
    }
    if (_cycleIndex < config.reps) {
      _cycleIndex += 1;
      _phaseIndex = 0;
      _secondsLeft = config.durationOf(_cyclePhases.first);
      return state;
    }
    _completed = true;
    _secondsLeft = 0;
    return state;
  }
}
