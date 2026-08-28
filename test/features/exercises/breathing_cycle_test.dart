import 'package:flutter_test/flutter_test.dart';
import 'package:mindvibe_app/features/exercises/domain/breathing_cycle.dart';

void main() {
  test('avança inspirar, segurar e expirar e completa os ciclos', () {
    final engine = BreathingCycleEngine(
      const BreathingCycleConfig(
        inspiration: 2,
        hold: 1,
        expiration: 2,
        rest: 0,
        cycles: 2,
      ),
    );

    expect(engine.state.phase, BreathingPhase.inspiration);
    expect(engine.state.secondsLeft, 2);
    expect(engine.state.cycleIndex, 1);

    engine.tick();
    expect(engine.state.phase, BreathingPhase.inspiration);
    expect(engine.state.secondsLeft, 1);

    engine.tick();
    expect(engine.state.phase, BreathingPhase.hold);
    expect(engine.state.secondsLeft, 1);

    engine.tick();
    expect(engine.state.phase, BreathingPhase.expiration);

    engine.tick();
    engine.tick();
    expect(engine.state.cycleIndex, 2);
    expect(engine.state.phase, BreathingPhase.inspiration);
    expect(engine.state.completed, isFalse);

    engine.tick();
    engine.tick();
    engine.tick();
    engine.tick();
    engine.tick();
    expect(engine.state.completed, isTrue);
  });

  test('ignora fases com duração zero', () {
    final engine = BreathingCycleEngine(
      const BreathingCycleConfig(
        inspiration: 1,
        hold: 0,
        expiration: 1,
        rest: 0,
        cycles: 1,
      ),
    );

    expect(engine.state.phase, BreathingPhase.inspiration);
    engine.tick();
    expect(engine.state.phase, BreathingPhase.expiration);
    engine.tick();
    expect(engine.state.completed, isTrue);
  });

  test('infere caixa, 4-7-8 e maré pelos tempos', () {
    expect(
      BreathingCycleConfig.fromJson({
        'inspiration': 4,
        'hold': 4,
        'expiration': 4,
        'rest': 4,
        'cycles': 1,
      }).variant,
      BreathingVariant.box,
    );
    expect(
      BreathingCycleConfig.fromJson({
        'inspiration': 4,
        'hold': 7,
        'expiration': 8,
        'cycles': 1,
      }).variant,
      BreathingVariant.ladder,
    );
    expect(
      BreathingCycleConfig.fromJson({
        'inspiration': 4,
        'hold': 0,
        'expiration': 8,
        'cycles': 1,
      }).variant,
      BreathingVariant.tide,
    );
    expect(
      BreathingCycleConfig.fromJson({
        'variant': 'wave',
        'inspiration': 4,
        'hold': 0,
        'expiration': 8,
        'cycles': 1,
      }).variant,
      BreathingVariant.wave,
    );
  });
}
