import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindvibe_app/core/device/device_id_store.dart';
import 'package:mindvibe_app/core/error/app_failure.dart';
import 'package:mindvibe_app/core/error/result.dart';
import 'package:mindvibe_app/core/providers/core_providers.dart';
import 'package:mindvibe_app/core/storage/remembered_account_store.dart';
import 'package:mindvibe_app/core/storage/token_store.dart';
import 'package:mindvibe_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mindvibe_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mindvibe_app/features/auth/domain/entities/auth_entities.dart';
import 'package:mindvibe_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mindvibe_app/features/auth/presentation/providers/session_state.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remote: AuthRemoteDataSource(ref.watch(apiClientProvider)),
    tokenStore: ref.watch(tokenStoreProvider),
  );
});

final sessionControllerProvider =
    StateNotifierProvider<SessionController, SessionState>((ref) {
      final controller = SessionController(
        authRepository: ref.watch(authRepositoryProvider),
        tokenStore: ref.watch(tokenStoreProvider),
        deviceIdStore: ref.watch(deviceIdStoreProvider),
        rememberedAccountStore: ref.watch(rememberedAccountStoreProvider),
      );
      ref.watch(unauthorizedSignalProvider).bind(controller.onUnauthorized);
      return controller;
    });

class SessionController extends StateNotifier<SessionState> {
  SessionController({
    required AuthRepository authRepository,
    required TokenStore tokenStore,
    required DeviceIdStore deviceIdStore,
    required RememberedAccountStore rememberedAccountStore,
  }) : _auth = authRepository,
       _tokenStore = tokenStore,
       _deviceIdStore = deviceIdStore,
       _rememberedAccount = rememberedAccountStore,
       super(const SessionState(status: SessionStatus.loading)) {
    unawaited(bootstrap());
  }

  final AuthRepository _auth;
  final TokenStore _tokenStore;
  final DeviceIdStore _deviceIdStore;
  final RememberedAccountStore _rememberedAccount;

  Future<String> deviceUuid() => _deviceIdStore.getOrCreate();

  Future<void> bootstrap() async {
    state = const SessionState(status: SessionStatus.loading);
    final token = await _tokenStore.read();
    if (token != null && token.isNotEmpty) {
      final me = await _auth.fetchMe();
      final user = me.valueOrNull;
      if (user != null) {
        _setAuthenticated(user);
        unawaited(_rememberedAccount.keepEmail(user.email));
        return;
      }
      if (me.failureOrNull?.type == AppFailureType.unauthorized) {
        await _tokenStore.clear();
      }
    }
    await _lookupGuest();
  }

  Future<Result<AuthSession>> login({
    required String email,
    required String password,
    bool rememberAccount = true,
  }) async {
    final result = await _auth.login(
      email: email,
      password: password,
      deviceUuid: await deviceUuid(),
      platform: currentPlatformName(),
    );
    await _handleAuthResult(result);
    if (result.isSuccess) {
      await _rememberedAccount.setFromLogin(
        email: email,
        remember: rememberAccount,
      );
    }
    return result;
  }

  Future<Result<AuthSession>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final result = await _auth.register(
      name: name,
      email: email,
      password: password,
      deviceUuid: await deviceUuid(),
      platform: currentPlatformName(),
    );
    await _handleAuthResult(result);
    if (result.isSuccess) {
      await _rememberedAccount.setFromLogin(email: email, remember: true);
    }
    return result;
  }

  Future<Result<void>> forgotPassword(String email) {
    return _auth.forgotPassword(email: email);
  }

  Future<Result<void>> resetPassword({
    required String email,
    required String token,
    required String password,
  }) {
    return _auth.resetPassword(email: email, token: token, password: password);
  }

  Future<void> logout() async {
    await _auth.logout();
    await _lookupGuest();
  }

  Future<Result<UserAccount>> updateProfile({
    String? name,
    String? timezone,
    String? locale,
    bool? notificationEnabled,
    String? notificationTime,
    String? avatarEmoji,
    bool? showInRanking,
  }) async {
    final result = await _auth.updateProfile(
      name: name,
      timezone: timezone,
      locale: locale,
      notificationEnabled: notificationEnabled,
      notificationTime: notificationTime,
      avatarEmoji: avatarEmoji,
      showInRanking: showInRanking,
    );
    final user = result.valueOrNull;
    if (user != null) {
      state = state.copyWith(user: user);
    }
    return result;
  }

  Future<Result<UserAccount>> uploadAvatar(String filePath) async {
    final result = await _auth.uploadAvatar(filePath: filePath);
    final user = result.valueOrNull;
    if (user != null) {
      state = state.copyWith(user: user);
    }
    return result;
  }

  Future<Result<UserAccount>> clearAvatar() async {
    final result = await _auth.clearAvatar();
    final user = result.valueOrNull;
    if (user != null) {
      state = state.copyWith(user: user);
    }
    return result;
  }

  Future<Result<void>> deleteAccount() async {
    final result = await _auth.deleteAccount();
    if (result.isSuccess) {
      await _rememberedAccount.clear();
      await _lookupGuest();
    }
    return result;
  }

  Future<Result<void>> completeOnboarding({
    required String name,
    required String goal,
    required String experienceLevel,
    required bool notificationEnabled,
    String? notificationTime,
  }) async {
    if (name.trim().isNotEmpty) {
      final updated = await _auth.updateProfile(name: name);
      if (updated is Failure<UserAccount>) {
        return Failure(updated.error);
      }
    }
    final result = await _auth.completeOnboarding(
      goal: goal,
      experienceLevel: experienceLevel,
      notificationEnabled: notificationEnabled,
      notificationTime: notificationTime,
    );
    final user = result.valueOrNull;
    if (user != null) {
      _setAuthenticated(user);
      unawaited(_refreshProfile());
    }
    return result.isSuccess
        ? const Success(null)
        : Failure(result.failureOrNull!);
  }

  void goReady() {
    final user = state.user;
    if (user != null) {
      state = SessionState(status: SessionStatus.ready, user: user);
    }
  }

  Future<Result<void>> transferDeviceAssociation() async {
    final uuid = await deviceUuid();
    final result = await _auth.disassociateDevice(uuid);
    if (result is Success<void>) {
      await logout();
    }
    return result;
  }

  void markPendingTransfer() {
    state = state.copyWith(pendingDeviceTransfer: true);
  }

  void prepareAssociatedLogin() {
    state = state.copyWith(pendingDeviceTransfer: false);
  }

  void applyDeviceHasAccount(String? maskedEmail) {
    state = SessionState(
      status: SessionStatus.deviceAssociated,
      maskedEmail: maskedEmail,
    );
  }

  void onUnauthorized() {
    unawaited(_handleUnauthorized());
  }

  Future<void> _handleUnauthorized() async {
    await _tokenStore.clear();
    if (state.status == SessionStatus.ready ||
        state.status == SessionStatus.onboarding) {
      await _lookupGuest();
    }
  }

  Future<void> _handleAuthResult(Result<AuthSession> result) async {
    final session = result.valueOrNull;
    if (session != null) {
      if (state.pendingDeviceTransfer) {
        await _auth.disassociateDevice(await deviceUuid());
        await _auth.logout();
        await _lookupGuest();
        return;
      }
      _setAuthenticated(session.user);
      unawaited(_refreshProfile());
      return;
    }
    final failure = result.failureOrNull;
    if (failure != null && failure.isDeviceHasAccount) {
      applyDeviceHasAccount(failure.maskedEmail);
    }
  }

  Future<void> _lookupGuest() async {
    final lookup = await _auth.lookupDevice(
      deviceUuid: await deviceUuid(),
      platform: currentPlatformName(),
    );
    final data = lookup.valueOrNull;
    if (data != null && data.associated) {
      state = SessionState(
        status: SessionStatus.deviceAssociated,
        maskedEmail: data.maskedEmail,
      );
      return;
    }
    state = const SessionState(status: SessionStatus.guest);
  }

  void _setAuthenticated(UserAccount user) {
    state = SessionState(
      status: user.onboardingCompleted
          ? SessionStatus.ready
          : SessionStatus.onboarding,
      user: user,
    );
  }

  Future<void> refreshProfile() async {
    await _refreshProfile();
  }

  Future<void> _refreshProfile() async {
    final me = await _auth.fetchMe();
    final user = me.valueOrNull;
    if (user == null) {
      return;
    }
    if (state.status != SessionStatus.ready &&
        state.status != SessionStatus.onboarding) {
      return;
    }
    _setAuthenticated(user);
  }
}
