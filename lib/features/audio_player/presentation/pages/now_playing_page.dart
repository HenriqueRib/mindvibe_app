import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/audio_player/presentation/providers/now_playing_controller.dart';
import 'package:mindvibe_app/features/audio_player/presentation/widgets/session_audio_player.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class NowPlayingPage extends ConsumerWidget {
  const NowPlayingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final playing = ref.watch(nowPlayingProvider);
    final track = playing.track;
    final night = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      showBack: true,
      title: track?.subtitle ?? l10n.playerNowPlaying,
      backgroundColor: night ? AppColors.nightBackground : null,
      body: track == null
          ? Column(
              children: [
                const Spacer(),
                AppEmpty(title: l10n.emptyTitle),
                const Spacer(),
                AppButton(
                  label: l10n.actionBack,
                  variant: AppButtonVariant.secondary,
                  onPressed: () => context.pop(),
                ),
              ],
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Center(
                      child: SessionAudioPlayer(
                        key: ValueKey(track.id),
                        url: track.url,
                        title: track.title,
                        coverUrl: track.coverUrl,
                        subtitle: track.subtitle,
                        audioId: track.audioId,
                        countsForProgress: track.countsForProgress,
                        queue: playing.queue,
                        followNowPlaying: true,
                        onCompleted: () {},
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
