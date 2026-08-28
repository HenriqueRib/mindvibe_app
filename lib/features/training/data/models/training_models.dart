import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';

ContentAccessInfo accessFromJson(Map<String, dynamic> json) {
  return ContentAccessInfo(
    isPremium: json['is_premium'] as bool? ?? false,
    contentAccess: json['content_access'] as bool? ?? true,
    requiredPlan: json['required_plan'] as String?,
  );
}

ProgramSummary programFromJson(Map<String, dynamic> json) {
  final category = json['category'];
  return ProgramSummary(
    id: json['id'] as int,
    slug: json['slug'] as String? ?? '',
    title: json['title'] as String? ?? '',
    description: json['description'] as String?,
    durationDays: json['duration_days'] as int? ?? 0,
    freeDays: json['free_days'] as int? ?? 0,
    estimatedMinutes: json['estimated_minutes'] as int?,
    userProgramId: json['user_program_id'] as int?,
    status: json['status'] as String?,
    currentDayNumber: json['current_day_number'] as int?,
    progressLabel: json['progress_label'] as String?,
    categoryName: category is Map ? category['name'] as String? : null,
    categorySlug: category is Map ? category['slug'] as String? : null,
    daysCompleted: json['days_completed'] as int?,
    coverUrl:
        json['cover_url'] as String? ??
        (category is Map ? category['cover_url'] as String? : null),
  );
}

ProgramDetail programDetailFromJson(Map<String, dynamic> json) {
  final days = json['days'];
  return ProgramDetail(
    summary: programFromJson(json),
    days: days is List
        ? days.whereType<Map>().map((item) {
            return ProgramDayPreview(
              dayNumber: item['day_number'] as int? ?? 0,
              title: item['title'] as String? ?? '',
              subtitle: item['subtitle'] as String?,
              estimatedMinutes: item['estimated_minutes'] as int? ?? 0,
              status: item['status'] as String?,
              availableOn: item['available_on'] as String?,
            );
          }).toList()
        : const [],
  );
}

ListenMoment momentFromJson(Map<String, dynamic> json) {
  return ListenMoment(
    id: json['id'] as int,
    categorySlug: json['category_slug'] as String? ?? '',
    categoryName: json['category_name'] as String? ?? '',
    categorySortOrder: json['category_sort_order'] as int? ?? 99,
    title: json['title'] as String? ?? '',
    durationSeconds: json['duration_seconds'] as int?,
    url: json['url'] as String?,
    coverUrl: json['cover_url'] as String?,
  );
}

SessionSummary sessionSummaryFromJson(Map<String, dynamic> json) {
  return SessionSummary(
    id: json['id'] as int,
    title: json['title'] as String? ?? '',
    estimatedMinutes: json['estimated_minutes'] as int? ?? 0,
    access: accessFromJson(json),
  );
}

AudioClip? audioFromJson(dynamic json) {
  if (json is! Map) {
    return null;
  }
  return AudioClip(
    id: json['id'] as int,
    title: json['title'] as String? ?? '',
    durationSeconds: json['duration_seconds'] as int?,
    url: json['url'] as String?,
    coverUrl: json['cover_url'] as String?,
  );
}

ExerciseSpec? exerciseFromJson(dynamic json) {
  if (json is! Map) {
    return null;
  }
  final configuration = json['configuration'];
  return ExerciseSpec(
    id: json['id'] as int,
    type: json['type'] as String? ?? '',
    title: json['title'] as String? ?? '',
    configuration: configuration is Map
        ? Map<String, dynamic>.from(configuration)
        : null,
    variant: json['variant'] as String?,
  );
}

AssessmentSpec? assessmentFromJson(dynamic json) {
  if (json is! Map) {
    return null;
  }
  final questions = json['questions'];
  return AssessmentSpec(
    id: json['id'] as int,
    title: json['title'] as String? ?? '',
    questions: questions is List
        ? questions.whereType<Map>().map((item) {
            final configuration = item['configuration'];
            return AssessmentQuestion(
              id: item['id'] as int,
              sortOrder: item['sort_order'] as int? ?? 0,
              type: item['type'] as String? ?? 'rating',
              prompt: item['prompt'] as String? ?? '',
              configuration: configuration is Map
                  ? Map<String, dynamic>.from(configuration)
                  : null,
            );
          }).toList()
        : const [],
  );
}

SessionBlock blockFromJson(Map<String, dynamic> json) {
  return SessionBlock(
    id: json['id'] as int,
    sortOrder: json['sort_order'] as int? ?? 0,
    type: json['type'] as String? ?? '',
    access: accessFromJson(json),
    body: json['body'] as String?,
    audio: audioFromJson(json['audio']),
    exercise: exerciseFromJson(json['exercise']),
    assessment: assessmentFromJson(json['assessment']),
  );
}

TrainingSessionDetail sessionDetailFromJson(Map<String, dynamic> json) {
  final nested = json['session'];
  final source = nested is Map<String, dynamic> ? nested : json;
  final blocks = source['blocks'];
  return TrainingSessionDetail(
    id: source['id'] as int,
    title: source['title'] as String? ?? '',
    estimatedMinutes: source['estimated_minutes'] as int? ?? 0,
    access: accessFromJson(source),
    userProgramId: json['user_program_id'] as int?,
    dayNumber: json['day_number'] as int?,
    userSessionId: json['user_session_id'] as int?,
    coverUrl: source['cover_url'] as String? ?? json['cover_url'] as String?,
    blocks: blocks is List
        ? blocks
              .whereType<Map>()
              .map((item) => blockFromJson(Map<String, dynamic>.from(item)))
              .toList()
        : const [],
  );
}

TodayTraining todayFromJson(Map<String, dynamic> json) {
  final program = programFromJson(json['program'] as Map<String, dynamic>);
  final day = json['day'] as Map<String, dynamic>? ?? const {};
  final xp = json['xp'];
  final level = json['level'];
  final sessions = day['sessions'];
  final planned = json['days'];
  return TodayTraining(
    greetingName: json['greeting_name'] as String? ?? '',
    program: program,
    dayTitle: day['title'] as String? ?? program.title,
    daySubtitle: day['subtitle'] as String?,
    dayNumber: day['day_number'] as int? ?? program.currentDayNumber ?? 1,
    estimatedMinutes:
        day['estimated_minutes'] as int? ?? program.estimatedMinutes ?? 0,
    access: accessFromJson(day),
    streakDays: json['streak_days'] as int? ?? 0,
    xp: xp is Map ? (xp['total'] as int? ?? 0) : (xp as int? ?? 0),
    levelLabel: level is Map ? level['name'] as String? : null,
    todayCompleted: json['today_completed'] as bool? ?? false,
    cadence: json['cadence'] as String? ?? 'daily',
    nextDayNumber: json['next_day_number'] as int?,
    nextDayTitle: json['next_day_title'] as String?,
    nextAvailableOn: json['next_available_on'] as String?,
    sessions: sessions is List
        ? sessions
              .whereType<Map>()
              .map(
                (item) =>
                    sessionSummaryFromJson(Map<String, dynamic>.from(item)),
              )
              .toList()
        : const [],
    days: planned is List
        ? planned.whereType<Map>().map((item) {
            return ProgramDayPreview(
              dayNumber: item['day_number'] as int? ?? 0,
              title: item['title'] as String? ?? '',
              subtitle: item['subtitle'] as String?,
              estimatedMinutes: item['estimated_minutes'] as int? ?? 0,
              status: item['status'] as String?,
              availableOn: item['available_on'] as String?,
            );
          }).toList()
        : const [],
  );
}

Enrollment enrollmentFromJson(Map<String, dynamic> json) {
  return Enrollment(
    id: json['id'] as int,
    programId: json['program_id'] as int,
    status: json['status'] as String? ?? 'active',
    currentDayNumber: json['current_day_number'] as int? ?? 1,
  );
}

SessionCompletion completionFromJson(Map<String, dynamic> json) {
  final level = json['level'];
  return SessionCompletion(
    userSessionId: json['user_session_id'] as int? ?? 0,
    idempotent: json['idempotent'] as bool? ?? false,
    currentDayNumber: json['current_day_number'] as int? ?? 1,
    programStatus: json['program_status'] as String? ?? 'active',
    xpAwarded: json['xp_awarded'] as int? ?? 0,
    xpTotal: json['xp_total'] as int? ?? 0,
    streakDays: json['streak_days'] as int? ?? 0,
    levelName: level is Map ? level['name'] as String? : null,
  );
}

ProgressSnapshot progressFromJson(Map<String, dynamic> json) {
  final program = json['program'];
  final focus = json['perceived_focus'];
  final level = json['level'];
  final nextLevel = json['next_level'];
  return ProgressSnapshot(
    xp: json['xp'] is int ? json['xp'] as int : 0,
    levelName: level is Map ? level['name'] as String? : null,
    levelMinXp: level is Map ? level['min_xp'] as int? : null,
    nextLevelName: nextLevel is Map ? nextLevel['name'] as String? : null,
    nextLevelMinXp: nextLevel is Map ? nextLevel['min_xp'] as int? : null,
    streakDays: json['streak_days'] as int? ?? 0,
    minutesTrained: json['minutes_trained'] as int? ?? 0,
    minutesListened: json['minutes_listened'] as int? ?? 0,
    minutesTotal: json['minutes_total'] as int?,
    secondsListened: json['seconds_listened'] as int? ?? 0,
    secondsTotal: json['seconds_total'] as int?,
    sessionsCompleted: json['sessions_completed'] as int? ?? 0,
    program: program is Map
        ? programFromJson(Map<String, dynamic>.from(program))
        : null,
    perceivedFocusCopy: focus is Map ? focus['copy'] as String? : null,
    weekDays: weekDaysFromJson(json['days']),
    checkin: checkinSnapshotFromJson(json['checkin']),
    todayFocus: dailyFocusFromJson(json['today_focus']),
  );
}

List<WeekDayTime> weekDaysFromJson(Object? raw) {
  if (raw is! List) {
    return const [];
  }
  return raw
      .whereType<Map>()
      .map((item) {
        final map = Map<String, dynamic>.from(item);
        final date = _civilDate(map['date'] as String?);
        if (date == null) {
          return null;
        }
        final seconds = map['seconds'];
        final minutes = map['minutes_trained'];
        return WeekDayTime(
          date: date,
          seconds: seconds is int
              ? seconds
              : minutes is int
              ? minutes * 60
              : 0,
        );
      })
      .whereType<WeekDayTime>()
      .toList();
}

DateTime? _civilDate(String? value) {
  if (value == null || value.length < 10) {
    return null;
  }
  final parts = value.substring(0, 10).split('-');
  if (parts.length != 3) {
    return null;
  }
  final year = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final day = int.tryParse(parts[2]);
  if (year == null || month == null || day == null) {
    return null;
  }
  return DateTime(year, month, day);
}

CheckinSnapshot checkinSnapshotFromJson(Object? raw) {
  if (raw is! Map) {
    return const CheckinSnapshot();
  }
  final map = Map<String, dynamic>.from(raw);
  final today = _dayCheckinFromJson(map['today']);
  return CheckinSnapshot(
    today: today?.recorded == true ? today : null,
    days: checkinDaysFromJson(map['days']),
  );
}

List<DayCheckin> checkinDaysFromJson(Object? raw) {
  if (raw is! List) {
    return const [];
  }
  return raw
      .whereType<Map>()
      .map((item) => _dayCheckinFromJson(Map<String, dynamic>.from(item)))
      .whereType<DayCheckin>()
      .toList();
}

DayCheckin? _dayCheckinFromJson(Object? raw) {
  if (raw is! Map) {
    return null;
  }
  final map = Map<String, dynamic>.from(raw);
  final date = _civilDate(map['date'] as String?);
  if (date == null) {
    return null;
  }
  return DayCheckin(
    date: date,
    mood: _jsonIntOrNull(map['mood']),
    energy: _jsonIntOrNull(map['energy']),
  );
}

JournalSnapshot journalSnapshotFromJson(Object? raw) {
  if (raw is! Map) {
    return const JournalSnapshot();
  }
  final map = Map<String, dynamic>.from(raw);
  return JournalSnapshot(
    today: _journalEntryFromJson(map['today']),
    days: _journalDaysFromJson(map['days']),
  );
}

List<JournalDay> _journalDaysFromJson(Object? raw) {
  if (raw is! List) {
    return const [];
  }
  return raw
      .whereType<Map>()
      .map((item) {
        final map = Map<String, dynamic>.from(item);
        final date = _civilDate(map['date'] as String?);
        if (date == null) {
          return null;
        }
        return JournalDay(
          date: date,
          prompt: journalPromptFrom(map['prompt'] as String?),
        );
      })
      .whereType<JournalDay>()
      .toList();
}

JournalEntry? _journalEntryFromJson(Object? raw) {
  if (raw is! Map) {
    return null;
  }
  final map = Map<String, dynamic>.from(raw);
  final date = _civilDate(map['date'] as String?);
  final prompt = journalPromptFrom(map['prompt'] as String?);
  if (date == null || prompt == null) {
    return null;
  }
  final lines = map['lines'];
  return JournalEntry(
    date: date,
    prompt: prompt,
    lines: [
      for (var index = 0; index < 3; index++)
        lines is List && index < lines.length && lines[index] is String
            ? lines[index] as String
            : '',
    ],
  );
}

DailyFocus? dailyFocusFromJson(Object? raw) {
  if (raw is! Map) {
    return null;
  }
  final map = Map<String, dynamic>.from(raw);
  final body = map['body'] as String?;
  if (body == null || body.isEmpty) {
    return null;
  }
  return DailyFocus(
    body: body,
    parkedCount: _jsonInt(map['parked_count']),
    dumpedCount: _jsonInt(map['dumped_count'], 1),
    date: map['date'] as String?,
  );
}

ClearMindResult? clearMindResultFromJson(Object? raw) {
  if (raw is! Map) {
    return null;
  }
  final map = Map<String, dynamic>.from(raw);
  final today = dailyFocusFromJson(map['today']);
  if (today == null) {
    return null;
  }
  return ClearMindResult(
    today: today,
    lot: thoughtLotFromJson(map['lot']),
    parkedCount: _jsonInt(map['parked_count']),
  );
}

ThoughtLot thoughtLotFromJson(Object? raw) {
  if (raw is! Map) {
    return const ThoughtLot();
  }
  final map = Map<String, dynamic>.from(raw);
  final items = map['items'];
  return ThoughtLot(
    items: items is List
        ? items
              .whereType<Map>()
              .map(
                (item) =>
                    _parkedThoughtFromJson(Map<String, dynamic>.from(item)),
              )
              .whereType<ParkedThought>()
              .toList()
        : const [],
    openCount: _jsonInt(map['open_count']),
    openLimit: _jsonInt(map['open_limit'], 20),
  );
}

ParkedThought? _parkedThoughtFromJson(Map<String, dynamic> map) {
  final id = _jsonIntOrNull(map['id']);
  final body = map['body'] as String?;
  if (id == null || body == null || body.isEmpty) {
    return null;
  }
  final parked = map['parked_at'] as String?;
  return ParkedThought(
    id: id,
    body: body,
    parkedAt: parked == null
        ? DateTime.now()
        : DateTime.tryParse(parked) ?? DateTime.now(),
  );
}

DayCloseSnapshot dayCloseSnapshotFromJson(Object? raw) {
  if (raw is! Map) {
    return const DayCloseSnapshot();
  }
  final map = Map<String, dynamic>.from(raw);
  ListenMoment? audio;
  final audioRaw = map['audio'];
  if (audioRaw is Map) {
    final audioMap = Map<String, dynamic>.from(audioRaw);
    final id = _jsonIntOrNull(audioMap['id']);
    if (id != null) {
      audio = momentFromJson({
        ...audioMap,
        'id': id,
        'duration_seconds': _jsonIntOrNull(audioMap['duration_seconds']),
      });
    }
  }
  return DayCloseSnapshot(
    today: _dayCloseEntryFromJson(map['today']),
    days: _dayCloseDaysFromJson(map['days']),
    audio: audio,
  );
}

List<DayCloseDay> _dayCloseDaysFromJson(Object? raw) {
  if (raw is! List) {
    return const [];
  }
  return raw
      .whereType<Map>()
      .map((item) {
        final map = Map<String, dynamic>.from(item);
        final date = _civilDate(map['date'] as String?);
        if (date == null) {
          return null;
        }
        return DayCloseDay(date: date, closed: map['closed'] == true);
      })
      .whereType<DayCloseDay>()
      .toList();
}

DayCloseEntry? _dayCloseEntryFromJson(Object? raw) {
  if (raw is! Map) {
    return null;
  }
  final map = Map<String, dynamic>.from(raw);
  final date = _civilDate(map['date'] as String?);
  if (date == null) {
    return null;
  }
  return DayCloseEntry(
    date: date,
    kept: map['kept'] as String? ?? '',
    released: map['released'] as String? ?? '',
  );
}

ActivityItem activityFromJson(Map<String, dynamic> json) {
  final occurred = json['occurred_at'] as String?;
  final meta = json['meta'];
  return ActivityItem(
    id: json['id'] as int? ?? 0,
    type: json['type'] as String? ?? '',
    title: json['title'] as String? ?? '',
    occurredAt: occurred == null
        ? DateTime.now()
        : DateTime.tryParse(occurred) ?? DateTime.now(),
    meta: meta is Map
        ? Map<String, dynamic>.from(meta)
        : const <String, dynamic>{},
  );
}

WorldRanking rankingFromJson(Map<String, dynamic> json) {
  final me = json['me'];
  final entries = json['entries'];
  return WorldRanking(
    optedIn: json['opted_in'] as bool? ?? false,
    period: json['period'] as String? ?? 'all',
    totalPlayers: _jsonInt(json['total_players']),
    me: me is Map ? rankingPersonFromJson(Map<String, dynamic>.from(me)) : null,
    entries: entries is List
        ? entries
              .whereType<Map>()
              .map(
                (item) => rankingEntryFromJson(Map<String, dynamic>.from(item)),
              )
              .toList()
        : const [],
  );
}

RankingPerson rankingPersonFromJson(Map<String, dynamic> json) {
  final level = json['level'];
  return RankingPerson(
    rank: _jsonIntOrNull(json['rank']),
    displayName: json['display_name'] as String? ?? '',
    avatarUrl: json['avatar_url'] as String?,
    avatarEmoji: json['avatar_emoji'] as String?,
    xp: _jsonInt(json['xp']),
    levelName: level is Map ? level['name'] as String? : null,
    streakDays: _jsonInt(json['streak_days']),
    seconds: _jsonInt(json['seconds']),
  );
}

RankingEntry rankingEntryFromJson(Map<String, dynamic> json) {
  final person = rankingPersonFromJson(json);
  return RankingEntry(
    rank: person.rank,
    displayName: person.displayName,
    avatarUrl: person.avatarUrl,
    avatarEmoji: person.avatarEmoji,
    xp: person.xp,
    levelName: person.levelName,
    streakDays: person.streakDays,
    seconds: person.seconds,
    isMe: json['is_me'] as bool? ?? false,
  );
}

int _jsonInt(Object? value, [int fallback = 0]) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.round();
  }
  if (value is String) {
    return int.tryParse(value) ?? fallback;
  }
  return fallback;
}

int? _jsonIntOrNull(Object? value) {
  if (value == null) {
    return null;
  }
  return _jsonInt(value);
}
