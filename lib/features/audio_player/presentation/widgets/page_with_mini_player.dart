import 'package:flutter/material.dart';
import 'package:mindvibe_app/features/audio_player/presentation/widgets/mini_player_bar.dart';

class PageWithMiniPlayer extends StatelessWidget {
  const PageWithMiniPlayer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: child, bottomNavigationBar: const MiniPlayerBar());
  }
}
