import 'package:mindvibe_app/core/error/app_failure.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

String failureMessage(AppFailure failure, AppLocalizations l10n) {
  final api = failure.apiMessage;
  if (api != null && api.trim().isNotEmpty) {
    return api;
  }
  return switch (failure.type) {
    AppFailureType.offline => l10n.errorOffline,
    AppFailureType.unauthorized => l10n.errorUnauthorized,
    AppFailureType.notFound => l10n.errorNotFound,
    AppFailureType.server => l10n.errorServer,
    AppFailureType.deviceHasAccount => l10n.deviceAssociatedTitle,
    AppFailureType.validation ||
    AppFailureType.conflict ||
    AppFailureType.unknown => l10n.errorGeneric,
  };
}
