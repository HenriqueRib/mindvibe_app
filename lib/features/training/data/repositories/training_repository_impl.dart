import 'package:mindvibe_app/core/error/result.dart';
import 'package:mindvibe_app/core/network/api_client.dart';
import 'package:mindvibe_app/features/training/data/models/training_models.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/features/training/domain/repositories/training_repository.dart';

class TrainingRepositoryImpl implements TrainingRepository {
  TrainingRepositoryImpl(this._client);

  final ApiClient _client;

  @override
  Future<Result<List<ProgramSummary>>> listPrograms() {
    return _client.get(
      '/programs',
      parse: (data) {
        final list = data as List<dynamic>;
        return list
            .map((item) => programFromJson(item as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<Result<ProgramDetail>> getProgram(int id) {
    return _client.get(
      '/programs/$id',
      parse: (data) => programDetailFromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<List<ListenMoment>>> listMoments() {
    return _client.get(
      '/library/moments',
      parse: (data) {
        final list = data as List<dynamic>;
        return list
            .map((item) => momentFromJson(item as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<Result<List<ExerciseSpec>>> listExercises() {
    return _client.get(
      '/library/exercises',
      parse: (data) {
        final list = data as List<dynamic>;
        return list
            .map((item) => exerciseFromJson(item as Map<String, dynamic>))
            .whereType<ExerciseSpec>()
            .toList();
      },
    );
  }

  @override
  Future<Result<Enrollment>> enroll(int programId, {bool replace = false}) {
    return _client.post(
      '/programs/$programId/enroll',
      body: {'replace': replace},
      parse: (data) => enrollmentFromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<void>> updateCadence({
    required int userProgramId,
    required String cadence,
  }) {
    return _client.put(
      '/user-programs/$userProgramId/cadence',
      body: {'cadence': cadence},
      parse: (_) {},
    );
  }

  @override
  Future<Result<TodayTraining>> today() {
    return _client.get(
      '/me/today',
      parse: (data) => todayFromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<TrainingSessionDetail>> startSession(int sessionId) {
    return _client.post(
      '/sessions/$sessionId/start',
      parse: (data) => sessionDetailFromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<SessionCompletion>> completeSession(int sessionId) {
    return _client.post(
      '/sessions/$sessionId/complete',
      parse: (data) => completionFromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<void>> submitExerciseResult({
    required int exerciseId,
    required int? userSessionId,
    required Map<String, dynamic> payload,
  }) {
    return _client.post(
      '/exercises/$exerciseId/results',
      body: {'payload': payload, 'user_session_id': ?userSessionId},
      parse: (_) {},
    );
  }

  @override
  Future<Result<void>> submitAssessment({
    required int assessmentId,
    required int? userSessionId,
    required List<Map<String, dynamic>> answers,
  }) {
    return _client.post(
      '/assessments/$assessmentId/submit',
      body: {'answers': answers, 'user_session_id': ?userSessionId},
      parse: (_) {},
    );
  }

  @override
  Future<Result<ProgressSnapshot>> progress() {
    return _client.get(
      '/progress',
      parse: (data) => progressFromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<ProgressSnapshot>> weeklyReport() {
    return _client.get(
      '/reports/weekly',
      parse: (data) => progressFromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<List<ActivityItem>>> history() {
    return _client.get(
      '/progress/history',
      parse: (data) {
        final map = data as Map<String, dynamic>;
        final items = map['items'];
        if (items is! List) {
          return const <ActivityItem>[];
        }
        return items
            .whereType<Map>()
            .map((item) => activityFromJson(Map<String, dynamic>.from(item)))
            .toList();
      },
    );
  }

  @override
  Future<Result<void>> recordActivity({
    required String type,
    required String clientEventId,
    required int durationSeconds,
    Map<String, dynamic>? meta,
  }) {
    return _client.post(
      '/activity/events',
      body: {
        'type': type,
        'client_event_id': clientEventId,
        'duration_seconds': durationSeconds,
        'meta': ?meta,
      },
      parse: (_) {},
    );
  }

  @override
  Future<Result<void>> recordListen({
    required int seconds,
    required String clientEventId,
    int? audioId,
  }) {
    return _client.post(
      '/library/listens',
      body: {
        'seconds': seconds,
        'client_event_id': clientEventId,
        'source': 'library',
        'audio_id': ?audioId,
      },
      parse: (_) {},
    );
  }

  @override
  Future<Result<WorldRanking>> ranking({String period = 'all'}) {
    return _client.get(
      '/ranking',
      query: {'period': period},
      parse: (data) => rankingFromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<CheckinSnapshot>> checkins() {
    return _client.get(
      '/checkins',
      parse: (data) => checkinSnapshotFromJson(data),
    );
  }

  @override
  Future<Result<CheckinSnapshot>> recordCheckin({
    required int mood,
    required int energy,
  }) {
    return _client.post(
      '/checkins',
      body: {'mood': mood, 'energy': energy},
      parse: (data) => checkinSnapshotFromJson(data),
    );
  }

  @override
  Future<Result<JournalSnapshot>> journal() {
    return _client.get(
      '/journals',
      parse: (data) => journalSnapshotFromJson(data),
    );
  }

  @override
  Future<Result<JournalSnapshot>> recordJournal({
    required JournalPrompt prompt,
    required List<String> lines,
  }) {
    return _client.post(
      '/journals',
      body: {'prompt': prompt.name, 'lines': lines},
      parse: (data) => journalSnapshotFromJson(data),
    );
  }

  @override
  Future<Result<ThoughtLot>> thoughts() {
    return _client.get('/thoughts', parse: (data) => thoughtLotFromJson(data));
  }

  @override
  Future<Result<ThoughtLot>> parkThought({required String body}) {
    return _client.post(
      '/thoughts',
      body: {'body': body},
      parse: (data) => thoughtLotFromJson(data),
    );
  }

  @override
  Future<Result<ThoughtLot>> releaseThought(int id) {
    return _client.post(
      '/thoughts/$id/release',
      parse: (data) => thoughtLotFromJson(data),
    );
  }

  @override
  Future<Result<DailyFocus?>> dailyFocus() {
    return _client.get(
      '/clear-mind',
      parse: (data) {
        if (data is! Map) {
          return null;
        }
        return dailyFocusFromJson(
          Map<String, dynamic>.from(data)['today'],
        );
      },
    );
  }

  @override
  Future<Result<ClearMindResult>> recordClearMind({
    required List<String> items,
    required int focusIndex,
    int pauseSeconds = 0,
  }) {
    return _client.post(
      '/clear-mind',
      body: {
        'items': items,
        'focus_index': focusIndex,
        'pause_seconds': pauseSeconds,
      },
      parse: (data) {
        final result = clearMindResultFromJson(data);
        if (result == null) {
          throw const FormatException('clear-mind');
        }
        return result;
      },
    );
  }

  @override
  Future<Result<DayCloseSnapshot>> dayClose() {
    return _client.get(
      '/day-closes',
      parse: (data) => dayCloseSnapshotFromJson(data),
    );
  }

  @override
  Future<Result<DayCloseSnapshot>> recordDayClose({
    required String kept,
    required String released,
  }) {
    return _client.post(
      '/day-closes',
      body: {'kept': kept, 'released': released},
      parse: (data) => dayCloseSnapshotFromJson(data),
    );
  }
}
