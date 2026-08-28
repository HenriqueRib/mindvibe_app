import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mindvibe_app/core/config/app_config.dart';
import 'package:mindvibe_app/core/error/app_failure.dart';
import 'package:mindvibe_app/core/error/result.dart';
import 'package:mindvibe_app/core/network/api_exception.dart';
import 'package:mindvibe_app/core/storage/token_store.dart';

class ApiClient {
  ApiClient({
    required TokenStore tokenStore,
    String? baseUrl,
    Dio? dio,
    VoidCallback? onUnauthorized,
  }) : _tokenStore = tokenStore,
       _onUnauthorized = onUnauthorized,
       _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: baseUrl ?? AppConfig.apiUrl,
               connectTimeout: const Duration(seconds: 20),
               receiveTimeout: const Duration(seconds: 20),
               headers: const {
                 'Accept': 'application/json',
                 'Content-Type': 'application/json',
               },
             ),
           ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStore.read();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          if (options.data is FormData) {
            options.headers.remove('Content-Type');
          }
          handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            _onUnauthorized?.call();
          }
          handler.next(error);
        },
      ),
    );
  }

  final Dio _dio;
  final TokenStore _tokenStore;
  final VoidCallback? _onUnauthorized;

  Future<Result<T>> get<T>(
    String path, {
    required T Function(dynamic data) parse,
    Map<String, dynamic>? query,
  }) {
    return _send(() => _dio.get<dynamic>(path, queryParameters: query), parse);
  }

  Future<Result<T>> post<T>(
    String path, {
    required T Function(dynamic data) parse,
    Object? body,
  }) {
    return _send(() => _dio.post<dynamic>(path, data: body), parse);
  }

  Future<Result<T>> postMultipart<T>(
    String path, {
    required T Function(dynamic data) parse,
    required String fileField,
    required String filePath,
  }) {
    return _send(() async {
      final form = FormData.fromMap({
        fileField: await MultipartFile.fromFile(filePath),
      });
      return _dio.post<dynamic>(path, data: form);
    }, parse);
  }

  Future<Result<T>> put<T>(
    String path, {
    required T Function(dynamic data) parse,
    Object? body,
  }) {
    return _send(() => _dio.put<dynamic>(path, data: body), parse);
  }

  Future<Result<T>> delete<T>(
    String path, {
    required T Function(dynamic data) parse,
  }) {
    return _send(() => _dio.delete<dynamic>(path), parse);
  }

  Future<Result<T>> _send<T>(
    Future<Response<dynamic>> Function() request,
    T Function(dynamic data) parse,
  ) async {
    try {
      final response = await request();
      return Success(parse(_unwrap(response.data)));
    } on DioException catch (error) {
      return Failure(mapDioException(error));
    } catch (_) {
      return const Failure(AppFailure(type: AppFailureType.unknown));
    }
  }

  dynamic _unwrap(dynamic body) {
    if (body is Map && body.containsKey('data')) {
      return body['data'];
    }
    return body;
  }
}
