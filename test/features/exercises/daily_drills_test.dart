import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mindvibe_app/features/exercises/domain/daily_drills.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';

void main() {
  test('saturated days invert the 15-minute circuit', () {
    expect(circuitVariants(saturated: true), ['senses', 'sort', 'silence']);
    expect(circuitVariants(saturated: false, now: DateTime(2026, 8, 20)), [
      'countdown',
      'reverse',
      'uses',
    ]);
    expect(circuitVariants(saturated: false, now: DateTime(2026, 8, 21)), [
      'observe',
      'categories',
      'uses',
    ]);
  });

  test('low mood or a today focus counts as saturated', () {
    expect(progressLooksSaturated(mood: 2), isTrue);
    expect(progressLooksSaturated(energy: 1), isTrue);
    expect(progressLooksSaturated(hasTodayFocus: true), isTrue);
    expect(progressLooksSaturated(mood: 4, energy: 4), isFalse);
  });

  test('pickCircuit keeps the three daily rooms in order', () {
    final library = [
      const ExerciseSpec(id: 1, type: 'daily', title: 'A', variant: 'uses'),
      const ExerciseSpec(id: 2, type: 'daily', title: 'B', variant: 'senses'),
      const ExerciseSpec(id: 3, type: 'memory', title: 'C', variant: 'words'),
      const ExerciseSpec(id: 4, type: 'daily', title: 'D', variant: 'sort'),
      const ExerciseSpec(id: 5, type: 'daily', title: 'E', variant: 'silence'),
    ];
    final steps = pickCircuit(library, saturated: true);
    expect(steps.map((item) => item.variant).toList(), [
      'senses',
      'sort',
      'silence',
    ]);
  });

  test('reverse rounds keep five unique items', () {
    final round = randomReverseRound(random: Random(7));
    expect(round.items, hasLength(5));
    expect(round.items.toSet(), hasLength(5));
    expect(round.expected, round.items.reversed.toList());
  });

  test('countdown choices include the next number', () {
    final choices = countdownChoices(100, random: Random(3));
    expect(choices, contains(97));
    expect(choices, hasLength(3));
    expect(choices.toSet(), hasLength(3));
  });

  test('reasoning drills stay blocked until the person actually plays', () {
    expect(isDailyTypedAnswer('  '), isFalse);
    expect(isDailyTypedAnswer('a'), isFalse);
    expect(isDailyTypedAnswer('cão'), isTrue);

    expect(dailyRetellFilled('ok'), 0);
    expect(dailyRetellFilled('O pássaro voou da janela.'), 1);

    expect(
      dailyCanComplete(variant: DailyVariant.categories, filled: 0),
      isFalse,
    );
    expect(
      dailyCanComplete(variant: DailyVariant.categories, filled: 5),
      isTrue,
    );
    expect(dailyCanComplete(variant: DailyVariant.uses, filled: 2), isFalse);
    expect(dailyCanComplete(variant: DailyVariant.uses, filled: 5), isTrue);
    expect(dailyCanComplete(variant: DailyVariant.senses, filled: 0), isFalse);
    expect(dailyCanComplete(variant: DailyVariant.senses, filled: 1), isTrue);
    expect(dailyCanComplete(variant: DailyVariant.retell, filled: 0), isFalse);
    expect(dailyCanComplete(variant: DailyVariant.sort, filled: 0), isFalse);
    expect(
      dailyCanComplete(variant: DailyVariant.countdown, correct: 0),
      isFalse,
    );
    expect(
      dailyCanComplete(variant: DailyVariant.countdown, correct: 5),
      isTrue,
    );
    expect(dailyCanComplete(variant: DailyVariant.observe), isTrue);
    expect(dailyCanComplete(variant: DailyVariant.silence), isTrue);
  });
}
