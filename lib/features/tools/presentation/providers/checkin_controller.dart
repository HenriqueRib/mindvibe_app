import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindvibe_app/core/error/app_failure.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';

class CheckinUiState {
  const CheckinUiState({
    this.mood,
    this.energy,
    this.snapshot = const CheckinSnapshot(),
    this.loading = true,
    this.saving = false,
    this.saved = false,
    this.failure,
  });

  final int? mood;
  final int? energy;
  final CheckinSnapshot snapshot;
  final bool loading;
  final bool saving;
  final bool saved;
  final AppFailure? failure;

  bool get ready => mood != null && energy != null;

  CheckinUiState copyWith({
    int? mood,
    int? energy,
    CheckinSnapshot? snapshot,
    bool? loading,
    bool? saving,
    bool? saved,
    AppFailure? failure,
    bool clearFailure = false,
  }) {
    return CheckinUiState(
      mood: mood ?? this.mood,
      energy: energy ?? this.energy,
      snapshot: snapshot ?? this.snapshot,
      loading: loading ?? this.loading,
      saving: saving ?? this.saving,
      saved: saved ?? this.saved,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}

class CheckinController extends StateNotifier<CheckinUiState> {
  CheckinController(this._ref) : super(const CheckinUiState());

  final Ref _ref;

  Future<void> load() async {
    final result = await _ref.read(trainingRepositoryProvider).checkins();
    result.when(
      success: (snapshot) {
        if (!mounted) {
          return;
        }
        state = CheckinUiState(
          mood: snapshot.today?.mood,
          energy: snapshot.today?.energy,
          snapshot: snapshot,
          loading: false,
          saved: snapshot.today != null,
        );
      },
      failure: (error) {
        if (!mounted) {
          return;
        }
        state = CheckinUiState(loading: false, failure: error);
      },
    );
  }

  Future<void> setMood(int mood) {
    state = state.copyWith(mood: mood, saved: false, clearFailure: true);
    return _saveIfReady();
  }

  Future<void> setEnergy(int energy) {
    state = state.copyWith(energy: energy, saved: false, clearFailure: true);
    return _saveIfReady();
  }

  Future<void> _saveIfReady() async {
    final mood = state.mood;
    final energy = state.energy;
    if (mood == null || energy == null || state.saving) {
      return;
    }

    final today = state.snapshot.today;
    if (today != null && today.mood == mood && today.energy == energy) {
      state = state.copyWith(saved: true);
      return;
    }

    state = state.copyWith(saving: true, clearFailure: true);
    final result = await _ref
        .read(trainingRepositoryProvider)
        .recordCheckin(mood: mood, energy: energy);
    result.when(
      success: (snapshot) {
        if (!mounted) {
          return;
        }
        state = state.copyWith(
          snapshot: snapshot,
          mood: snapshot.today?.mood ?? mood,
          energy: snapshot.today?.energy ?? energy,
          saving: false,
          saved: true,
        );
        _ref.invalidate(progressProvider);
        _ref.invalidate(weeklyReportProvider);
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

final checkinControllerProvider =
    StateNotifierProvider.autoDispose<CheckinController, CheckinUiState>((ref) {
      final controller = CheckinController(ref);
      controller.load();
      return controller;
    });
