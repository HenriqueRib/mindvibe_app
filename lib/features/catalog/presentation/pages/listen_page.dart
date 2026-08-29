import 'package:flutter/material.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/audio_player/presentation/providers/now_playing_controller.dart';
import 'package:mindvibe_app/features/audio_player/presentation/widgets/session_audio_player.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class ListenLaunch {
  const ListenLaunch({required this.moment, this.queue = const []});

  final ListenMoment moment;
  final List<ListenMoment> queue;
}

NowPlayingTrack? trackFromMoment(ListenMoment moment) {
  final url = moment.url;
  if (url == null || url.isEmpty) {
    return null;
  }
  return NowPlayingTrack(
    id: listenTrackId(moment),
    url: url,
    title: moment.title,
    coverUrl: moment.coverUrl,
    subtitle: moment.categoryName,
    audioId: moment.id,
    countsForProgress: true,
  );
}

String listenTrackId(ListenMoment moment) => '${moment.url}|${moment.title}';

class ListenPage extends StatelessWidget {
  const ListenPage({super.key, required this.moment, this.queue = const []});

  final ListenMoment moment;
  final List<ListenMoment> queue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final url = moment.url;
    final tracks = queue
        .map(trackFromMoment)
        .whereType<NowPlayingTrack>()
        .toList();

    return AppScaffold(
      showBack: true,
      title: moment.categoryName,
      body: url == null || url.isEmpty
          ? AppEmpty(
              title: l10n.libraryAudiosEmpty,
              body: l10n.emptyBody,
              icon: Icons.headset_off_outlined,
              actionLabel: l10n.actionBack,
              onAction: () => Navigator.of(context).maybePop(),
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
                        url: url,
                        title: moment.title,
                        coverUrl: moment.coverUrl,
                        subtitle: moment.categoryName,
                        audioId: moment.id,
                        countsForProgress: true,
                        queue: tracks,
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
