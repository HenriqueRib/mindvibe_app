import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/tools/presentation/providers/silent_room_controller.dart';
import 'package:mindvibe_app/features/tools/presentation/widgets/timer_ring.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class SilentRoomPage extends ConsumerWidget {
  const SilentRoomPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final room = ref.watch(silentRoomProvider);
    final runner = ref.read(silentRoomProvider.notifier);

    return AppScaffold(
      showBack: true,
      title: l10n.silentRoomTitle,
      body: Column(
        children: [
          AppText.subtitle(l10n.silentRoomHint, align: TextAlign.center),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              for (final minutes in SilentRoomController.lengths)
                ChoiceChip(
                  label: Text(l10n.silentRoomMinutes(minutes)),
                  selected: room.minutes == minutes,
                  onSelected: room.running
                      ? null
                      : (_) => runner.setMinutes(minutes),
                ),
            ],
          ),
          const Spacer(),
          Pulse(
            enabled: room.running,
            minScale: 0.985,
            maxScale: 1.025,
            duration: const Duration(milliseconds: 2200),
            child: TimerRing(
              progress: room.completed ? 1 : room.progress,
              color: Theme.of(context).colorScheme.primary,
              track: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    room.completed
                        ? l10n.silentRoomDone
                        : l10n.silentRoomPresence,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _format(room.remaining),
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
          const Spacer(),
          AppButton(
            label: room.running ? l10n.pomodoroPause : l10n.pomodoroStart,
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

  String _format(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
