import 'package:flutter_test/flutter_test.dart';
import 'package:mindvibe_app/features/progress/domain/progress_milestones.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';

ProgressSnapshot _snap({
  int xp = 0,
  int streakDays = 0,
  int minutesTrained = 0,
  int sessionsCompleted = 0,
  int? nextLevelMinXp,
  String? nextLevelName,
}) {
  return ProgressSnapshot(
    xp: xp,
    streakDays: streakDays,
    minutesTrained: minutesTrained,
    sessionsCompleted: sessionsCompleted,
    nextLevelMinXp: nextLevelMinXp,
    nextLevelName: nextLevelName,
  );
}

void main() {
  test('check-in keeps the user out of the empty progress state', () {
    final snapshot = ProgressSnapshot(
      xp: 0,
      streakDays: 0,
      minutesTrained: 0,
      sessionsCompleted: 0,
      checkin: CheckinSnapshot(
        today: DayCheckin(date: DateTime(2026, 8, 20), mood: 3, energy: 2),
      ),
    );
    expect(snapshot.isFreshStart, isFalse);
    expect(snapshot.hasCheckin, isTrue);
  });

  test('fresh user aims at the first session', () {
    final milestone = resolveProgressMilestone(_snap());
    expect(milestone.kind, ProgressMilestoneKind.firstSession);
  });

  test('early streak aims at three days', () {
    final milestone = resolveProgressMilestone(
      _snap(sessionsCompleted: 1, minutesTrained: 10, streakDays: 1),
    );
    expect(milestone.kind, ProgressMilestoneKind.streak);
    expect(milestone.target, 3);
    expect(milestone.remaining, 2);
  });

  test('after streak three, next level XP is the target', () {
    final milestone = resolveProgressMilestone(
      _snap(
        sessionsCompleted: 4,
        minutesTrained: 40,
        streakDays: 3,
        xp: 40,
        nextLevelMinXp: 100,
        nextLevelName: 'Focado',
      ),
    );
    expect(milestone.kind, ProgressMilestoneKind.level);
    expect(milestone.remaining, 60);
  });
}
