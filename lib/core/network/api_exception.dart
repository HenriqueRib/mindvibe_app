import 'package:dio/dio.dart';
import 'package:mindvibe_app/core/error/app_failure.dart';

class ApiException implements Exception {
  const ApiException(this.failure);
  final AppFailure failure;
}

AppFailure mapDioException(DioException error) {
  if (error.type == DioExceptionType.connectionError ||
      error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.receiveTimeout ||
      error.type == DioExceptionType.sendTimeout) {
    return const AppFailure(type: AppFailureType.offline);
  }

  final status = error.response?.statusCode;
  final data = error.response?.data;
  final message = _readMessage(data);
  final code = _readCode(data);
  final maskedEmail = _readString(data, 'masked_email');
  final fieldErrors = _readFieldErrors(data);

  if (status == 401) {
    return AppFailure(
      type: AppFailureType.unauthorized,
      apiMessage: message,
      statusCode: status,
    );
  }

  if (status == 409 || code == 'DEVICE_HAS_ACCOUNT') {
    return AppFailure(
      type: code == 'DEVICE_HAS_ACCOUNT'
          ? AppFailureType.deviceHasAccount
          : AppFailureType.conflict,
      apiMessage: message,
      errorCode: code,
      maskedEmail: maskedEmail,
      statusCode: status,
    );
  }

  if (status == 404) {
    return AppFailure(
      type: AppFailureType.notFound,
      apiMessage: message,
      errorCode: code,
      statusCode: status,
    );
  }

  if (status == 422) {
    return AppFailure(
      type: AppFailureType.validation,
      apiMessage: message,
      errorCode: code,
      fieldErrors: fieldErrors,
      statusCode: status,
    );
  }

  if (status != null && status >= 500) {
    return AppFailure(
      type: AppFailureType.server,
      apiMessage: message,
      statusCode: status,
    );
  }

  return AppFailure(
    type: AppFailureType.unknown,
    apiMessage: message,
    errorCode: code,
    fieldErrors: fieldErrors,
    statusCode: status,
  );
}

String? _readMessage(dynamic data) {
  if (data is Map && data['message'] is String) {
    return data['message'] as String;
  }
  return null;
}

String? _readCode(dynamic data) {
  if (data is! Map) {
    return null;
  }
  final code = data['code'];
  if (code is String) {
    return code;
  }
  final errors = data['errors'];
  if (errors is Map &&
      errors['code'] is List &&
      (errors['code'] as List).isNotEmpty) {
    return (errors['code'] as List).first.toString();
  }
  return null;
}

String? _readString(dynamic data, String key) {
  if (data is Map && data[key] is String) {
    return data[key] as String;
  }
  return null;
}

Map<String, List<String>> _readFieldErrors(dynamic data) {
  if (data is! Map || data['errors'] is! Map) {
    return const {};
  }
  final raw = data['errors'] as Map;
  return raw.map((key, value) {
    if (value is List) {
      return MapEntry(
        key.toString(),
        value.map((item) => item.toString()).toList(),
      );
    }
    return MapEntry(key.toString(), [value.toString()]);
  });
}
