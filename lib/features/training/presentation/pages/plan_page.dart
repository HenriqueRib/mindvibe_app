import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/core/providers/core_providers.dart';
import 'package:mindvibe_app/features/auth/presentation/providers/session_controller.dart';
import 'package:mindvibe_app/features/home/presentation/home_actions.dart';
import 'package:mindvibe_app/features/home/presentation/widgets/home_shared.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class PlanPage extends ConsumerStatefulWidget {
  const PlanPage({super.key});

  @override
  ConsumerState<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends ConsumerState<PlanPage> {
  bool _saving = false;

  TimeOfDay _timeFrom(String? raw) {
    final parts = (raw ?? '08:00').split(':');
    return TimeOfDay(
      hour: int.tryParse(parts.first) ?? 8,
      minute: parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0,
    );
  }

  String _format(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _setCadence(TodayTraining training, String cadence) async {
    final enrollmentId = training.program.userProgramId;
    if (enrollmentId == null || training.cadence == cadence || _saving) {
      return;
    }
    setState(() => _saving = true);
    final result = await ref
        .read(trainingRepositoryProvider)
        .updateCadence(userProgramId: enrollmentId, cadence: cadence);
    if (!mounted) {
      return;
    }
    setState(() => _saving = false);
    final l10n = AppLocalizations.of(context);
    if (result.isSuccess) {
      ref.invalidate(todayProvider);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failureMessage(result.failureOrNull!, l10n))),
      );
    }
  }

  Future<void> _saveReminder({
    required bool enabled,
    required String time,
  }) async {
    if (_saving) {
      return;
    }
    setState(() => _saving = true);
    final l10n = AppLocalizations.of(context);
    final result = await ref
        .read(sessionControllerProvider.notifier)
        .updateProfile(notificationEnabled: enabled, notificationTime: time);
    if (!mounted) {
      return;
    }
    setState(() => _saving = false);
    final user = result.valueOrNull;
    if (user != null) {
      await ref
          .read(notificationSchedulerProvider)
          .sync(
            user,
            title: l10n.notificationTitle,
            body: l10n.notificationBody,
          );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failureMessage(result.failureOrNull!, l10n))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final today = ref.watch(todayProvider);
    final pausedSessionId = ref
        .watch(pausedTrainingProvider)
        .maybeWhen(data: (paused) => paused?.sessionId, orElse: () => null);

    return AppScaffold(
      showBack: true,
      title: l10n.planTitle,
      body: today.when(
        loading: () => AppLoading(label: l10n.loadingLabel),
        error: (error, _) => AppError(
          message: l10n.errorGeneric,
          retryLabel: l10n.actionRetry,
          onRetry: () => ref.invalidate(todayProvider),
        ),
        data: (result) {
          return result.when(
            failure: (failure) {
              if (failure.isNoActiveProgram) {
                return _empty(context, l10n);
              }
              return AppError(
                message: failureMessage(failure, l10n),
                retryLabel: l10n.actionRetry,
                onRetry: () => ref.invalidate(todayProvider),
              );
            },
            success: (training) =>
                _plan(context, l10n, training, pausedSessionId),
          );
        },
      ),
    );
  }

  Widget _empty(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        AppText.title(l10n.planEmpty, align: TextAlign.center),
        const SizedBox(height: 12),
        AppText.subtitle(l10n.homeNoProgramBody, align: TextAlign.center),
        const Spacer(),
        AppButton(
          label: l10n.homeChoosePlan,
          onPressed: () => context.push(AppRoutes.choosePlan),
        ),
      ],
    );
  }

  Widget _plan(
    BuildContext context,
    AppLocalizations l10n,
    TodayTraining training,
    int? pausedSessionId,
  ) {
    final user = ref.watch(sessionControllerProvider).user;
    final reminder = user?.notificationEnabled ?? false;
    final time = _timeFrom(user?.notificationTime);
    final weekdays = training.cadence == 'weekdays';
    final total = training.program.durationDays <= 0
        ? training.days.length
        : training.program.durationDays;
    final done = training.days.where((day) => day.status == 'completed').length;
    final canStart = !training.todayCompleted && training.sessions.isNotEmpty;
    final nextDate = formatPlanDate(training.nextAvailableOn);
    final nextTitle = training.nextDayTitle;

    return ListView(
      children: [
        Text(
          training.program.title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            height: 1.2,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          l10n.planDaysDone(done, total),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.success,
          ),
        ),
        const SizedBox(height: 14),
        _DayProgressLine(days: training.days, total: total),
        const SizedBox(height: 24),
        if (canStart)
          AppButton(
            label: homeStartLabel(
              l10n,
              training,
              pausedSessionId: pausedSessionId,
            ),
            onPressed: () => startTodayTraining(context, l10n, training),
          )
        else if (nextTitle != null && nextTitle.isNotEmpty) ...[
          Text(
            l10n.planDoneForToday,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            civilDateIsTomorrow(training.nextAvailableOn)
                ? l10n.planNextUnlocksTomorrow(
                    l10n.planDayLabel(
                      training.nextDayNumber ?? 0,
                      nextTitle,
                    ),
                  )
                : l10n.planNextTraining(
                    l10n.planDayLabel(
                      training.nextDayNumber ?? 0,
                      nextTitle,
                    ),
                    nextDate,
                  ),
            style: const TextStyle(
              height: 1.4,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
        const SizedBox(height: 28),
        AppCard(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            children: [
              for (var i = 0; i < training.days.length; i++) ...[
                if (i > 0)
                  Divider(
                    height: 1,
                    color: Theme.of(context).colorScheme.outline.withValues(
                      alpha: 0.7,
                    ),
                  ),
                _DayRow(
                  l10n: l10n,
                  day: training.days[i],
                  upcoming:
                      training.todayCompleted &&
                      training.nextDayNumber != null &&
                      training.days[i].dayNumber == training.nextDayNumber,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        _SettingsFold(
          title: l10n.planSettings,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                weekdays
                    ? l10n.planCadenceHintWeekdays
                    : l10n.planCadenceHintDaily,
                style: const TextStyle(color: AppColors.muted, height: 1.4),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: Text(l10n.planCadenceDaily),
                    selected: !weekdays,
                    onSelected: _saving
                        ? null
                        : (_) => _setCadence(training, 'daily'),
                  ),
                  ChoiceChip(
                    label: Text(l10n.planCadenceWeekdays),
                    selected: weekdays,
                    onSelected: _saving
                        ? null
                        : (_) => _setCadence(training, 'weekdays'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.reminderEnable),
                subtitle: Text(l10n.planReminderHint),
                value: reminder,
                onChanged: _saving
                    ? null
                    : (value) =>
                          _saveReminder(enabled: value, time: _format(time)),
              ),
              if (reminder)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.reminderTime),
                  trailing: Text(time.format(context)),
                  onTap: _saving
                      ? null
                      : () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: time,
                          );
                          if (picked != null) {
                            await _saveReminder(
                              enabled: true,
                              time: _format(picked),
                            );
                          }
                        },
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DayProgressLine extends StatelessWidget {
  const _DayProgressLine({required this.days, required this.total});

  final List<ProgramDayPreview> days;
  final int total;

  @override
  Widget build(BuildContext context) {
    final count = total <= 0 ? days.length : total;
    if (count <= 0) {
      return const SizedBox.shrink();
    }
    return Row(
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: 5),
          Expanded(
            child: _DaySegment(
              status: i < days.length ? days[i].status : null,
            ),
          ),
        ],
      ],
    );
  }
}

class _DaySegment extends StatelessWidget {
  const _DaySegment({this.status});

  final String? status;

  @override
  Widget build(BuildContext context) {
    final done = status == 'completed';
    final track = Theme.of(context).colorScheme.outline.withValues(alpha: 0.28);

    return Container(
      height: 10,
      decoration: BoxDecoration(
        color: done ? AppColors.success : track,
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.l10n,
    required this.day,
    this.upcoming = false,
  });

  final AppLocalizations l10n;
  final ProgramDayPreview day;
  final bool upcoming;

  @override
  Widget build(BuildContext context) {
    final done = day.status == 'completed';
    final today = day.status == 'today';
    final highlight = today || upcoming;
    final color = done
        ? AppColors.success
        : highlight
        ? AppColors.accent
        : AppColors.muted;
    final hint = switch (day.status) {
      'completed' => l10n.planDayDone,
      'today' => l10n.planDayToday,
      _ when upcoming && civilDateIsTomorrow(day.availableOn) =>
        l10n.planDayTomorrow,
      _ => l10n.planDayLocked(formatPlanDate(day.availableOn)),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: done || highlight ? color : color.withValues(alpha: 0.35),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.planDayLabel(day.dayNumber, day.title),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            hint,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: highlight ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsFold extends StatefulWidget {
  const _SettingsFold({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  State<_SettingsFold> createState() => _SettingsFoldState();
}

class _SettingsFoldState extends State<_SettingsFold> {
  var _open = false;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(16, 4, 8, 8),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            trailing: Icon(
              _open ? Icons.expand_less_rounded : Icons.expand_more_rounded,
            ),
            onTap: () => setState(() => _open = !_open),
          ),
          if (_open)
            Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 8),
              child: widget.child,
            ),
        ],
      ),
    );
  }
}

String formatPlanDate(String? iso) {
  if (iso == null || iso.isEmpty) {
    return '';
  }
  final parts = iso.split('-');
  if (parts.length != 3) {
    return iso;
  }
  return '${parts[2]}/${parts[1]}';
}
