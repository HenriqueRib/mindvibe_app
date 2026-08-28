import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindvibe_app/core/error/app_failure.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';

class DayCloseUiState {
  const DayCloseUiState({
    this.snapshot = const DayCloseSnapshot(),
    this.loading = true,
    this.saving = false,
    this.saved = false,
    this.failure,
  });

  final DayCloseSnapshot snapshot;
  final bool loading;
  final bool saving;
  final bool saved;
  final AppFailure? failure;

  DayCloseUiState copyWith({
    DayCloseSnapshot? snapshot,
    bool? loading,
    bool? saving,
    bool? saved,
    AppFailure? failure,
    bool clearFailure = false,
  }) {
    return DayCloseUiState(
      snapshot: snapshot ?? this.snapshot,
      loading: loading ?? this.loading,
      saving: saving ?? this.saving,
      saved: saved ?? this.saved,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}

class DayCloseController extends StateNotifier<DayCloseUiState> {
  DayCloseController(this._ref) : super(const DayCloseUiState());

  final Ref _ref;

  Future<void> load() async {
    final result = await _ref.read(trainingRepositoryProvider).dayClose();
    result.when(
      success: (snapshot) {
        if (!mounted) {
          return;
        }
        state = DayCloseUiState(
          snapshot: snapshot,
          loading: false,
          saved: snapshot.today != null,
        );
      },
      failure: (error) {
        if (!mounted) {
          return;
        }
        state = DayCloseUiState(loading: false, failure: error);
      },
    );
  }

  Future<void> save({required String kept, required String released}) async {
    if (state.saving) {
      return;
    }
    state = state.copyWith(saving: true, clearFailure: true);
    final result = await _ref
        .read(trainingRepositoryProvider)
        .recordDayClose(kept: kept, released: released);
    result.when(
      success: (snapshot) {
        if (!mounted) {
          return;
        }
        state = state.copyWith(snapshot: snapshot, saving: false, saved: true);
        _ref.invalidate(historyProvider);
      },
      failure: (error) {
        if (!mounted) {
          return;
        }
        state = state.copyWith(saving: false, failure: error);
      },
    );
  }
}

final dayCloseControllerProvider =
    StateNotifierProvider.autoDispose<DayCloseController, DayCloseUiState>((
      ref,
    ) {
      final controller = DayCloseController(ref);
      controller.load();
      return controller;
    });
