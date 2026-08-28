import 'package:mindvibe_app/features/auth/domain/entities/auth_entities.dart';

enum SessionStatus { loading, guest, deviceAssociated, onboarding, ready }

class SessionState {
  const SessionState({
    required this.status,
    this.user,
    this.maskedEmail,
    this.pendingDeviceTransfer = false,
  });

  final SessionStatus status;
  final UserAccount? user;
  final String? maskedEmail;
  final bool pendingDeviceTransfer;

  SessionState copyWith({
    SessionStatus? status,
    UserAccount? user,
    String? maskedEmail,
    bool? pendingDeviceTransfer,
    bool clearUser = false,
    bool clearMaskedEmail = false,
  }) {
    return SessionState(
      status: status ?? this.status,
      user: clearUser ? null : user ?? this.user,
      maskedEmail: clearMaskedEmail ? null : maskedEmail ?? this.maskedEmail,
      pendingDeviceTransfer:
          pendingDeviceTransfer ?? this.pendingDeviceTransfer,
    );
  }
}
