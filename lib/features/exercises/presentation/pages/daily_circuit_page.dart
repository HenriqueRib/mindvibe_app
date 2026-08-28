import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/features/exercises/presentation/widgets/daily_drill_view.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class DailyCircuitPage extends ConsumerStatefulWidget {
  const DailyCircuitPage({super.key, required this.steps});

  final List<ExerciseSpec> steps;

  @override
  ConsumerState<DailyCircuitPage> createState() => _DailyCircuitPageState();
}

class _DailyCircuitPageState extends ConsumerState<DailyCircuitPage> {
  var _index = 0;
  var _submitting = false;

  ExerciseSpec get _current => widget.steps[_index];

  Future<void> _submit(Map<String, dynamic> payload) async {
    if (_submitting) {
      return;
    }
    _submitting = true;
    final l10n = AppLocalizations.of(context);
    final result = await ref
        .read(trainingRepositoryProvider)
        .submitExerciseResult(
          exerciseId: _current.id,
          userSessionId: null,
          payload: payload,
        );
    if (!mounted) {
      return;
    }
    _submitting = false;
    if (!result.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failureMessage(result.failureOrNull!, l10n))),
      );
      return;
    }
    if (_index >= widget.steps.length - 1) {
      ref.invalidate(progressProvider);
      ref.invalidate(historyProvider);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.dailyCircuitDone)));
      context.pop();
      return;
    }
    setState(() => _index += 1);
  }

  Future<void> _confirmLeave() async {
    final l10n = AppLocalizations.of(context);
    final leave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.dailyLeaveTitle),
        content: Text(l10n.dailyLeaveBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.actionBack),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.dailyLeaveConfirm),
          ),
        ],
      ),
    );
    if (leave == true && mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final night = Theme.of(context).brightness == Brightness.dark;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _confirmLeave();
        }
      },
      child: AppScaffold(
        showBack: true,
        title: l10n.dailyCircuitTitle,
        backgroundColor: night ? AppColors.nightBackground : null,
        body: Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < widget.steps.length; i++) ...[
                      _StepDot(active: i == _index, done: i < _index),
                      if (i < widget.steps.length - 1)
                        Container(
                          width: 28,
                          height: 2,
                          color: i < _index
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.dailyCircuitStep(_index + 1, widget.steps.length),
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _current.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: DailyDrillView(
                    key: ValueKey(_current.id),
                    exercise: _current,
                    durationOverride: 300,
                    onCompleted: _submit,
                  ),
                ),
              ],
            ),
            if (_submitting)
              const ModalBarrier(dismissible: false, color: Color(0x33000000)),
            if (_submitting) const Center(child: AppLoading.compact()),
          ],
        ),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({required this.active, required this.done});

  final bool active;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: active ? 14 : 10,
      height: active ? 14 : 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done || active ? AppColors.primary : AppColors.border,
      ),
    );
  }
}
