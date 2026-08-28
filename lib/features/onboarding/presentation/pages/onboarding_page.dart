import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/core/providers/core_providers.dart';
import 'package:mindvibe_app/features/auth/domain/auth_validators.dart';
import 'package:mindvibe_app/features/auth/presentation/providers/session_controller.dart';
import 'package:mindvibe_app/features/catalog/presentation/widgets/plan_goal_picker.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  int _step = 0;
  final _name = TextEditingController();
  String? _goal;
  String _experience = 'beginner';
  bool _reminder = true;
  TimeOfDay _time = const TimeOfDay(hour: 8, minute: 0);
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _name.text = ref.read(sessionControllerProvider).user?.name ?? '';
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  bool get _canContinue => switch (_step) {
    1 => AuthValidators.required(_name.text) == null,
    2 => _goal != null,
    _ => true,
  };

  Future<void> _next() async {
    if (!_canContinue) {
      return;
    }
    if (_step < 4) {
      setState(() => _step += 1);
      return;
    }
    await _finish();
  }

  Future<void> _finish() async {
    if (_goal == null) {
      setState(() => _step = 2);
      return;
    }
    final l10n = AppLocalizations.of(context);
    setState(() => _loading = true);
    final time = _reminder
        ? '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}'
        : null;
    final result = await ref
        .read(sessionControllerProvider.notifier)
        .completeOnboarding(
          name: _name.text.trim(),
          goal: _goal!,
          experienceLevel: _experience,
          notificationEnabled: _reminder,
          notificationTime: time,
        );
    if (!mounted) {
      return;
    }
    if (result.isSuccess) {
      ref.read(sessionControllerProvider.notifier).goReady();
      final user = ref.read(sessionControllerProvider).user;
      if (user != null) {
        await ref
            .read(notificationSchedulerProvider)
            .sync(
              user,
              title: l10n.notificationTitle,
              body: l10n.notificationBody,
            );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failureMessage(result.failureOrNull!, l10n))),
      );
    }
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppProgressBar(value: (_step + 1) / 5),
          const SizedBox(height: 28),
          Expanded(child: _stepContent(l10n)),
          if (_step == 0) ...[
            AppButton(
              label: l10n.actionSkip,
              variant: AppButtonVariant.ghost,
              onPressed: _loading ? null : () => setState(() => _step = 2),
            ),
            const SizedBox(height: 8),
          ],
          AppButton(
            label: l10n.actionContinue,
            loading: _loading,
            onPressed: _canContinue ? _next : null,
          ),
        ],
      ),
    );
  }

  Widget _stepContent(AppLocalizations l10n) {
    return switch (_step) {
      0 => _copy(l10n.onboardingWelcomeTitle, l10n.onboardingWelcomeBody),
      1 => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.title(l10n.onboardingNameTitle),
          const SizedBox(height: 24),
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: l10n.fieldName),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
      2 => _goalStep(l10n),
      3 => _choices(
        l10n.onboardingExperienceTitle,
        {
          'beginner': l10n.experienceBeginner,
          'intermediate': l10n.experienceIntermediate,
          'experienced': l10n.experienceExperienced,
        },
        selected: {_experience},
        onToggle: (value) => setState(() => _experience = value),
      ),
      _ => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.title(l10n.onboardingReminderTitle),
          const SizedBox(height: 8),
          AppText.subtitle(l10n.onboardingReminderBody),
          const SizedBox(height: 24),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.reminderEnable),
            value: _reminder,
            onChanged: (value) => setState(() => _reminder = value),
          ),
          if (_reminder)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.reminderTime),
              trailing: Text(_time.format(context)),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: _time,
                );
                if (picked != null) {
                  setState(() => _time = picked);
                }
              },
            ),
        ],
      ),
    };
  }

  Widget _goalStep(AppLocalizations l10n) {
    final programs = ref
        .watch(catalogProvider)
        .maybeWhen(
          data: (result) => result.valueOrNull ?? const <ProgramSummary>[],
          orElse: () => const <ProgramSummary>[],
        );
    return ListView(
      children: [
        AppText.title(l10n.onboardingGoalTitle),
        const SizedBox(height: 8),
        AppText.subtitle(l10n.onboardingGoalHint),
        const SizedBox(height: 20),
        PlanGoalPicker(
          l10n: l10n,
          programs: programs,
          selectedGoal: _goal,
          onSelected: (goal) => setState(() => _goal = goal),
        ),
      ],
    );
  }

  Widget _copy(String title, String body) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.title(title),
        const SizedBox(height: 12),
        AppText.subtitle(body),
      ],
    );
  }

  Widget _choices(
    String title,
    Map<String, String> options, {
    required Set<String> selected,
    required ValueChanged<String> onToggle,
    String? hint,
    bool multi = false,
  }) {
    return ListView(
      children: [
        AppText.title(title),
        if (hint != null) ...[
          const SizedBox(height: 8),
          AppText.subtitle(hint),
        ],
        const SizedBox(height: 20),
        ...options.entries.map((entry) {
          final active = selected.contains(entry.key);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              onTap: () => onToggle(entry.key),
              child: Row(
                children: [
                  Expanded(child: Text(entry.value)),
                  Icon(
                    multi
                        ? (active
                              ? Icons.check_box
                              : Icons.check_box_outline_blank)
                        : (active ? Icons.check_circle : Icons.circle_outlined),
                    color: active ? AppColors.primary : AppColors.muted,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
