import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/tools/presentation/providers/pomodoro_controller.dart';
import 'package:mindvibe_app/features/tools/presentation/widgets/timer_ring.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class PomodoroPage extends ConsumerWidget {
  const PomodoroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final pomodoro = ref.watch(pomodoroProvider);
    final runner = ref.read(pomodoroProvider.notifier);
    final night = Theme.of(context).brightness == Brightness.dark;
    final phaseLabel = pomodoro.phase == PomodoroPhase.focus
        ? l10n.pomodoroFocus
        : l10n.pomodoroBreak;

    return AppScaffold(
      showBack: true,
      title: l10n.pomodoroTitle,
      backgroundColor: night ? AppColors.nightBackground : null,
      body: Column(
        children: [
          AppText.subtitle(l10n.pomodoroHint, align: TextAlign.center),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _presetChip(
                context,
                label: l10n.pomodoroPresetClassic,
                selected: pomodoro.preset.focus == PomodoroPreset.classic.focus,
                enabled: !pomodoro.running,
                onTap: () => runner.setPreset(PomodoroPreset.classic),
              ),
              _presetChip(
                context,
                label: l10n.pomodoroPresetShort,
                selected: pomodoro.preset.focus == PomodoroPreset.short.focus,
                enabled: !pomodoro.running,
                onTap: () => runner.setPreset(PomodoroPreset.short),
              ),
              _presetChip(
                context,
                label: l10n.pomodoroPresetLong,
                selected: pomodoro.preset.focus == PomodoroPreset.long.focus,
                enabled: !pomodoro.running,
                onTap: () => runner.setPreset(PomodoroPreset.long),
              ),
            ],
          ),
          const Spacer(),
          Pulse(
            enabled: pomodoro.running,
            minScale: 0.985,
            maxScale: 1.025,
            duration: const Duration(milliseconds: 1800),
            child: TimerRing(
              progress: pomodoro.progress,
              color: pomodoro.phase == PomodoroPhase.focus
                  ? AppColors.primary
                  : AppColors.accent,
              track: night ? AppColors.nightSurface : AppColors.surfaceMuted,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    child: Text(
                      phaseLabel,
                      key: ValueKey(phaseLabel),
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _format(pomodoro.remaining),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.pomodoroRounds(pomodoro.rounds),
            style: const TextStyle(color: AppColors.muted),
          ),
          const Spacer(),
          AppButton(
            label: pomodoro.running ? l10n.pomodoroPause : l10n.pomodoroStart,
            onPressed: runner.toggle,
          ),
          const SizedBox(height: 12),
          AppButton(
            label: l10n.pomodoroReset,
            variant: AppButtonVariant.ghost,
            onPressed: runner.reset,
          ),
        ],
      ),
    );
  }

  Widget _presetChip(
    BuildContext context, {
    required String label,
    required bool selected,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: enabled ? (_) => onTap() : null,
    );
  }

  String _format(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
