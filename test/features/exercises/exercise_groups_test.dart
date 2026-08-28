import 'package:flutter_test/flutter_test.dart';
import 'package:mindvibe_app/features/exercises/domain/exercise_groups.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';

void main() {
  test('agrupa exercícios por tipo na ordem da academia', () {
    const items = [
      ExerciseSpec(id: 1, type: 'memory', title: 'Palavras'),
      ExerciseSpec(id: 2, type: 'breathing', title: 'Box'),
      ExerciseSpec(id: 3, type: 'attention', title: 'Alvo'),
      ExerciseSpec(id: 4, type: 'breathing', title: '4-7-8'),
    ];

    final groups = groupExercisesByType(items);

    expect(groups.map((group) => group.type).toList(), [
      'breathing',
      'attention',
      'memory',
    ]);
    expect(groups.first.items.map((item) => item.title), ['Box', '4-7-8']);
  });

  test('ordena respiração por variante', () {
    const items = [
      ExerciseSpec(id: 1, type: 'breathing', title: 'Maré', variant: 'tide'),
      ExerciseSpec(id: 2, type: 'breathing', title: 'Caixa', variant: 'box'),
      ExerciseSpec(id: 3, type: 'breathing', title: 'Círculo', variant: 'wave'),
    ];

    expect(
      sortedBreathingExercises(items).map((item) => item.title).toList(),
      ['Círculo', 'Caixa', 'Maré'],
    );
  });
}
