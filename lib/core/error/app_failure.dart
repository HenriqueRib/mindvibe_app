enum AppFailureType {
  offline,
  unauthorized,
  notFound,
  validation,
  conflict,
  deviceHasAccount,
  server,
  unknown,
}

class AppFailure implements Exception {
  const AppFailure({
    required this.type,
    this.apiMessage,
    this.errorCode,
    this.maskedEmail,
    this.fieldErrors = const {},
    this.statusCode,
  });

  final AppFailureType type;
  final String? apiMessage;
  final String? errorCode;
  final String? maskedEmail;
  final Map<String, List<String>> fieldErrors;
  final int? statusCode;

  bool get isDeviceHasAccount =>
      type == AppFailureType.deviceHasAccount ||
      errorCode == 'DEVICE_HAS_ACCOUNT';

  bool get isNoActiveProgram => errorCode == 'NO_ACTIVE_PROGRAM';

  bool get isContentAccessDenied => errorCode == 'CONTENT_ACCESS_DENIED';

  bool get isProgramAlreadyActive => errorCode == 'PROGRAM_ALREADY_ACTIVE';

  @override
  String toString() => apiMessage ?? errorCode ?? type.name;
}
