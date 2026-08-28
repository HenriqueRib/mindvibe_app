import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

IconData activityIcon(ActivityItem item) {
  if (item.type == 'exercise') {
    return switch (item.exerciseType) {
      'breathing' => Icons.air,
      'attention' => Icons.center_focus_strong_outlined,
      'memory' => Icons.psychology_outlined,
      _ => Icons.fitness_center_outlined,
    };
  }
  return switch (item.type) {
    'training_session' => Icons.self_improvement_outlined,
    'listen' => Icons.headset_outlined,
    'pomodoro' => Icons.timer_outlined,
    'silent_room' => Icons.self_improvement_outlined,
    'checkin' => Icons.spa_outlined,
    'journal' => Icons.edit_note_outlined,
    'thought' => Icons.push_pin_outlined,
    'clear_mind' => Icons.psychology_alt_outlined,
    'day_close' => Icons.nights_stay_outlined,
    _ => Icons.check_circle_outline,
  };
}

String activityTypeLabel(AppLocalizations l10n, ActivityItem item) {
  return switch (item.type) {
    'exercise' => l10n.historyTypeExercise,
    'training_session' => l10n.historyTypeSession,
    'listen' => l10n.historyTypeListen,
    'pomodoro' => l10n.historyTypePomodoro,
    'silent_room' => l10n.historyTypeSilentRoom,
    'checkin' => l10n.historyTypeCheckin,
    'journal' => l10n.historyTypeJournal,
    'thought' => l10n.historyTypeThought,
    'clear_mind' => l10n.historyTypeClearMind,
    'day_close' => l10n.historyTypeDayClose,
    _ => item.type,
  };
}

String activityDayLabel(
  AppLocalizations l10n,
  DateTime occurredAt, {
  String pattern = 'd MMM',
}) {
  final local = occurredAt.toLocal();
  final day = DateTime(local.year, local.month, local.day);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  if (day == today) {
    return l10n.historyToday;
  }
  if (day == today.subtract(const Duration(days: 1))) {
    return l10n.historyYesterday;
  }
  return DateFormat(pattern, l10n.localeName).format(day);
}

String activityDurationLabel(AppLocalizations l10n, int seconds) {
  if (seconds < 60) {
    return l10n.progressTimeUnderMinute;
  }
  return l10n.progressTimeOnlyMinutes((seconds / 60).round());
}

String _checkinMeta(AppLocalizations l10n, ActivityItem item) {
  final mood = item.mood;
  final energy = item.energy;
  if (mood == null || energy == null) {
    return l10n.historyTypeCheckin;
  }
  return l10n.progressCheckinBody(
    l10n.checkinMood('$mood'),
    l10n.checkinEnergy('$energy'),
  );
}

class ActivityRow extends StatelessWidget {
  const ActivityRow({super.key, required this.item, required this.l10n});

  final ActivityItem item;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.12),
          foregroundColor: AppColors.primary,
          child: Icon(activityIcon(item), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                switch (item.type) {
                  'journal' => l10n.journalPrompt(item.prompt ?? ''),
                  'thought' => l10n.historyTypeThought,
                  'clear_mind' => l10n.historyTypeClearMind,
                  'day_close' => l10n.historyTypeDayClose,
                  _ => item.title,
                },
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(
                '${activityDayLabel(l10n, item.occurredAt)} · ${activityTypeLabel(l10n, item)}',
                style: const TextStyle(color: AppColors.muted, fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(switch (item.type) {
          'checkin' => _checkinMeta(l10n, item),
          'journal' => l10n.historyTypeJournal,
          'thought' => l10n.historyTypeThought,
          'clear_mind' => l10n.historyTypeClearMind,
          'day_close' => l10n.historyTypeDayClose,
          _ => activityDurationLabel(l10n, item.seconds),
        }, style: const TextStyle(color: AppColors.muted)),
        const SizedBox(width: 6),
        const Icon(Icons.check_circle, color: AppColors.success, size: 18),
      ],
    );
  }
}
