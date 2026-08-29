import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/features/catalog/presentation/widgets/catalog_plan_card.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class CatalogPage extends ConsumerWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final catalog = ref.watch(catalogProvider);
    final currentId = ref
        .watch(todayProvider)
        .maybeWhen(
          data: (result) => result.valueOrNull?.program.id,
          orElse: () => null,
        );

    return AppScaffold(
      showBack: true,
      title: l10n.catalogTitle,
      body: catalog.when(
        loading: () => AppLoading(label: l10n.loadingLabel),
        error: (_, _) => AppError(
          title: l10n.errorLoadTitle,
          message: l10n.errorGeneric,
          retryLabel: l10n.actionRetry,
          onRetry: () => ref.invalidate(catalogProvider),
        ),
        data: (result) => result.when(
          failure: (failure) => AppError(
            title: l10n.errorLoadTitle,
            message: failureMessage(failure, l10n),
            retryLabel: l10n.actionRetry,
            onRetry: () => ref.invalidate(catalogProvider),
          ),
          success: (programs) {
            if (programs.isEmpty) {
              return AppEmpty(
                title: l10n.catalogEmpty,
                body: l10n.emptyBody,
                icon: Icons.explore_outlined,
                actionLabel: l10n.actionBack,
                onAction: () => context.pop(),
              );
            }
            final ordered = _orderedPlans(programs, currentId);
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(catalogProvider);
                ref.invalidate(todayProvider);
                await Future.wait([
                  ref.read(catalogProvider.future),
                  ref.read(todayProvider.future),
                ]);
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  AppText.title(l10n.onboardingGoalTitle),
                  const SizedBox(height: 8),
                  AppText.subtitle(l10n.catalogBrowseHint),
                  const SizedBox(height: 20),
                  for (var i = 0; i < ordered.length; i++) ...[
                    CatalogPlanCard(
                      program: ordered[i],
                      l10n: l10n,
                      index: i,
                      isCurrent: ordered[i].id == currentId,
                      onTap: () =>
                          context.push(AppRoutes.programPath(ordered[i].id)),
                    ),
                    const SizedBox(height: 14),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

List<ProgramSummary> _orderedPlans(
  List<ProgramSummary> programs,
  int? currentId,
) {
  if (currentId == null) {
    return programs;
  }
  return [
    ...programs.where((program) => program.id == currentId),
    ...programs.where((program) => program.id != currentId),
  ];
}
