import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindvibe_app/app/router/app_router.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/core/providers/core_providers.dart';
import 'package:mindvibe_app/core/storage/appearance_store.dart';
import 'package:mindvibe_app/core/storage/locale_store.dart';
import 'package:mindvibe_app/features/auth/presentation/providers/session_controller.dart';
import 'package:mindvibe_app/features/auth/presentation/providers/session_state.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class MindVibeApp extends ConsumerStatefulWidget {
  const MindVibeApp({super.key});

  @override
  ConsumerState<MindVibeApp> createState() => _MindVibeAppState();
}

class _MindVibeAppState extends ConsumerState<MindVibeApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(ref.read(sessionControllerProvider.notifier).refreshProfile());
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);
    ref.listen(sessionControllerProvider, (previous, next) {
      final user = next.user;
      if (next.status == SessionStatus.ready && user != null) {
        unawaited(() async {
          await ref.read(localeProvider.notifier).applyFromAccount(user.locale);
          final l10n = lookupAppLocalizations(ref.read(localeProvider));
          await ref
              .read(notificationSchedulerProvider)
              .sync(
                user,
                title: l10n.notificationTitle,
                body: l10n.notificationBody,
              );
        }());
        unawaited(ref.read(analyticsClientProvider).flush());
      }
    });
    ref.watch(appOpenedProvider);
    return MaterialApp.router(
      title: 'MindVibe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ref.watch(appearanceProvider),
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: router,
    );
  }
}

final appOpenedProvider = FutureProvider<void>((ref) {
  return ref.read(analyticsClientProvider).track('app_opened');
});
