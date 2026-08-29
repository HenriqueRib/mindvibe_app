import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/features/progress/presentation/activity_presentation.dart';
import 'package:mindvibe_app/features/progress/presentation/widgets/week_time_chart.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final history = ref.watch(historyProvider);

    return AppScaffold(
      showBack: true,
      title: l10n.historyTitle,
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
      body: history.when(
        loading: () => AppLoading(label: l10n.loadingLabel),
        error: (_, _) => AppError(
          title: l10n.errorLoadTitle,
          message: l10n.errorGeneric,
          retryLabel: l10n.actionRetry,
          onRetry: () => ref.invalidate(historyProvider),
        ),
        data: (result) => result.when(
          failure: (failure) => AppError(
            title: l10n.errorLoadTitle,
            message: failureMessage(failure, l10n),
            retryLabel: l10n.actionRetry,
            onRetry: () => ref.invalidate(historyProvider),
          ),
          success: (items) {
            return CustomScrollView(
              slivers: [
                ..._slivers(context, ref, l10n, items),
                if (items.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: AppEmpty(
                      title: l10n.emptyTitle,
                      body: l10n.historyEmpty,
                      icon: Icons.history_rounded,
                      actionLabel: l10n.progressEmptyCta,
                      onAction: () => context.go(AppRoutes.home),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _slivers(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    List<ActivityItem> items,
  ) {
    final weeklyDays = ref
        .watch(weeklyReportProvider)
        .maybeWhen(
          data: (result) =>
              result.valueOrNull?.weekDays ?? const <WeekDayTime>[],
          orElse: () => const <WeekDayTime>[],
        );
    final chartDays = weeklyDays.length == 7
        ? weeklyDays
        : weekDaysFromHistory(items);

    final groups = <DateTime, List<ActivityItem>>{};
    for (final item in items) {
      final local = item.occurredAt.toLocal();
      final day = DateTime(local.year, local.month, local.day);
      groups.putIfAbsent(day, () => []).add(item);
    }

    final background = Theme.of(context).scaffoldBackgroundColor;
    final slivers = <Widget>[
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: WeekTimeChart(days: chartDays),
        ),
      ),
    ];
    for (final entry in groups.entries) {
      final dayItems = entry.value;
      slivers.add(
        SliverPersistentHeader(
          pinned: true,
          delegate: _DayHeaderDelegate(
            label: activityDayLabel(l10n, entry.key, pattern: 'd MMMM'),
            background: background,
          ),
        ),
      );
      slivers.add(
        SliverList.separated(
          itemCount: dayItems.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            indent: 72,
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.6),
          ),
          itemBuilder: (context, index) {
            final item = dayItems[index];
            final time = DateFormat(
              'HH:mm',
              l10n.localeName,
            ).format(item.occurredAt.toLocal());
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 2,
              ),
              leading: CircleAvatar(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.12),
                foregroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(activityIcon(item), size: 20),
              ),
              title: Text(
                item.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                activityTypeLabel(l10n, item),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              trailing: Text(
                time,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            );
          },
        ),
      );
    }
    return slivers;
  }
}

class _DayHeaderDelegate extends SliverPersistentHeaderDelegate {
  _DayHeaderDelegate({required this.label, required this.background});

  final String label;
  final Color background;

  @override
  double get minExtent => 48;

  @override
  double get maxExtent => 48;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: background,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _DayHeaderDelegate oldDelegate) {
    return oldDelegate.label != label || oldDelegate.background != background;
  }
}
