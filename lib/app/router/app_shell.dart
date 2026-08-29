import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/audio_player/presentation/widgets/mini_player_bar.dart';
import 'package:mindvibe_app/features/tools/presentation/widgets/checkin_prompt.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(children: [navigationShell, const DailyCheckinPrompt()]),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MiniPlayerBar(),
          AppBottomNavigation(
            index: navigationShell.currentIndex,
            onChanged: (index) => navigationShell.goBranch(index),
            homeLabel: l10n.tabHome,
            progressLabel: l10n.tabProgress,
            profileLabel: l10n.tabProfile,
          ),
        ],
      ),
    );
  }
}
