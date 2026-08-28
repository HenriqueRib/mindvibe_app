import 'package:flutter/material.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class SessionAtmosphereView extends StatelessWidget {
  const SessionAtmosphereView.loading({super.key}) : completing = false;

  const SessionAtmosphereView.completing({super.key}) : completing = true;

  final bool completing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppLoading(
      markSize: 112,
      title: l10n.appTagline,
      label: completing
          ? l10n.sessionCompletingTitle
          : l10n.sessionLoadingTitle,
      body: completing ? l10n.sessionCompletingBody : l10n.sessionLoadingBody,
    );
  }
}

class SessionCompletingView extends SessionAtmosphereView {
  const SessionCompletingView({super.key}) : super.completing();
}
