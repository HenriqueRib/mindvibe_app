import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/audio_player/presentation/providers/now_playing_controller.dart';
import 'package:mindvibe_app/features/audio_player/presentation/widgets/cover_image.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class MiniPlayerBar extends ConsumerWidget {
  const MiniPlayerBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playing = ref.watch(nowPlayingProvider);
    final track = playing.track;
    final path = GoRouterState.of(context).uri.path;
    final expanded = path == AppRoutes.listen || path == AppRoutes.nowPlaying;
    if (track == null || expanded) {
      return const AnimatedSize(
        duration: Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        child: SizedBox.shrink(),
      );
    }
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final progress = playing.duration.inMilliseconds == 0
        ? 0.0
        : playing.position.inMilliseconds / playing.duration.inMilliseconds;

    return AnimatedSize(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      child: FadeSlideIn(
        duration: const Duration(milliseconds: 320),
        offset: 10,
        child: Material(
          color: scheme.surface,
          elevation: 8,
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(
                  value: progress.clamp(0, 1),
                  minHeight: 2,
                  backgroundColor: scheme.outline.withValues(alpha: 0.3),
                  color: AppColors.primarySoft,
                ),
                ListTile(
                  dense: true,
                  onTap: () => context.push(AppRoutes.nowPlaying),
                  contentPadding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
                  leading: CoverImage(
                    url: track.coverUrl,
                    size: 44,
                    radius: 10,
                  ),
                  title: Text(
                    track.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    track.subtitle ?? l10n.playerNowPlaying,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: playing.ui == AudioPlayerUiState.playing
                            ? l10n.playerPause
                            : l10n.playerPlay,
                        onPressed: () =>
                            ref.read(nowPlayingProvider.notifier).toggle(),
                        icon: playing.ui == AudioPlayerUiState.loading
                            ? const AppLoading.compact()
                            : Icon(
                                playing.ui == AudioPlayerUiState.playing
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                              ),
                      ),
                      IconButton(
                        tooltip: l10n.playerNext,
                        onPressed: playing.hasNext
                            ? () => ref
                                  .read(nowPlayingProvider.notifier)
                                  .playNext()
                            : null,
                        icon: const Icon(Icons.skip_next_rounded),
                      ),
                      IconButton(
                        onPressed: () =>
                            ref.read(nowPlayingProvider.notifier).stop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
