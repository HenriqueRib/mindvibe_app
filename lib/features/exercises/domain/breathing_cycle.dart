enum BreathingPhase { inspiration, hold, expiration, rest }

enum BreathingVariant { wave, box, ladder, tide }

BreathingVariant breathingVariantFrom(
  String? raw, {
  int inspiration = 4,
  int hold = 2,
  int expiration = 6,
  int rest = 0,
}) {
  return switch ((raw ?? '').toLowerCase()) {
    'box' || 'square' || 'caixa' => BreathingVariant.box,
    'ladder' || '478' || '4-7-8' || 'fourseveneight' => BreathingVariant.ladder,
    'tide' || 'ocean' || 'long' || 'exhale' => BreathingVariant.tide,
    'wave' || 'circle' || 'guided' => BreathingVariant.wave,
    _ => inferBreathingVariant(
      inspiration: inspiration,
      hold: hold,
      expiration: expiration,
      rest: rest,
    ),
  };
}

BreathingVariant inferBreathingVariant({
  required int inspiration,
  required int hold,
  required int expiration,
  required int rest,
}) {
  if (rest > 0 && hold > 0) {
    return BreathingVariant.box;
  }
  if (hold >= 6 ||
      (hold > 0 && hold >= inspiration && expiration >= inspiration + 3)) {
    return BreathingVariant.ladder;
  }
  if (hold == 0 && expiration > inspiration) {
    return BreathingVariant.tide;
  }
  return BreathingVariant.wave;
}

class BreathingCycleConfig {
  const BreathingCycleConfig({
    required this.inspiration,
    required this.hold,
    required this.expiration,
    this.rest = 0,
    required this.cycles,
    this.variant = BreathingVariant.wave,
  });

  factory BreathingCycleConfig.fromJson(Map<String, dynamic> json) {
    final inspiration = (json['inspiration'] as num?)?.toInt() ?? 0;
    final hold = (json['hold'] as num?)?.toInt() ?? 0;
    final expiration = (json['expiration'] as num?)?.toInt() ?? 0;
    final rest = (json['rest'] as num?)?.toInt() ?? 0;
    return BreathingCycleConfig(
      inspiration: inspiration,
      hold: hold,
      expiration: expiration,
      rest: rest,
      cycles: (json['cycles'] as num?)?.toInt() ?? 1,
      variant: breathingVariantFrom(
        json['variant'] as String?,
        inspiration: inspiration,
        hold: hold,
        expiration: expiration,
        rest: rest,
      ),
    );
  }

  final int inspiration;
  final int hold;
  final int expiration;
  final int rest;
  final int cycles;
  final BreathingVariant variant;

  List<BreathingPhase> get activePhases {
    return [
      if (inspiration > 0) BreathingPhase.inspiration,
      if (hold > 0) BreathingPhase.hold,
      if (expiration > 0) BreathingPhase.expiration,
      if (rest > 0) BreathingPhase.rest,
    ];
  }

  int durationOf(BreathingPhase phase) {
    return switch (phase) {
      BreathingPhase.inspiration => inspiration,
      BreathingPhase.hold => hold,
      BreathingPhase.expiration => expiration,
      BreathingPhase.rest => rest,
    };
  }

  int get cycleSeconds {
    final total = inspiration + hold + expiration + rest;
    return total <= 0 ? 1 : total;
  }

  BreathingCycleConfig copyWith({int? cycles, BreathingVariant? variant}) {
    return BreathingCycleConfig(
      inspiration: inspiration,
      hold: hold,
      expiration: expiration,
      rest: rest,
      cycles: cycles ?? this.cycles,
      variant: variant ?? this.variant,
    );
  }
}

class BreathingCycleState {
  const BreathingCycleState({
    required this.phase,
    required this.cycleIndex,
    required this.secondsLeft,
    required this.completed,
  });

  final BreathingPhase phase;
  final int cycleIndex;
  final int secondsLeft;
  final bool completed;
}

class BreathingCycleEngine {
  BreathingCycleEngine(this.config)
    : assert(config.cycles > 0, 'cycles must be > 0'),
      _phases = config.activePhases {
    if (_phases.isEmpty) {
      _completed = true;
    }
  }

  final BreathingCycleConfig config;
  final List<BreathingPhase> _phases;
  int _cycleIndex = 1;
  int _phaseIndex = 0;
  bool _completed = false;

  BreathingCycleState get state {
    if (_completed || _phases.isEmpty) {
      return BreathingCycleState(
        phase: _phases.isEmpty ? BreathingPhase.inspiration : _phases.last,
        cycleIndex: config.cycles,
        secondsLeft: 0,
        completed: true,
      );
    }
    final phase = _phases[_phaseIndex];
    return BreathingCycleState(
      phase: phase,
      cycleIndex: _cycleIndex,
      secondsLeft: _secondsLeft,
      completed: false,
    );
  }

  late int _secondsLeft = _phases.isEmpty
      ? 0
      : config.durationOf(_phases.first);

  BreathingCycleState tick() {
    if (_completed || _phases.isEmpty) {
      return state;
    }
    if (_secondsLeft > 1) {
      _secondsLeft -= 1;
      return state;
    }
    if (_phaseIndex < _phases.length - 1) {
      _phaseIndex += 1;
      _secondsLeft = config.durationOf(_phases[_phaseIndex]);
      return state;
    }
    if (_cycleIndex < config.cycles) {
      _cycleIndex += 1;
      _phaseIndex = 0;
      _secondsLeft = config.durationOf(_phases.first);
      return state;
    }
    _completed = true;
    _secondsLeft = 0;
    return state;
  }
}
