import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindvibe_app/core/device/device_id_store.dart';
import 'package:mindvibe_app/core/network/api_client.dart';
import 'package:mindvibe_app/core/notifications/notification_scheduler.dart';
import 'package:mindvibe_app/core/storage/memory_words_store.dart';
import 'package:mindvibe_app/core/storage/paused_training_store.dart';
import 'package:mindvibe_app/core/storage/pending_session_store.dart';
import 'package:mindvibe_app/core/storage/remembered_account_store.dart';
import 'package:mindvibe_app/core/storage/token_store.dart';
import 'package:mindvibe_app/features/analytics/data/analytics_client.dart';

final tokenStoreProvider = Provider<TokenStore>((ref) => TokenStore());

final deviceIdStoreProvider = Provider<DeviceIdStore>((ref) => DeviceIdStore());

final unauthorizedSignalProvider = Provider<UnauthorizedSignal>((ref) {
  return UnauthorizedSignal();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final signal = ref.watch(unauthorizedSignalProvider);
  return ApiClient(
    tokenStore: ref.watch(tokenStoreProvider),
    onUnauthorized: signal.notify,
  );
});

final pendingSessionStoreProvider = Provider<PendingSessionStore>((ref) {
  return PendingSessionStore();
});

final rememberedAccountStoreProvider = Provider<RememberedAccountStore>((ref) {
  return RememberedAccountStore();
});

final pausedTrainingStoreProvider = Provider<PausedTrainingStore>((ref) {
  return PausedTrainingStore();
});

final pausedTrainingProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(pausedTrainingStoreProvider).read();
});

final memoryWordsStoreProvider = Provider<MemoryWordsStore>((ref) {
  return MemoryWordsStore();
});

final memoryWordsProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(memoryWordsStoreProvider).read();
});

final analyticsClientProvider = Provider<AnalyticsClient>((ref) {
  return AnalyticsClient(
    apiClient: ref.watch(apiClientProvider),
    deviceIdStore: ref.watch(deviceIdStoreProvider),
  );
});

final notificationSchedulerProvider = Provider<NotificationScheduler>((ref) {
  return NotificationScheduler(ref.watch(analyticsClientProvider));
});

class UnauthorizedSignal {
  void Function()? _listener;

  void bind(void Function() listener) {
    _listener = listener;
  }

  void notify() {
    _listener?.call();
  }
}
