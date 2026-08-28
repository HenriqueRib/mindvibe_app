import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/core/providers/core_providers.dart';
import 'package:mindvibe_app/core/storage/home_layout_store.dart';
import 'package:mindvibe_app/features/auth/domain/entities/auth_entities.dart';
import 'package:mindvibe_app/features/auth/presentation/providers/session_controller.dart';
import 'package:mindvibe_app/features/home/presentation/home_actions.dart';
import 'package:mindvibe_app/features/home/presentation/widgets/home_layout_progress.dart';
import 'package:mindvibe_app/features/home/presentation/widgets/home_layout_today.dart';
import 'package:mindvibe_app/features/home/presentation/widgets/home_layout_training.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final layout = ref.watch(homeLayoutProvider);
    final today = ref.watch(todayProvider);
    final catalog = ref.watch(catalogProvider);
    final progressAsync = ref.watch(progressProvider);
    final session = ref.watch(sessionControllerProvider);
    final pausedSessionId = ref
        .watch(pausedTrainingProvider)
        .maybeWhen(data: (paused) => paused?.sessionId, orElse: () => null);
    final name = session.user?.name ?? '';
    final programs = catalog.maybeWhen(
      data: (result) => result.valueOrNull ?? const <ProgramSummary>[],
      orElse: () => const <ProgramSummary>[],
    );
    final progress = progressAsync.maybeWhen(
      data: (result) => result.valueOrNull,
      orElse: () => null,
    );

    return today.when(
      loading: () => AppScaffold(body: AppLoading(label: l10n.loadingLabel)),
      error: (error, _) => AppScaffold(
        body: AppError(
          message: l10n.errorGeneric,
          retryLabel: l10n.actionRetry,
          onRetry: () => ref.invalidate(todayProvider),
        ),
      ),
      data: (result) {
        return result.when(
          failure: (failure) {
            if (failure.isNoActiveProgram) {
              return _layout(
                context: context,
                l10n: l10n,
                layout: layout,
                name: name,
                user: session.user,
                training: null,
                progress: progress,
                programs: programs,
                pausedSessionId: pausedSessionId,
                onStart: () => context.push(AppRoutes.choosePlan),
              );
            }
            return AppScaffold(
              body: AppError(
                message: failureMessage(failure, l10n),
                retryLabel: l10n.actionRetry,
                onRetry: () => ref.invalidate(todayProvider),
              ),
            );
          },
          success: (training) {
            return _layout(
              context: context,
              l10n: l10n,
              layout: layout,
              name: training.greetingName.isEmpty
                  ? name
                  : training.greetingName,
              user: session.user,
              training: training,
              progress: progress,
              programs: programs,
              pausedSessionId: pausedSessionId,
              onStart: () => startTodayTraining(context, l10n, training),
            );
          },
        );
      },
    );
  }

  Widget _layout({
    required BuildContext context,
    required AppLocalizations l10n,
    required HomeLayoutKind layout,
    required String name,
    required List<ProgramSummary> programs,
    required VoidCallback onStart,
    required UserAccount? user,
    TodayTraining? training,
    ProgressSnapshot? progress,
    int? pausedSessionId,
  }) {
    return switch (layout) {
      HomeLayoutKind.today => HomeTodayLayout(
        l10n: l10n,
        name: name,
        user: user,
        training: training,
        progress: progress,
        programs: programs,
        onStart: onStart,
      ),
      HomeLayoutKind.training => HomeTrainingLayout(
        l10n: l10n,
        name: name,
        user: user,
        training: training,
        progress: progress,
        programs: programs,
        pausedSessionId: pausedSessionId,
        onStart: onStart,
      ),
      HomeLayoutKind.progress => HomeProgressLayout(
        l10n: l10n,
        name: name,
        user: user,
        training: training,
        progress: progress,
        programs: programs,
        pausedSessionId: pausedSessionId,
        onStart: onStart,
      ),
    };
  }
}
