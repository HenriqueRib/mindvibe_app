import 'package:mindvibe_app/core/error/result.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';

abstract class TrainingRepository {
  Future<Result<List<ProgramSummary>>> listPrograms();
  Future<Result<ProgramDetail>> getProgram(int id);
  Future<Result<List<ListenMoment>>> listMoments();
  Future<Result<List<ExerciseSpec>>> listExercises();
  Future<Result<Enrollment>> enroll(int programId, {bool replace = false});
  Future<Result<void>> updateCadence({
    required int userProgramId,
    required String cadence,
  });
  Future<Result<TodayTraining>> today();
  Future<Result<TrainingSessionDetail>> startSession(int sessionId);
  Future<Result<SessionCompletion>> completeSession(int sessionId);
  Future<Result<void>> submitExerciseResult({
    required int exerciseId,
    required int? userSessionId,
    required Map<String, dynamic> payload,
  });
  Future<Result<void>> submitAssessment({
    required int assessmentId,
    required int? userSessionId,
    required List<Map<String, dynamic>> answers,
  });
  Future<Result<ProgressSnapshot>> progress();
  Future<Result<ProgressSnapshot>> weeklyReport();
  Future<Result<List<ActivityItem>>> history();
  Future<Result<void>> recordActivity({
    required String type,
    required String clientEventId,
    required int durationSeconds,
    Map<String, dynamic>? meta,
  });
  Future<Result<void>> recordListen({
    required int seconds,
    required String clientEventId,
    int? audioId,
  });
  Future<Result<WorldRanking>> ranking({String period = 'all'});
  Future<Result<CheckinSnapshot>> checkins();
  Future<Result<CheckinSnapshot>> recordCheckin({
    required int mood,
    required int energy,
  });
  Future<Result<JournalSnapshot>> journal();
  Future<Result<JournalSnapshot>> recordJournal({
    required JournalPrompt prompt,
    required List<String> lines,
  });
  Future<Result<ThoughtLot>> thoughts();
  Future<Result<ThoughtLot>> parkThought({required String body});
  Future<Result<ThoughtLot>> releaseThought(int id);
  Future<Result<DailyFocus?>> dailyFocus();
  Future<Result<ClearMindResult>> recordClearMind({
    required List<String> items,
    required int focusIndex,
    int pauseSeconds = 0,
  });
  Future<Result<DayCloseSnapshot>> dayClose();
  Future<Result<DayCloseSnapshot>> recordDayClose({
    required String kept,
    required String released,
  });
}
