import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/features/audio_player/presentation/widgets/cover_image.dart';
import 'package:mindvibe_app/features/catalog/domain/audio_category.dart';
import 'package:mindvibe_app/features/catalog/presentation/pages/listen_page.dart';
import 'package:mindvibe_app/features/home/presentation/home_actions.dart';
import 'package:mindvibe_app/features/tools/presentation/providers/day_close_controller.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class DayClosePage extends ConsumerStatefulWidget {
  const DayClosePage({super.key});

  @override
  ConsumerState<DayClosePage> createState() => _DayClosePageState();
}

class _DayClosePageState extends ConsumerState<DayClosePage> {
  final _kept = TextEditingController();
  final _released = TextEditingController();
  var _filled = false;

  @override
  void dispose() {
    _kept.dispose();
    _released.dispose();
    super.dispose();
  }

  void _fill(DayCloseEntry? today) {
    if (_filled) {
      return;
    }
    _filled = true;
    if (today == null) {
      return;
    }
    _kept.text = today.kept;
    _released.text = today.released;
  }

  bool get _hasContent =>
      _kept.text.trim().isNotEmpty || _released.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(dayCloseControllerProvider);
    final runner = ref.read(dayCloseControllerProvider.notifier);

    ref.listen(dayCloseControllerProvider, (previous, next) {
      if (previous?.loading == true && !next.loading) {
        _fill(next.snapshot.today);
      }
    });

    return AppScaffold(
      showBack: true,
      title: l10n.dayCloseTitle,
      body: state.loading
          ? AppLoading(label: l10n.loadingLabel)
          : ListView(
              children: [
                AppText.subtitle(l10n.dayCloseHint, align: TextAlign.center),
                const SizedBox(height: 24),
                TextField(
                  controller: _kept,
                  maxLength: 160,
                  maxLines: 2,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: l10n.dayCloseKept,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _released,
                  maxLength: 160,
                  maxLines: 2,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: l10n.dayCloseReleased,
                  ),
                ),
                const SizedBox(height: 20),
                if (state.failure != null) ...[
                  AppInlineError(message: failureMessage(state.failure!, l10n)),
                  const SizedBox(height: 12),
                ],
                AppButton(
                  label: state.saved ? l10n.dayCloseUpdate : l10n.dayCloseSave,
                  loading: state.saving,
                  onPressed: !_hasContent || state.saving
                      ? null
                      : () => runner.save(
                          kept: _kept.text,
                          released: _released.text,
                        ),
                ),
                const SizedBox(height: 12),
                Text(
                  state.saved ? l10n.dayCloseSaved : l10n.dayClosePrivate,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                if (state.snapshot.audio != null) ...[
                  const SizedBox(height: 24),
                  Text(
                    l10n.dayCloseAudio,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _AudioCard(
                    moment: state.snapshot.audio!,
                    playLabel: l10n.dayClosePlay,
                    onPlay: () {
                      HapticFeedback.selectionClick();
                      context.push(
                        AppRoutes.listen,
                        extra: ListenLaunch(
                          moment: state.snapshot.audio!,
                          queue: [state.snapshot.audio!],
                        ),
                      );
                    },
                  ),
                ],
                if (state.snapshot.days.isNotEmpty) ...[
                  const SizedBox(height: 28),
                  Text(
                    l10n.dayCloseWeek,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _WeekDots(days: state.snapshot.days, l10n: l10n),
                ],
                const SizedBox(height: 12),
              ],
            ),
    );
  }
}

class _AudioCard extends StatelessWidget {
  const _AudioCard({
    required this.moment,
    required this.playLabel,
    required this.onPlay,
  });

  final ListenMoment moment;
  final String playLabel;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final seconds = moment.durationSeconds ?? 0;
    return AppCard(
      onTap: onPlay,
      child: Row(
        children: [
          CoverImage(
            url: moment.coverUrl,
            size: 56,
            radius: 12,
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
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  seconds > 0 ? compactDuration(seconds) : playLabel,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.play_arrow_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _WeekDots extends StatelessWidget {
  const _WeekDots({required this.days, required this.l10n});

  final List<DayCloseDay> days;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final points = days.length == 7 ? days : const <DayCloseDay>[];
    if (points.isEmpty) {
      return const SizedBox.shrink();
    }
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;

    return Row(
      children: [
        for (final day in points)
          Expanded(
            child: _Dot(
              day: day,
              locale: l10n.localeName,
              onSurface: onSurface,
              muted: muted,
            ),
          ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({
    required this.day,
    required this.locale,
    required this.onSurface,
    required this.muted,
  });

  final DayCloseDay day;
  final String locale;
  final Color onSurface;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final scheme = Theme.of(context).colorScheme;
    final isToday =
        day.date.year == now.year &&
        day.date.month == now.month &&
        day.date.day == now.day;
    final raw = DateFormat('E', locale).format(day.date).replaceAll('.', '');
    final short = raw.isEmpty
        ? ''
        : (raw.length <= 3 ? raw : raw.substring(0, 3));
    final label = short.isEmpty
        ? ''
        : '${short[0].toUpperCase()}${short.substring(1).toLowerCase()}';

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: day.closed ? 16 : 10,
          height: day.closed ? 16 : 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: day.closed ? scheme.primary : Colors.transparent,
            border: Border.all(
              color: day.closed ? scheme.primary : scheme.outline,
              width: isToday ? 2 : 1.4,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
            color: isToday ? onSurface : muted,
          ),
        ),
      ],
    );
  }
}
