import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/core/storage/paused_training_store.dart';
import 'package:mindvibe_app/features/billing/premium_access.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/features/training/presentation/widgets/prepare_session_modal.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

Future<void> startTodayTraining(
  BuildContext context,
  AppLocalizations l10n,
  TodayTraining training,
) async {
  if (training.sessions.isEmpty) {
    return;
  }
  if (training.todayCompleted) {
    await context.push(AppRoutes.plan);
    return;
  }
  if (!training.access.contentAccess ||
      !training.sessions.first.access.contentAccess) {
    await context.push(AppRoutes.paywall);
    return;
  }
  final sessionId = training.sessions.first.id;
  final paused = await PausedTrainingStore().read();
  if (!context.mounted) {
    return;
  }
  final resume = paused?.sessionId == sessionId;
  if (!resume) {
    final confirmed = await showPrepareSessionModal(
      context: context,
      title: l10n.sessionPrepareTitle,
      body: l10n.sessionPrepareBody(training.estimatedMinutes),
      confirmLabel: l10n.prepareStart,
      cancelLabel: l10n.cancel,
      coverUrl: training.program.coverUrl,
    );
    if (!context.mounted || !confirmed) {
      return;
    }
  }
  if (!context.mounted) {
    return;
  }
  await context.push(AppRoutes.sessionPath(sessionId, prepared: true));
}

void openHomeDestination(
  BuildContext context, {
  required String slug,
  required List<ProgramSummary> programs,
  bool isPremium = false,
}) {
  if (homeSlugRequiresPremium(slug) && !isPremium) {
    context.push(AppRoutes.paywall);
    return;
  }
  switch (slug) {
    case 'breathing':
      context.push(AppRoutes.breathing);
      return;
    case 'sleep':
      context.push(AppRoutes.momentsPath(category: 'sleep'));
      return;
    case 'relaxation':
      context.push(AppRoutes.momentsPath(category: 'relaxation'));
      return;
    case 'memory':
      context.push(AppRoutes.exerciseLibraryPath(type: 'memory'));
      return;
    default:
      final match = programs
          .where((program) => program.categorySlug == slug)
          .firstOrNull;
      if (match != null) {
        context.push(AppRoutes.programPath(match.id));
        return;
      }
      context.push(AppRoutes.explore);
  }
}

double programAreaProgress(ProgramSummary? program) {
  if (program == null || program.durationDays <= 0) {
    return 0;
  }
  final done = program.daysCompleted ?? program.currentDayNumber ?? 0;
  return (done / program.durationDays).clamp(0.0, 1.0);
}

ProgramSummary? programForSlug(List<ProgramSummary> programs, String slug) {
  return programs.where((program) => program.categorySlug == slug).firstOrNull;
}

String compactDuration(int totalSeconds) {
  if (totalSeconds < 60) {
    return '0m';
  }
  final hours = totalSeconds ~/ 3600;
  final minutes = (totalSeconds % 3600) ~/ 60;
  if (hours == 0) {
    return '${minutes}m';
  }
  if (minutes == 0) {
    return '${hours}h';
  }
  return '${hours}h ${minutes}m';
}
