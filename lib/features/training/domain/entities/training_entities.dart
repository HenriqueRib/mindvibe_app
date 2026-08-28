class ContentAccessInfo {
  const ContentAccessInfo({
    required this.isPremium,
    required this.contentAccess,
    this.requiredPlan,
  });

  final bool isPremium;
  final bool contentAccess;
  final String? requiredPlan;
}

class ProgramSummary {
  const ProgramSummary({
    required this.id,
    required this.slug,
    required this.title,
    required this.durationDays,
    required this.freeDays,
    this.description,
    this.estimatedMinutes,
    this.userProgramId,
    this.status,
    this.currentDayNumber,
    this.progressLabel,
    this.categoryName,
    this.categorySlug,
    this.daysCompleted,
    this.coverUrl,
  });

  final int id;
  final String slug;
  final String title;
  final String? description;
  final int durationDays;
  final int freeDays;
  final int? estimatedMinutes;
  final int? userProgramId;
  final String? status;
  final int? currentDayNumber;
  final String? progressLabel;
  final String? categoryName;
  final String? categorySlug;
  final int? daysCompleted;
  final String? coverUrl;
}

class ProgramDayPreview {
  const ProgramDayPreview({
    required this.dayNumber,
    required this.title,
    required this.estimatedMinutes,
    this.subtitle,
    this.status,
    this.availableOn,
  });

  final int dayNumber;
  final String title;
  final String? subtitle;
  final int estimatedMinutes;
  final String? status;
  final String? availableOn;
}

class ProgramDetail {
  const ProgramDetail({required this.summary, required this.days});

  final ProgramSummary summary;
  final List<ProgramDayPreview> days;
}

class ListenMoment {
  const ListenMoment({
    required this.id,
    required this.categorySlug,
    required this.categoryName,
    required this.title,
    this.durationSeconds,
    this.url,
    this.coverUrl,
    this.categorySortOrder = 99,
  });

  final int id;
  final String categorySlug;
  final String categoryName;
  final int categorySortOrder;
  final String title;
  final int? durationSeconds;
  final String? url;
  final String? coverUrl;
}

class SessionSummary {
  const SessionSummary({
    required this.id,
    required this.title,
    required this.estimatedMinutes,
    required this.access,
  });

  final int id;
  final String title;
  final int estimatedMinutes;
  final ContentAccessInfo access;
}

class AudioClip {
  const AudioClip({
    required this.id,
    required this.title,
    this.durationSeconds,
    this.url,
    this.coverUrl,
  });

  final int id;
  final String title;
  final int? durationSeconds;
  final String? url;
  final String? coverUrl;
}

class ExerciseSpec {
  const ExerciseSpec({
    required this.id,
    required this.type,
    required this.title,
    this.configuration,
    this.variant,
  });

  final int id;
  final String type;
  final String title;
  final Map<String, dynamic>? configuration;
  final String? variant;
}

class AssessmentQuestion {
  const AssessmentQuestion({
    required this.id,
    required this.sortOrder,
    required this.type,
    required this.prompt,
    this.configuration,
  });

  final int id;
  final int sortOrder;
  final String type;
  final String prompt;
  final Map<String, dynamic>? configuration;
}

class AssessmentSpec {
  const AssessmentSpec({
    required this.id,
    required this.title,
    required this.questions,
  });

  final int id;
  final String title;
  final List<AssessmentQuestion> questions;
}

class SessionBlock {
  const SessionBlock({
    required this.id,
    required this.sortOrder,
    required this.type,
    required this.access,
    this.body,
    this.audio,
    this.exercise,
    this.assessment,
  });

  final int id;
  final int sortOrder;
  final String type;
  final ContentAccessInfo access;
  final String? body;
  final AudioClip? audio;
  final ExerciseSpec? exercise;
  final AssessmentSpec? assessment;
}

class TrainingSessionDetail {
  const TrainingSessionDetail({
    required this.id,
    required this.title,
    required this.estimatedMinutes,
    required this.access,
    required this.blocks,
    this.userProgramId,
    this.dayNumber,
    this.userSessionId,
    this.coverUrl,
  });

  final int id;
  final String title;
  final int estimatedMinutes;
  final ContentAccessInfo access;
  final List<SessionBlock> blocks;
  final int? userProgramId;
  final int? dayNumber;
  final int? userSessionId;
  final String? coverUrl;
}

class SessionCompletion {
  const SessionCompletion({
    required this.userSessionId,
    required this.idempotent,
    required this.currentDayNumber,
    required this.programStatus,
    required this.xpAwarded,
    required this.xpTotal,
    required this.streakDays,
    this.levelName,
    this.perceivedFocusCopy,
  });

  final int userSessionId;
  final bool idempotent;
  final int currentDayNumber;
  final String programStatus;
  final int xpAwarded;
  final int xpTotal;
  final int streakDays;
  final String? levelName;
  final String? perceivedFocusCopy;
}

class TodayTraining {
  const TodayTraining({
    required this.greetingName,
    required this.program,
    required this.dayTitle,
    required this.dayNumber,
    required this.estimatedMinutes,
    required this.access,
    required this.streakDays,
    required this.xp,
    required this.sessions,
    this.levelLabel,
    this.daySubtitle,
    this.todayCompleted = false,
    this.cadence = 'daily',
    this.nextDayNumber,
    this.nextDayTitle,
    this.nextAvailableOn,
    this.days = const [],
  });

  final String greetingName;
  final ProgramSummary program;
  final String dayTitle;
  final String? daySubtitle;
  final int dayNumber;
  final int estimatedMinutes;
  final ContentAccessInfo access;
  final int streakDays;
  final int xp;
  final String? levelLabel;
  final List<SessionSummary> sessions;
  final bool todayCompleted;
  final String cadence;
  final int? nextDayNumber;
  final String? nextDayTitle;
  final String? nextAvailableOn;
  final List<ProgramDayPreview> days;
}

class Enrollment {
  const Enrollment({
    required this.id,
    required this.programId,
    required this.status,
    required this.currentDayNumber,
  });

  final int id;
  final int programId;
  final String status;
  final int currentDayNumber;
}

class ProgressSnapshot {
  const ProgressSnapshot({
    required this.xp,
    required this.streakDays,
    required this.minutesTrained,
    required this.sessionsCompleted,
    this.minutesListened = 0,
    this.minutesTotal,
    this.secondsListened = 0,
    this.secondsTotal,
    this.levelName,
    this.levelMinXp,
    this.nextLevelName,
    this.nextLevelMinXp,
    this.program,
    this.perceivedFocusCopy,
    this.weekDays = const [],
    this.checkin = const CheckinSnapshot(),
    this.todayFocus,
  });

  final int xp;
  final String? levelName;
  final int? levelMinXp;
  final String? nextLevelName;
  final int? nextLevelMinXp;
  final int streakDays;
  final int minutesTrained;
  final int minutesListened;
  final int? minutesTotal;
  final int secondsListened;
  final int? secondsTotal;
  final int sessionsCompleted;
  final ProgramSummary? program;
  final String? perceivedFocusCopy;
  final List<WeekDayTime> weekDays;
  final CheckinSnapshot checkin;
  final DailyFocus? todayFocus;

  int get totalSeconds =>
      secondsTotal ??
      ((minutesTotal ?? (minutesTrained + minutesListened)) * 60);

  bool get hasCheckin =>
      checkin.today != null || checkin.days.any((day) => day.recorded);

  bool get isFreshStart =>
      sessionsCompleted == 0 &&
      totalSeconds < 60 &&
      xp == 0 &&
      streakDays == 0 &&
      !hasCheckin;
}

class WeekDayTime {
  const WeekDayTime({required this.date, required this.seconds});

  final DateTime date;
  final int seconds;

  bool isToday([DateTime? now]) {
    final current = now ?? DateTime.now();
    return date.year == current.year &&
        date.month == current.month &&
        date.day == current.day;
  }
}

class DayCheckin {
  const DayCheckin({required this.date, this.mood, this.energy});

  final DateTime date;
  final int? mood;
  final int? energy;

  bool get recorded => mood != null && energy != null;

  int? get weightLevel {
    if (!recorded) {
      return null;
    }
    return ((mood! + energy!) / 2).round().clamp(1, 5);
  }
}

class CheckinSnapshot {
  const CheckinSnapshot({this.today, this.days = const []});

  final DayCheckin? today;
  final List<DayCheckin> days;
}

enum JournalPrompt { intention, unload, gratitude }

JournalPrompt? journalPromptFrom(String? raw) {
  return switch (raw) {
    'intention' => JournalPrompt.intention,
    'unload' => JournalPrompt.unload,
    'gratitude' => JournalPrompt.gratitude,
    _ => null,
  };
}

class JournalDay {
  const JournalDay({required this.date, this.prompt});

  final DateTime date;
  final JournalPrompt? prompt;

  bool get written => prompt != null;
}

class JournalEntry {
  const JournalEntry({
    required this.date,
    required this.prompt,
    required this.lines,
  });

  final DateTime date;
  final JournalPrompt prompt;
  final List<String> lines;
}

class JournalSnapshot {
  const JournalSnapshot({this.today, this.days = const []});

  final JournalEntry? today;
  final List<JournalDay> days;
}

class DailyFocus {
  const DailyFocus({
    required this.body,
    this.parkedCount = 0,
    this.dumpedCount = 1,
    this.date,
  });

  final String body;
  final int parkedCount;
  final int dumpedCount;
  final String? date;
}

class ClearMindResult {
  const ClearMindResult({
    required this.today,
    this.lot = const ThoughtLot(),
    this.parkedCount = 0,
  });

  final DailyFocus today;
  final ThoughtLot lot;
  final int parkedCount;
}

class ParkedThought {
  const ParkedThought({
    required this.id,
    required this.body,
    required this.parkedAt,
  });

  final int id;
  final String body;
  final DateTime parkedAt;
}

class ThoughtLot {
  const ThoughtLot({
    this.items = const [],
    this.openCount = 0,
    this.openLimit = 20,
  });

  final List<ParkedThought> items;
  final int openCount;
  final int openLimit;

  bool get isFull => openCount >= openLimit;
}

class DayCloseDay {
  const DayCloseDay({required this.date, this.closed = false});

  final DateTime date;
  final bool closed;
}

class DayCloseEntry {
  const DayCloseEntry({
    required this.date,
    required this.kept,
    required this.released,
  });

  final DateTime date;
  final String kept;
  final String released;
}

class DayCloseSnapshot {
  const DayCloseSnapshot({this.today, this.days = const [], this.audio});

  final DayCloseEntry? today;
  final List<DayCloseDay> days;
  final ListenMoment? audio;
}

class ActivityItem {
  const ActivityItem({
    required this.id,
    required this.type,
    required this.title,
    required this.occurredAt,
    this.meta = const {},
  });

  final int id;
  final String type;
  final String title;
  final DateTime occurredAt;
  final Map<String, dynamic> meta;

  String? get exerciseType {
    final value = meta['exercise_type'];
    return value is String ? value : null;
  }

  int get seconds {
    int? number(Object? value) {
      if (value is int) {
        return value;
      }
      if (value is num) {
        return value.round();
      }
      return null;
    }

    final direct = number(meta['seconds']) ?? number(meta['duration_seconds']);
    if (direct != null) {
      return direct < 0 ? 0 : direct;
    }
    final millis = number(meta['duration_ms']);
    if (millis != null) {
      return millis <= 0 ? 0 : millis ~/ 1000;
    }
    final minutes =
        number(meta['focus_minutes']) ?? number(meta['estimated_minutes']);
    if (minutes != null) {
      return minutes < 0 ? 0 : minutes * 60;
    }
    return 0;
  }

  int? get mood => _metaInt('mood');

  int? get energy => _metaInt('energy');

  String? get prompt {
    final value = meta['prompt'];
    return value is String ? value : null;
  }

  int? _metaInt(String key) {
    final value = meta[key];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.round();
    }
    return null;
  }
}

class WorldRanking {
  const WorldRanking({
    required this.optedIn,
    required this.period,
    required this.totalPlayers,
    this.me,
    this.entries = const [],
  });

  final bool optedIn;
  final String period;
  final int totalPlayers;
  final RankingPerson? me;
  final List<RankingEntry> entries;
}

class RankingPerson {
  const RankingPerson({
    required this.displayName,
    required this.xp,
    required this.streakDays,
    this.rank,
    this.avatarUrl,
    this.avatarEmoji,
    this.levelName,
    this.seconds = 0,
  });

  final int? rank;
  final String displayName;
  final String? avatarUrl;
  final String? avatarEmoji;
  final int xp;
  final String? levelName;
  final int streakDays;
  final int seconds;
}

class RankingEntry extends RankingPerson {
  const RankingEntry({
    required super.displayName,
    required super.xp,
    required super.streakDays,
    required this.isMe,
    super.rank,
    super.avatarUrl,
    super.avatarEmoji,
    super.levelName,
    super.seconds,
  });

  final bool isMe;
}
