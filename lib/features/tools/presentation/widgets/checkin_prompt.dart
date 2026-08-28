import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/features/tools/presentation/providers/checkin_controller.dart';
import 'package:mindvibe_app/features/tools/presentation/widgets/checkin_mood_energy.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class DailyCheckinPrompt extends ConsumerStatefulWidget {
  const DailyCheckinPrompt({super.key});

  @override
  ConsumerState<DailyCheckinPrompt> createState() => _DailyCheckinPromptState();
}

class _DailyCheckinPromptState extends ConsumerState<DailyCheckinPrompt>
    with WidgetsBindingObserver {
  var _open = false;
  var _skippedThisForeground = false;
  RouterDelegate<Object>? _delegate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final delegate = GoRouter.of(context).routerDelegate;
    if (_delegate != delegate) {
      _delegate?.removeListener(_onRoute);
      _delegate = delegate;
      _delegate!.addListener(_onRoute);
    }
  }

  @override
  void dispose() {
    _delegate?.removeListener(_onRoute);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onRoute() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _skippedThisForeground = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  bool get _needsCheckin {
    final snapshot = ref.read(progressProvider).asData?.value.valueOrNull;
    return snapshot != null && snapshot.checkin.today == null;
  }

  bool _onMainTabs(BuildContext context) {
    final path = GoRouter.of(
      context,
    ).routerDelegate.currentConfiguration.uri.path;
    return path == AppRoutes.home ||
        path == AppRoutes.progress ||
        path == AppRoutes.profile;
  }

  void _maybeOpen() {
    if (!mounted ||
        _open ||
        _skippedThisForeground ||
        !_needsCheckin ||
        !_onMainTabs(context)) {
      return;
    }
    _open = true;
    showCheckinPromptModal(context).whenComplete(() {
      _open = false;
      if (!mounted) {
        return;
      }
      if (_needsCheckin) {
        _skippedThisForeground = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(progressProvider).asData?.value.valueOrNull;
    final needs = snapshot != null && snapshot.checkin.today == null;
    if (needs && !_open && !_skippedThisForeground && _onMainTabs(context)) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _maybeOpen());
    }
    return const SizedBox.shrink();
  }
}

Future<void> showCheckinPromptModal(BuildContext context) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierLabel: AppLocalizations.of(context).checkinTitle,
    barrierColor: Colors.black.withValues(alpha: 0.62),
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (context, animation, secondaryAnimation) {
      return const CheckinPromptModal();
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class CheckinPromptModal extends ConsumerWidget {
  const CheckinPromptModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final state = ref.watch(checkinControllerProvider);
    final runner = ref.read(checkinControllerProvider.notifier);

    ref.listen(checkinControllerProvider, (previous, next) {
      if (!context.mounted || previous == null) {
        return;
      }
      if (!previous.saved && next.saved && next.snapshot.today != null) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    });

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Material(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(28),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 26, 22, 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.86,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.spa_outlined, size: 36, color: scheme.primary),
                      const SizedBox(height: 14),
                      Text(
                        l10n.checkinTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.checkinHint,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.muted,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (state.loading)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: AppLoading(
                            label: l10n.loadingLabel,
                            markSize: 56,
                          ),
                        )
                      else ...[
                        CheckinMoodEnergy(
                          l10n: l10n,
                          mood: state.mood,
                          energy: state.energy,
                          onMood: runner.setMood,
                          onEnergy: runner.setEnergy,
                        ),
                        const SizedBox(height: 20),
                        if (state.failure != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              failureMessage(state.failure!, l10n),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: AppColors.error),
                            ),
                          ),
                        if (state.saving)
                          Text(
                            l10n.checkinSaving,
                            style: const TextStyle(color: AppColors.muted),
                          )
                        else if (state.ready)
                          Text(
                            l10n.checkinWeight(
                              '${((state.mood! + state.energy!) / 2).round().clamp(1, 5)}',
                            ),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                      ],
                      const SizedBox(height: 16),
                      AppButton(
                        label: l10n.checkinPromptLater,
                        variant: AppButtonVariant.ghost,
                        onPressed: () =>
                            Navigator.of(context, rootNavigator: true).pop(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
