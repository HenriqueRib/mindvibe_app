import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindvibe_app/core/error/app_failure.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';

class ThoughtUiState {
  const ThoughtUiState({
    this.lot = const ThoughtLot(),
    this.loading = true,
    this.saving = false,
    this.releasingId,
    this.justParked = false,
    this.failure,
  });

  final ThoughtLot lot;
  final bool loading;
  final bool saving;
  final int? releasingId;
  final bool justParked;
  final AppFailure? failure;

  ThoughtUiState copyWith({
    ThoughtLot? lot,
    bool? loading,
    bool? saving,
    int? releasingId,
    bool? justParked,
    AppFailure? failure,
    bool clearReleasing = false,
    bool clearFailure = false,
  }) {
    return ThoughtUiState(
      lot: lot ?? this.lot,
      loading: loading ?? this.loading,
      saving: saving ?? this.saving,
      releasingId: clearReleasing ? null : (releasingId ?? this.releasingId),
      justParked: justParked ?? this.justParked,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}

class ThoughtController extends StateNotifier<ThoughtUiState> {
  ThoughtController(this._ref) : super(const ThoughtUiState());

  final Ref _ref;

  Future<void> load() async {
    final result = await _ref.read(trainingRepositoryProvider).thoughts();
    result.when(
      success: (lot) {
        if (!mounted) {
          return;
        }
        state = ThoughtUiState(lot: lot, loading: false);
      },
      failure: (error) {
        if (!mounted) {
          return;
        }
        state = ThoughtUiState(loading: false, failure: error);
      },
    );
  }

  void clearJustParked() {
    if (state.justParked) {
      state = state.copyWith(justParked: false);
    }
  }

  Future<bool> park(String body) async {
    if (state.saving) {
      return false;
    }
    state = state.copyWith(saving: true, justParked: false, clearFailure: true);
    final result = await _ref
        .read(trainingRepositoryProvider)
        .parkThought(body: body);
    return result.when(
      success: (lot) {
        if (!mounted) {
          return false;
        }
        state = state.copyWith(lot: lot, saving: false, justParked: true);
        _ref.invalidate(historyProvider);
        return true;
      },
      failure: (error) {
        if (!mounted) {
          return false;
        }
        state = state.copyWith(saving: false, failure: error);
        return false;
      },
    );
  }

  Future<void> release(int id) async {
    if (state.releasingId != null) {
      return;
    }
    state = state.copyWith(
      releasingId: id,
      justParked: false,
      clearFailure: true,
    );
    final result = await _ref
        .read(trainingRepositoryProvider)
        .releaseThought(id);
    result.when(
      success: (lot) {
        if (!mounted) {
          return;
        }
        state = state.copyWith(lot: lot, clearReleasing: true);
      },
      failure: (error) {
        if (!mounted) {
          return;
        }
        state = state.copyWith(failure: error, clearReleasing: true);
      },
    );
  }
}

final thoughtControllerProvider =
    StateNotifierProvider.autoDispose<ThoughtController, ThoughtUiState>((ref) {
      final controller = ThoughtController(ref);
      controller.load();
      return controller;
    });
