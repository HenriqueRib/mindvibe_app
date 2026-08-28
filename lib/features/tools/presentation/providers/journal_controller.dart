import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindvibe_app/core/error/app_failure.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';

class JournalUiState {
  const JournalUiState({
    this.prompt = JournalPrompt.intention,
    this.snapshot = const JournalSnapshot(),
    this.loading = true,
    this.saving = false,
    this.saved = false,
    this.failure,
  });

  final JournalPrompt prompt;
  final JournalSnapshot snapshot;
  final bool loading;
  final bool saving;
  final bool saved;
  final AppFailure? failure;

  JournalUiState copyWith({
    JournalPrompt? prompt,
    JournalSnapshot? snapshot,
    bool? loading,
    bool? saving,
    bool? saved,
    AppFailure? failure,
    bool clearFailure = false,
  }) {
    return JournalUiState(
      prompt: prompt ?? this.prompt,
      snapshot: snapshot ?? this.snapshot,
      loading: loading ?? this.loading,
      saving: saving ?? this.saving,
      saved: saved ?? this.saved,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}

class JournalController extends StateNotifier<JournalUiState> {
  JournalController(this._ref) : super(const JournalUiState());

  final Ref _ref;

  Future<void> load() async {
    final result = await _ref.read(trainingRepositoryProvider).journal();
    result.when(
      success: (snapshot) {
        if (!mounted) {
          return;
        }
        state = JournalUiState(
          prompt: snapshot.today?.prompt ?? JournalPrompt.intention,
          snapshot: snapshot,
          loading: false,
          saved: snapshot.today != null,
        );
      },
      failure: (error) {
        if (!mounted) {
          return;
        }
        state = JournalUiState(loading: false, failure: error);
      },
    );
  }

  void setPrompt(JournalPrompt prompt) {
    state = state.copyWith(prompt: prompt, saved: false, clearFailure: true);
  }

  Future<void> save(List<String> lines) async {
    if (state.saving) {
      return;
    }
    state = state.copyWith(saving: true, clearFailure: true);
    final result = await _ref
        .read(trainingRepositoryProvider)
        .recordJournal(prompt: state.prompt, lines: lines);
    result.when(
      success: (snapshot) {
        if (!mounted) {
          return;
        }
        state = state.copyWith(
          snapshot: snapshot,
          prompt: snapshot.today?.prompt ?? state.prompt,
          saving: false,
          saved: true,
        );
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

final journalControllerProvider =
    StateNotifierProvider.autoDispose<JournalController, JournalUiState>((ref) {
      final controller = JournalController(ref);
      controller.load();
      return controller;
    });
