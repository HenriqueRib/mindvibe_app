import 'package:mindvibe_app/core/error/result.dart';
import 'package:mindvibe_app/features/auth/domain/entities/auth_entities.dart';

abstract class AuthRepository {
  Future<Result<DeviceLookup>> lookupDevice({
    required String deviceUuid,
    required String platform,
  });

  Future<Result<AuthSession>> login({
    required String email,
    required String password,
    required String deviceUuid,
    required String platform,
  });

  Future<Result<AuthSession>> register({
    required String name,
    required String email,
    required String password,
    required String deviceUuid,
    required String platform,
  });

  Future<Result<void>> forgotPassword({required String email});

  Future<Result<void>> resetPassword({
    required String email,
    required String token,
    required String password,
  });

  Future<Result<void>> logout();

  Future<Result<UserAccount>> fetchMe();

  Future<Result<UserAccount>> updateProfile({
    String? name,
    String? timezone,
    String? locale,
    bool? notificationEnabled,
    String? notificationTime,
    String? avatarEmoji,
    bool? showInRanking,
  });

  Future<Result<UserAccount>> uploadAvatar({required String filePath});

  Future<Result<UserAccount>> clearAvatar();

  Future<Result<UserAccount>> completeOnboarding({
    required String goal,
    required String experienceLevel,
    required bool notificationEnabled,
    String? notificationTime,
  });

  Future<Result<void>> disassociateDevice(String uuid);

  Future<Result<void>> deleteAccount();
}
