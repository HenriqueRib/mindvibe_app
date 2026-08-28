import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindvibe_app/core/providers/core_providers.dart';
import 'package:mindvibe_app/features/training/data/repositories/training_repository_impl.dart';
import 'package:mindvibe_app/features/training/domain/repositories/training_repository.dart';

final trainingRepositoryProvider = Provider<TrainingRepository>((ref) {
  return TrainingRepositoryImpl(ref.watch(apiClientProvider));
});

final todayProvider = FutureProvider.autoDispose((ref) async {
  final pending = await ref.read(pendingSessionStoreProvider).read();
  if (pending != null) {
    final complete = await ref
        .read(trainingRepositoryProvider)
        .completeSession(pending);
    if (complete.isSuccess) {
      await ref.read(pendingSessionStoreProvider).clear();
    }
  }
  return ref.watch(trainingRepositoryProvider).today();
});

final progressProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(trainingRepositoryProvider).progress();
});

final weeklyReportProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(trainingRepositoryProvider).weeklyReport();
});

final catalogProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(trainingRepositoryProvider).listPrograms();
});

final momentsProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(trainingRepositoryProvider).listMoments();
});

final libraryExercisesProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(trainingRepositoryProvider).listExercises();
});

final historyProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(trainingRepositoryProvider).history();
});

final rankingProvider = FutureProvider.autoDispose.family((ref, String period) {
  return ref.watch(trainingRepositoryProvider).ranking(period: period);
});

final programDetailProvider = FutureProvider.autoDispose.family((ref, int id) {
  return ref.watch(trainingRepositoryProvider).getProgram(id);
});
