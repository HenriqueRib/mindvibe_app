import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

Future<void> enrollInProgram({
  required BuildContext context,
  required WidgetRef ref,
  required AppLocalizations l10n,
  required ProgramSummary program,
  TodayTraining? current,
}) async {
  if (current?.program.id == program.id) {
    return;
  }
  var replace = false;
  if (current != null) {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(l10n.catalogSwitchTitle),
          content: Text(l10n.catalogSwitchBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.catalogSwitchConfirm),
            ),
          ],
        );
      },
    );
    if (confirmed != true) {
      return;
    }
    replace = true;
  }
  if (!context.mounted) {
    return;
  }
  final result = await ref
      .read(trainingRepositoryProvider)
      .enroll(program.id, replace: replace);
  if (!context.mounted) {
    return;
  }
  if (!result.isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(failureMessage(result.failureOrNull!, l10n))),
    );
    return;
  }
  ref.invalidate(todayProvider);
  ref.invalidate(catalogProvider);
  ref.invalidate(progressProvider);
  ref.invalidate(weeklyReportProvider);
  if (context.mounted) {
    context.go(AppRoutes.home);
  }
}

String catalogEnrollLabel({
  required AppLocalizations l10n,
  required ProgramSummary program,
  TodayTraining? current,
}) {
  if (current?.program.id == program.id) {
    return l10n.catalogEnrollCurrent;
  }
  if (current != null) {
    return l10n.catalogSwitch;
  }
  return l10n.catalogEnroll;
}
