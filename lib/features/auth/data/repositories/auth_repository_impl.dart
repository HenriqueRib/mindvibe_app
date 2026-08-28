import 'package:mindvibe_app/core/error/result.dart';
import 'package:mindvibe_app/core/storage/token_store.dart';
import 'package:mindvibe_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mindvibe_app/features/auth/domain/entities/auth_entities.dart';
import 'package:mindvibe_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required TokenStore tokenStore,
  }) : _remote = remote,
       _tokenStore = tokenStore;

  final AuthRemoteDataSource _remote;
  final TokenStore _tokenStore;

  @override
  Future<Result<DeviceLookup>> lookupDevice({
    required String deviceUuid,
    required String platform,
  }) {
    return _remote.lookupDevice({
      'device_uuid': deviceUuid,
      'platform': platform,
    });
  }

  @override
  Future<Result<AuthSession>> login({
    required String email,
    required String password,
    required String deviceUuid,
    required String platform,
  }) {
    return _authenticate(
      () => _remote.login({
        'email': email,
        'password': password,
        'device_uuid': deviceUuid,
        'platform': platform,
      }),
    );
  }

  @override
  Future<Result<AuthSession>> register({
    required String name,
    required String email,
    required String password,
    required String deviceUuid,
    required String platform,
  }) {
    return _authenticate(
      () => _remote.register({
        'name': name,
        'email': email,
        'password': password,
        'device_uuid': deviceUuid,
        'platform': platform,
      }),
    );
  }

  @override
  Future<Result<void>> forgotPassword({required String email}) {
    return _remote.forgotPassword({'email': email});
  }

  @override
  Future<Result<void>> resetPassword({
    required String email,
    required String token,
    required String password,
  }) {
    return _remote.resetPassword({
      'email': email,
      'token': token,
      'password': password,
    });
  }

  @override
  Future<Result<void>> logout() async {
    final result = await _remote.logout();
    await _tokenStore.clear();
    return result;
  }

  @override
  Future<Result<UserAccount>> fetchMe() => _remote.fetchMe();

  @override
  Future<Result<UserAccount>> updateProfile({
    String? name,
    String? timezone,
    String? locale,
    bool? notificationEnabled,
    String? notificationTime,
    String? avatarEmoji,
    bool? showInRanking,
  }) {
    return _remote.updateProfile({
      'name': ?name,
      'timezone': ?timezone,
      'locale': ?locale,
      'notification_enabled': ?notificationEnabled,
      'notification_time': ?notificationTime,
      'avatar_emoji': ?avatarEmoji,
      'show_in_ranking': ?showInRanking,
    });
  }

  @override
  Future<Result<UserAccount>> uploadAvatar({required String filePath}) {
    return _remote.uploadAvatar(filePath);
  }

  @override
  Future<Result<UserAccount>> clearAvatar() {
    return _remote.clearAvatar();
  }

  @override
  Future<Result<UserAccount>> completeOnboarding({
    required String goal,
    required String experienceLevel,
    required bool notificationEnabled,
    String? notificationTime,
  }) {
    return _remote.completeOnboarding({
      'goal': goal,
      'experience_level': experienceLevel,
      'notification_enabled': notificationEnabled,
      'notification_time': ?notificationTime,
    });
  }

  @override
  Future<Result<void>> disassociateDevice(String uuid) {
    return _remote.disassociateDevice(uuid);
  }

  @override
  Future<Result<void>> deleteAccount() async {
    final result = await _remote.deleteAccount();
    await _tokenStore.clear();
    return result;
  }

  Future<Result<AuthSession>> _authenticate(
    Future<Result<AuthSession>> Function() action,
  ) async {
    final result = await action();
    final session = result.valueOrNull;
    if (session != null) {
      await _tokenStore.write(session.token);
    }
    return result;
  }
}
