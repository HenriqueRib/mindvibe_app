import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/features/progress/presentation/widgets/checkin_week_strip.dart';
import 'package:mindvibe_app/features/tools/presentation/providers/checkin_controller.dart';
import 'package:mindvibe_app/features/tools/presentation/widgets/checkin_mood_energy.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class CheckinPage extends ConsumerWidget {
  const CheckinPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(checkinControllerProvider);
    final runner = ref.read(checkinControllerProvider.notifier);

    return AppScaffold(
      showBack: true,
      title: l10n.checkinTitle,
      body: state.loading
          ? AppLoading(label: l10n.loadingLabel)
          : ListView(
              children: [
                AppText.subtitle(l10n.checkinHint, align: TextAlign.center),
                const SizedBox(height: 28),
                CheckinMoodEnergy(
                  l10n: l10n,
                  mood: state.mood,
                  energy: state.energy,
                  onMood: runner.setMood,
                  onEnergy: runner.setEnergy,
                ),
                const SizedBox(height: 32),
                if (state.failure != null) ...[
                  AppInlineError(message: failureMessage(state.failure!, l10n)),
                  const SizedBox(height: 12),
                ],
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  child: _Status(
                    key: ValueKey('${state.saved}-${state.saving}'),
                    state: state,
                    l10n: l10n,
                  ),
                ),
                if (state.snapshot.days.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  CheckinWeekStrip(days: state.snapshot.days, l10n: l10n),
                ],
                if (state.saved) ...[
                  const SizedBox(height: 20),
                  AppButton(
                    label: l10n.clearMindFromCheckin,
                    variant: AppButtonVariant.ghost,
                    onPressed: () => context.push(AppRoutes.clearMind),
                  ),
                  const SizedBox(height: 10),
                  AppButton(
                    label: l10n.checkinSeeProgress,
                    variant: AppButtonVariant.secondary,
                    onPressed: () => context.go(AppRoutes.progress),
                  ),
                ],
                const SizedBox(height: 12),
              ],
            ),
    );
  }
}

class _Status extends StatelessWidget {
  const _Status({super.key, required this.state, required this.l10n});

  final CheckinUiState state;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    if (state.saving) {
      return Text(
        l10n.checkinSaving,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      );
    }
    if (!state.ready) {
      return const SizedBox(height: 20);
    }
    final weight = ((state.mood! + state.energy!) / 2).round().clamp(1, 5);
    return Column(
      children: [
        Text(
          l10n.checkinWeight('$weight'),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          state.saved ? l10n.checkinSaved : l10n.checkinUpdateHint,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
