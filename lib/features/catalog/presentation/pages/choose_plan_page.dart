import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/config/app_config.dart';
import 'package:mindvibe_app/features/catalog/presentation/enroll_program.dart';
import 'package:mindvibe_app/features/catalog/presentation/widgets/plan_goal_picker.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class ChoosePlanPage extends ConsumerStatefulWidget {
  const ChoosePlanPage({super.key});

  @override
  ConsumerState<ChoosePlanPage> createState() => _ChoosePlanPageState();
}

class _ChoosePlanPageState extends ConsumerState<ChoosePlanPage> {
  String? _goal;
  bool _saving = false;

  Future<void> _select(String goal, List<ProgramSummary> programs) async {
    if (_saving) {
      return;
    }
    setState(() => _goal = goal);
    final slug = AppConfig.programSlugByGoal[goal];
    final program = programs.where((item) => item.slug == slug).firstOrNull;
    if (program == null) {
      return;
    }
    final l10n = AppLocalizations.of(context);
    final current = ref
        .read(todayProvider)
        .maybeWhen(data: (result) => result.valueOrNull, orElse: () => null);
    setState(() => _saving = true);
    await enrollInProgram(
      context: context,
      ref: ref,
      l10n: l10n,
      program: program,
      current: current,
    );
    if (mounted) {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final catalog = ref.watch(catalogProvider);

    return AppScaffold(
      showBack: true,
      title: l10n.homeChoosePlan,
      body: catalog.when(
        loading: () => AppLoading(label: l10n.loadingLabel),
        error: (_, _) => AppError(
          message: l10n.errorGeneric,
          retryLabel: l10n.actionRetry,
          onRetry: () => ref.invalidate(catalogProvider),
        ),
        data: (result) => result.when(
          failure: (_) => AppEmpty(title: l10n.catalogEmpty),
          success: (programs) {
            if (programs.isEmpty) {
              return AppEmpty(title: l10n.catalogEmpty);
            }
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
                  onSelected: _saving
                      ? (_) {}
                      : (goal) => _select(goal, programs),
                ),
                if (_saving) ...[
                  const SizedBox(height: 24),
                  const Center(child: AppLoading.compact()),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
