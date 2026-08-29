import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/core/error/result.dart';
import 'package:mindvibe_app/features/audio_player/presentation/widgets/cover_image.dart';
import 'package:mindvibe_app/features/auth/domain/entities/auth_entities.dart';
import 'package:mindvibe_app/features/auth/presentation/providers/session_controller.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class RankingPage extends ConsumerStatefulWidget {
  const RankingPage({super.key});

  @override
  ConsumerState<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends ConsumerState<RankingPage> {
  String _period = 'all';
  bool _saving = false;

  Future<void> _setOptIn(bool value) async {
    setState(() => _saving = true);
    final result = await ref
        .read(sessionControllerProvider.notifier)
        .updateProfile(showInRanking: value);
    if (!mounted) {
      return;
    }
    setState(() => _saving = false);
    final l10n = AppLocalizations.of(context);
    if (result is Failure<UserAccount>) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failureMessage(result.error, l10n))),
      );
      return;
    }
    ref.invalidate(rankingProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ranking = ref.watch(rankingProvider(_period));

    return AppScaffold(
      showBack: true,
      title: l10n.rankingTitle,
      body: ranking.when(
        loading: () => AppLoading(label: l10n.loadingLabel),
        error: (_, _) => AppError(
          title: l10n.errorLoadTitle,
          message: l10n.errorGeneric,
          retryLabel: l10n.actionRetry,
          onRetry: () => ref.invalidate(rankingProvider(_period)),
        ),
        data: (result) => result.when(
          failure: (failure) => AppError(
            title: l10n.errorLoadTitle,
            message: failureMessage(failure, l10n),
            retryLabel: l10n.actionRetry,
            onRetry: () => ref.invalidate(rankingProvider(_period)),
          ),
          success: (snapshot) => ListView(
            children: [
              SegmentedButton<String>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: 'all',
                    label: Text(l10n.rankingPeriodAll),
                  ),
                  ButtonSegment(
                    value: 'weekly',
                    label: Text(l10n.rankingPeriodWeekly),
                  ),
                ],
                selected: {_period},
                onSelectionChanged: (selected) {
                  setState(() => _period = selected.first);
                },
              ),
              const SizedBox(height: 12),
              AppText.subtitle(l10n.rankingPlayers(snapshot.totalPlayers)),
              const SizedBox(height: 16),
              if (!snapshot.optedIn)
                _OptInCard(
                  l10n: l10n,
                  me: snapshot.me,
                  saving: _saving,
                  onJoin: () => _setOptIn(true),
                )
              else if (snapshot.me != null) ...[
                _MeCard(l10n: l10n, me: snapshot.me!),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: _saving ? null : () => _setOptIn(false),
                    child: Text(l10n.rankingOptOut),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              if (snapshot.entries.isEmpty)
                AppEmpty(
                  title: l10n.emptyTitle,
                  body: l10n.rankingEmpty,
                  icon: Icons.emoji_events_outlined,
                )
              else
                for (final entry in snapshot.entries) ...[
                  _EntryCard(l10n: l10n, entry: entry),
                  const SizedBox(height: 10),
                ],
            ],
          ),
        ),
      ),
    );
  }
}

class _OptInCard extends StatelessWidget {
  const _OptInCard({
    required this.l10n,
    required this.me,
    required this.saving,
    required this.onJoin,
  });

  final AppLocalizations l10n;
  final RankingPerson? me;
  final bool saving;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.rankingOptInTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.rankingOptInBody,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),
              AppButton(
                label: l10n.rankingOptInCta,
                onPressed: saving ? null : onJoin,
              ),
            ],
          ),
        ),
        if (me != null) ...[
          const SizedBox(height: 12),
          AppCard(
            child: Row(
              children: [
                _RankingAvatar(
                  name: me!.displayName,
                  avatarUrl: me!.avatarUrl,
                  avatarEmoji: me!.avatarEmoji,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.rankingUnranked,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _rankingStats(l10n, me!),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 8),
      ],
    );
  }
}

class _MeCard extends StatelessWidget {
  const _MeCard({required this.l10n, required this.me});

  final AppLocalizations l10n;
  final RankingPerson me;

  @override
  Widget build(BuildContext context) {
    final rank = me.rank;
    return AppCard(
      child: Row(
        children: [
          _RankingAvatar(
            name: me.displayName,
            avatarUrl: me.avatarUrl,
            avatarEmoji: me.avatarEmoji,
            size: 56,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.rankingYourPlace,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  rank == null ? l10n.rankingUnranked : l10n.rankingRank(rank),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _rankingStats(l10n, me),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.l10n, required this.entry});

  final AppLocalizations l10n;
  final RankingEntry entry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        border: entry.isMe
            ? Border.all(color: scheme.secondary, width: 1.5)
            : null,
      ),
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            SizedBox(
              width: 36,
              child: Text(
                entry.rank == null ? '—' : '${entry.rank}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: entry.isMe ? scheme.secondary : scheme.onSurface,
                ),
              ),
            ),
            _RankingAvatar(
              name: entry.displayName,
              avatarUrl: entry.avatarUrl,
              avatarEmoji: entry.avatarEmoji,
              size: 44,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.isMe ? l10n.rankingYou : entry.displayName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  if (entry.levelName != null)
                    Text(
                      entry.levelName!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  l10n.rankingXp(entry.xp),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatRankingTime(l10n, entry.seconds),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RankingAvatar extends StatelessWidget {
  const _RankingAvatar({
    required this.name,
    this.avatarUrl,
    this.avatarEmoji,
    this.size = 48,
  });

  final String name;
  final String? avatarUrl;
  final String? avatarEmoji;
  final double size;

  @override
  Widget build(BuildContext context) {
    final trimmed = name.trim();
    final initial = trimmed.isEmpty
        ? '?'
        : trimmed.characters.first.toUpperCase();

    Widget child;
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      child = CoverImage(
        url: avatarUrl,
        size: size,
        radius: size / 2,
        icon: Icons.person,
      );
    } else if (avatarEmoji != null && avatarEmoji!.isNotEmpty) {
      child = ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Center(
          child: Text(avatarEmoji!, style: TextStyle(fontSize: size * 0.42)),
        ),
      );
    } else {
      child = ColoredBox(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
        child: Center(
          child: Text(
            initial,
            style: TextStyle(
              fontSize: size * 0.38,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      );
    }

    return ClipOval(
      child: SizedBox(width: size, height: size, child: child),
    );
  }
}

String _rankingStats(AppLocalizations l10n, RankingPerson person) {
  final xp = l10n.rankingXp(person.xp);
  final time = _formatRankingTime(l10n, person.seconds);
  final level = person.levelName;
  if (level == null || level.isEmpty) {
    return '$xp · $time';
  }
  return '$xp · $time · $level';
}

String _formatRankingTime(AppLocalizations l10n, int totalSeconds) {
  if (totalSeconds < 60) {
    return l10n.progressTimeUnderMinute;
  }
  final hours = totalSeconds ~/ 3600;
  final minutes = (totalSeconds % 3600) ~/ 60;
  if (hours == 0) {
    return l10n.progressTimeCompactMinutes(minutes);
  }
  return l10n.progressTimeCompactHours(hours, minutes);
}
