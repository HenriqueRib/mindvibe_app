import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/core/storage/favorite_store.dart';
import 'package:mindvibe_app/features/audio_player/presentation/widgets/cover_image.dart';
import 'package:mindvibe_app/features/catalog/domain/audio_category.dart';
import 'package:mindvibe_app/features/catalog/presentation/pages/listen_page.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class MomentsPage extends ConsumerStatefulWidget {
  const MomentsPage({super.key, this.categorySlug});

  final String? categorySlug;

  @override
  ConsumerState<MomentsPage> createState() => _MomentsPageState();
}

class _MomentsPageState extends ConsumerState<MomentsPage> {
  late String? _filter = widget.categorySlug;
  var _searching = false;
  var _query = '';

  @override
  void didUpdateWidget(covariant MomentsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.categorySlug != widget.categorySlug) {
      _filter = widget.categorySlug;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final moments = ref.watch(momentsProvider);
    final favorites = ref.watch(favoriteTracksProvider);

    return AppScaffold(
      showBack: true,
      title: _title(l10n, moments.asData?.value.valueOrNull ?? const []),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      actions: [
        IconButton(
          tooltip: l10n.librarySearch,
          onPressed: () => setState(() {
            _searching = !_searching;
            if (!_searching) {
              _query = '';
            }
          }),
          icon: Icon(_searching ? Icons.close_rounded : Icons.search_rounded),
        ),
      ],
      body: moments.when(
        loading: () => AppLoading(label: l10n.loadingLabel),
        error: (_, _) => AppError(
          title: l10n.errorLoadTitle,
          message: l10n.errorGeneric,
          retryLabel: l10n.actionRetry,
          onRetry: () => ref.invalidate(momentsProvider),
        ),
        data: (result) => result.when(
          failure: (failure) => AppError(
            title: l10n.errorLoadTitle,
            message: failureMessage(failure, l10n),
            retryLabel: l10n.actionRetry,
            onRetry: () => ref.invalidate(momentsProvider),
          ),
          success: (items) {
            if (items.isEmpty) {
              return AppEmpty(
                title: l10n.libraryAudiosEmpty,
                body: l10n.emptyBody,
                icon: Icons.headset_off_outlined,
              );
            }
            final ordered = [...items]
              ..sort((a, b) {
                final byCategory = a.categorySortOrder.compareTo(
                  b.categorySortOrder,
                );
                if (byCategory != 0) {
                  return byCategory;
                }
                final byName = a.categoryName.compareTo(b.categoryName);
                if (byName != 0) {
                  return byName;
                }
                return a.title.compareTo(b.title);
              });
            final chips = _chips(l10n, items);
            final filtered = ordered.where((item) {
              if (_filter != null && item.categorySlug != _filter) {
                return false;
              }
              if (_query.trim().isEmpty) {
                return true;
              }
              final needle = _query.trim().toLowerCase();
              return item.title.toLowerCase().contains(needle) ||
                  audioCategoryLabel(
                    l10n,
                    item.categorySlug,
                    item.categoryName,
                  ).toLowerCase().contains(needle);
            }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _chipBar(l10n, chips),
                if (_searching) ...[
                  const SizedBox(height: 8),
                  TextField(
                    autofocus: true,
                    onChanged: (value) => setState(() => _query = value),
                    decoration: InputDecoration(
                      hintText: l10n.librarySearchHint,
                      prefixIcon: const Icon(Icons.search_rounded),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                if (filtered.isEmpty)
                  Expanded(
                    child: AppEmpty(
                      title: l10n.libraryAudiosEmpty,
                      body: l10n.emptyBody,
                      icon: Icons.headset_off_outlined,
                    ),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final moment = filtered[index];
                        return FadeSlideIn(
                          index: index.clamp(0, 8),
                          child: _AudioCard(
                            moment: moment,
                            favorited: favorites.contains(
                              listenTrackId(moment),
                            ),
                            onPlay: () => context.push(
                              AppRoutes.listen,
                              extra: ListenLaunch(
                                moment: moment,
                                queue: filtered,
                              ),
                            ),
                            onFavorite: () => ref
                                .read(favoriteTracksProvider.notifier)
                                .toggle(listenTrackId(moment)),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _title(AppLocalizations l10n, List<ListenMoment> items) {
    if (_filter == null) {
      return l10n.libraryAudiosTitle;
    }
    final match = items.where((item) => item.categorySlug == _filter);
    final fallback = match.isEmpty ? _filter! : match.first.categoryName;
    return audioCategoryLabel(l10n, _filter!, fallback);
  }

  List<(String?, String, IconData)> _chips(
    AppLocalizations l10n,
    List<ListenMoment> items,
  ) {
    return [
      (null, l10n.homeNowAll, Icons.grid_view_rounded),
      for (final category in uniqueAudioCategories(items))
        (
          category.slug,
          audioCategoryLabel(l10n, category.slug, category.name),
          audioCategoryIcon(category.slug),
        ),
    ];
  }

  Widget _chipBar(
    AppLocalizations l10n,
    List<(String?, String, IconData)> chips,
  ) {
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < chips.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            _CategoryChip(
              label: chips[i].$2,
              icon: chips[i].$3,
              selected: _filter == chips[i].$1,
              selectedColor: scheme.secondary,
              selectedForeground: scheme.onSecondary,
              unselectedColor: scheme.surface,
              unselectedForeground: scheme.onSurface,
              borderColor: scheme.outline,
              onTap: () => setState(() => _filter = chips[i].$1),
            ),
          ],
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.selectedColor,
    required this.selectedForeground,
    required this.unselectedColor,
    required this.unselectedForeground,
    required this.borderColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final Color selectedColor;
  final Color selectedForeground;
  final Color unselectedColor;
  final Color unselectedForeground;
  final Color borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? selectedForeground : unselectedForeground;
    return Material(
      color: selected ? selectedColor : unselectedColor,
      shape: StadiumBorder(
        side: BorderSide(color: selected ? selectedColor : borderColor),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Row(
            children: [
              Icon(icon, size: 16, color: foreground),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: foreground,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AudioCard extends StatelessWidget {
  const _AudioCard({
    required this.moment,
    required this.favorited,
    required this.onPlay,
    required this.onFavorite,
  });

  final ListenMoment moment;
  final bool favorited;
  final VoidCallback onPlay;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final minutes = ((moment.durationSeconds ?? 0) / 60).round();
    final category = audioCategoryLabel(
      l10n,
      moment.categorySlug,
      moment.categoryName,
    );
    final duration = minutes <= 0
        ? category
        : '$category · ${l10n.exerciseDurationMinutes(minutes)}';

    return AppCard(
      padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
      onTap: onPlay,
      child: Row(
        children: [
          CoverImage(
            url: moment.coverUrl,
            size: 76,
            radius: 16,
            icon: audioCategoryIcon(moment.categorySlug),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  moment.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  duration,
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: favorited ? l10n.playerFavorited : l10n.playerFavorite,
            onPressed: onFavorite,
            icon: Icon(
              favorited
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: favorited ? scheme.secondary : scheme.onSurfaceVariant,
            ),
          ),
          Material(
            color: scheme.secondary,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onPlay,
              customBorder: const CircleBorder(),
              child: Semantics(
                button: true,
                label: l10n.playerPlay,
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: scheme.onSecondary,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
