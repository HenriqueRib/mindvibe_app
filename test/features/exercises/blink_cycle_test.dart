import 'package:flutter_test/flutter_test.dart';
import 'package:mindvibe_app/features/exercises/domain/blink_cycle.dart';

void main() {
  test('close squeeze open avança fases e completa reps', () {
    final engine = BlinkCycleEngine(
      const BlinkCycleConfig(
        reps: 2,
        closeSeconds: 2,
        squeezeSeconds: 1,
        openSeconds: 2,
      ),
    );

    expect(engine.state.phase, BlinkPhase.close);
    expect(engine.state.secondsLeft, 2);
    expect(engine.state.cycleIndex, 1);

    engine.tick();
    expect(engine.state.phase, BlinkPhase.close);
    expect(engine.state.secondsLeft, 1);

    engine.tick();
    expect(engine.state.phase, BlinkPhase.squeeze);

    engine.tick();
    expect(engine.state.phase, BlinkPhase.open);

    engine.tick();
    engine.tick();
    expect(engine.state.cycleIndex, 2);
    expect(engine.state.phase, BlinkPhase.close);
    expect(engine.state.completed, isFalse);

    engine.tick();
    engine.tick();
    engine.tick();
    engine.tick();
    engine.tick();
    expect(engine.state.completed, isTrue);
  });

  test('ignora squeeze zero em complete blinks', () {
    final engine = BlinkCycleEngine(
      const BlinkCycleConfig(
        reps: 1,
        closeSeconds: 1,
        squeezeSeconds: 0,
        openSeconds: 1,
        variant: BlinkVariant.completeBlinks,
      ),
    );

    expect(engine.state.phase, BlinkPhase.close);
    engine.tick();
    expect(engine.state.phase, BlinkPhase.open);
    engine.tick();
    expect(engine.state.completed, isTrue);
  });

  test('screen break começa com look away e depois pisca', () {
    final config = BlinkCycleConfig.fromJson({
      'variant': 'screen_break_20',
      'reps': 2,
      'duration_seconds': 2,
      'phase_seconds': {'close': 1, 'squeeze': 0, 'open': 1},
    });
    expect(config.variant, BlinkVariant.screenBreak20);
    expect(config.lookAwaySeconds, 2);

    final engine = BlinkCycleEngine(config);
    expect(engine.state.inLookAway, isTrue);
    expect(engine.state.phase, BlinkPhase.lookAway);

    engine.tick();
    engine.tick();
    expect(engine.state.inLookAway, isFalse);
    expect(engine.state.phase, BlinkPhase.close);
    expect(engine.state.cycleIndex, 1);
  });

  test('fromJson lê close_squeeze_open com defaults', () {
    final config = BlinkCycleConfig.fromJson({
      'variant': 'close_squeeze_open',
      'reps': 15,
      'phase_seconds': {'close': 2, 'squeeze': 2, 'open': 2},
      'disclaimer': true,
    });
    expect(config.variant, BlinkVariant.closeSqueezeOpen);
    expect(config.reps, 15);
    expect(config.setsPerDay, 3);
    expect(config.hasMultipleSets, isTrue);
    expect(config.disclaimer, isTrue);
    expect(config.cycleSeconds, 6);
    expect(config.totalSeconds, 90);
  });

  test('sets_per_day zero em micro vira 1 set', () {
    final config = BlinkCycleConfig.fromJson({
      'variant': 'complete_blinks',
      'reps': 8,
      'sets_per_day': 0,
    });
    expect(config.setsPerDay, 1);
    expect(config.hasMultipleSets, isFalse);
  });
}
