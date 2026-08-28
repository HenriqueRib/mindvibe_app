import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/features/home/presentation/home_actions.dart';
import 'package:mindvibe_app/features/tools/presentation/providers/thought_controller.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class ThoughtPage extends ConsumerStatefulWidget {
  const ThoughtPage({super.key});

  @override
  ConsumerState<ThoughtPage> createState() => _ThoughtPageState();
}

class _ThoughtPageState extends ConsumerState<ThoughtPage> {
  final _body = TextEditingController();

  @override
  void dispose() {
    _body.dispose();
    super.dispose();
  }

  bool get _hasContent => _body.text.trim().isNotEmpty;

  Future<void> _park() async {
    if (!_hasContent) {
      return;
    }
    final saved = await ref
        .read(thoughtControllerProvider.notifier)
        .park(_body.text);
    if (!saved || !mounted) {
      return;
    }
    await HapticFeedback.mediumImpact();
    _body.clear();
    setState(() {});
  }

  Future<void> _goTraining() async {
    final l10n = AppLocalizations.of(context);
    final today = switch (ref.read(todayProvider)) {
      AsyncData(:final value) => value.valueOrNull,
      _ => null,
    };
    if (today != null && today.sessions.isNotEmpty) {
      await startTodayTraining(context, l10n, today);
      return;
    }
    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(thoughtControllerProvider);
    final runner = ref.read(thoughtControllerProvider.notifier);
    final night = Theme.of(context).brightness == Brightness.dark;
    final atLimit = state.lot.isFull;
    ref.watch(todayProvider);

    return AppScaffold(
      showBack: true,
      title: l10n.thoughtTitle,
      backgroundColor: night ? AppColors.nightBackground : null,
      body: state.loading
          ? AppLoading(label: l10n.loadingLabel)
          : ListView(
              children: [
                AppText.subtitle(l10n.thoughtHint, align: TextAlign.center),
                const SizedBox(height: 20),
                TextField(
                  controller: _body,
                  maxLength: 280,
                  maxLines: 4,
                  minLines: 3,
                  enabled: !atLimit,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (_) {
                    runner.clearJustParked();
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: l10n.thoughtPlaceholder,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.thoughtPrivate,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                if (state.failure != null) ...[
                  Text(
                    failureMessage(state.failure!, l10n),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.error),
                  ),
                  const SizedBox(height: 12),
                ],
                if (atLimit) ...[
                  Text(
                    l10n.thoughtLotFull,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.muted, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                ],
                AppButton(
                  label: l10n.thoughtSave,
                  loading: state.saving,
                  onPressed: !atLimit && _hasContent && !state.saving
                      ? _park
                      : null,
                ),
                if (state.justParked) ...[
                  const SizedBox(height: 20),
                  Text(
                    l10n.thoughtSaved,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.thoughtContinue,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      _FollowChip(
                        icon: Icons.self_improvement_outlined,
                        label: l10n.thoughtContinueTraining,
                        onTap: _goTraining,
                      ),
                      _FollowChip(
                        icon: Icons.headset_outlined,
                        label: l10n.thoughtContinueAudio,
                        onTap: () => context.push(AppRoutes.moments),
                      ),
                      _FollowChip(
                        icon: Icons.nights_stay_outlined,
                        label: l10n.thoughtContinueSleep,
                        onTap: () => context.push(
                          AppRoutes.momentsPath(category: 'sleep'),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 32),
                Text(
                  l10n.thoughtLot,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.muted,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 12),
                if (state.lot.items.isEmpty)
                  Text(
                    l10n.thoughtLotEmpty,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.muted, height: 1.4),
                  )
                else
                  for (final thought in state.lot.items) ...[
                    AppCard(
                      padding: const EdgeInsets.fromLTRB(16, 14, 8, 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 6, bottom: 6),
                              child: Text(
                                thought.body,
                                style: const TextStyle(height: 1.4),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: state.releasingId == thought.id
                                ? null
                                : () {
                                    HapticFeedback.selectionClick();
                                    runner.release(thought.id);
                                  },
                            child: state.releasingId == thought.id
                                ? const AppLoading.compact()
                                : Text(l10n.thoughtRelease),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                const SizedBox(height: 12),
              ],
            ),
    );
  }
}

class _FollowChip extends StatelessWidget {
  const _FollowChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ScaleOnTap(
      child: ActionChip(
        avatar: Icon(icon, size: 18),
        label: Text(label),
        onPressed: onTap,
      ),
    );
  }
}
