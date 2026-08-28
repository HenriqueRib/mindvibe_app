import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';

enum ProgressMilestoneKind { firstSession, streak, level, minutes }

class ProgressMilestone {
  const ProgressMilestone({
    required this.kind,
    required this.current,
    required this.target,
    this.levelName,
  });

  final ProgressMilestoneKind kind;
  final int current;
  final int target;
  final String? levelName;

  double get ratio {
    if (target <= 0) {
      return 0;
    }
    return (current / target).clamp(0.0, 1.0);
  }

  int get remaining {
    final left = target - current;
    return left < 0 ? 0 : left;
  }
}

ProgressMilestone resolveProgressMilestone(ProgressSnapshot snapshot) {
  if (snapshot.sessionsCompleted == 0 && snapshot.totalSeconds < 60) {
    return const ProgressMilestone(
      kind: ProgressMilestoneKind.firstSession,
      current: 0,
      target: 1,
    );
  }

  if (snapshot.streakDays < 3) {
    return ProgressMilestone(
      kind: ProgressMilestoneKind.streak,
      current: snapshot.streakDays,
      target: 3,
    );
  }

  final nextXp = snapshot.nextLevelMinXp;
  if (nextXp != null && nextXp > snapshot.xp) {
    return ProgressMilestone(
      kind: ProgressMilestoneKind.level,
      current: snapshot.xp,
      target: nextXp,
      levelName: snapshot.nextLevelName,
    );
  }

  if (snapshot.streakDays < 7) {
    return ProgressMilestone(
      kind: ProgressMilestoneKind.streak,
      current: snapshot.streakDays,
      target: 7,
    );
  }

  const steps = [10, 30, 60, 180, 420];
  final minutes = snapshot.totalSeconds ~/ 60;
  for (final step in steps) {
    if (minutes < step) {
      return ProgressMilestone(
        kind: ProgressMilestoneKind.minutes,
        current: minutes,
        target: step,
      );
    }
  }

  if (snapshot.streakDays < 14) {
    return ProgressMilestone(
      kind: ProgressMilestoneKind.streak,
      current: snapshot.streakDays,
      target: 14,
    );
  }

  return ProgressMilestone(
    kind: ProgressMilestoneKind.minutes,
    current: minutes,
    target: minutes,
  );
}

int previousWeekSeconds(List<ActivityItem> items, {DateTime? now}) {
  final current = now ?? DateTime.now();
  final today = DateTime(current.year, current.month, current.day);
  final start = today.subtract(const Duration(days: 13));
  final end = today.subtract(const Duration(days: 6));
  var total = 0;
  for (final item in items) {
    final local = item.occurredAt.toLocal();
    final day = DateTime(local.year, local.month, local.day);
    if (!day.isBefore(start) && day.isBefore(end)) {
      total += item.seconds;
    }
  }
  return total;
}

int trainedDaysThisWeek(List<WeekDayTime> days) {
  return days.where((day) => day.seconds > 0).length;
}
