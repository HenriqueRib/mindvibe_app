import 'package:mindvibe_app/core/error/result.dart';
import 'package:mindvibe_app/core/network/api_client.dart';
import 'package:mindvibe_app/features/auth/data/models/auth_models.dart';
import 'package:mindvibe_app/features/auth/domain/entities/auth_entities.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._client);

  final ApiClient _client;

  Future<Result<DeviceLookup>> lookupDevice(Map<String, dynamic> body) {
    return _client.post(
      '/auth/device-lookup',
      body: body,
      parse: (data) => deviceLookupFromJson(data as Map<String, dynamic>),
    );
  }

  Future<Result<AuthSession>> login(Map<String, dynamic> body) {
    return _client.post(
      '/auth/login',
      body: body,
      parse: (data) => sessionFromJson(data as Map<String, dynamic>),
    );
  }

  Future<Result<AuthSession>> register(Map<String, dynamic> body) {
    return _client.post(
      '/auth/register',
      body: body,
      parse: (data) => sessionFromJson(data as Map<String, dynamic>),
    );
  }

  Future<Result<void>> forgotPassword(Map<String, dynamic> body) {
    return _client.post('/auth/forgot-password', body: body, parse: (_) {});
  }

  Future<Result<void>> resetPassword(Map<String, dynamic> body) {
    return _client.post('/auth/reset-password', body: body, parse: (_) {});
  }

  Future<Result<void>> logout() {
    return _client.post('/auth/logout', parse: (_) {});
  }

  Future<Result<UserAccount>> fetchMe() {
    return _client.get(
      '/me',
      parse: (data) => userFromJson(data as Map<String, dynamic>),
    );
  }

  Future<Result<UserAccount>> updateProfile(Map<String, dynamic> body) {
    return _client.put(
      '/me',
      body: body,
      parse: (data) => userFromJson(data as Map<String, dynamic>),
    );
  }

  Future<Result<UserAccount>> uploadAvatar(String filePath) {
    return _client.postMultipart(
      '/me/avatar',
      fileField: 'avatar',
      filePath: filePath,
      parse: (data) => userFromJson(data as Map<String, dynamic>),
    );
  }

  Future<Result<UserAccount>> clearAvatar() {
    return _client.delete(
      '/me/avatar',
      parse: (data) => userFromJson(data as Map<String, dynamic>),
    );
  }

  Future<Result<UserAccount>> completeOnboarding(Map<String, dynamic> body) {
    return _client.post(
      '/me/onboarding',
      body: body,
      parse: (data) => userFromJson(data as Map<String, dynamic>),
    );
  }

  Future<Result<void>> disassociateDevice(String uuid) {
    return _client.delete('/me/devices/$uuid', parse: (_) {});
  }

  Future<Result<void>> deleteAccount() {
    return _client.delete('/me', parse: (_) {});
  }
}
