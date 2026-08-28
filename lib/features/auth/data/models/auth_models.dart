import 'package:mindvibe_app/features/auth/domain/entities/auth_entities.dart';

UserAccount userFromJson(Map<String, dynamic> json) {
  return UserAccount(
    id: json['id'] as int,
    name: json['name'] as String? ?? '',
    email: json['email'] as String? ?? '',
    locale: json['locale'] as String? ?? 'pt-BR',
    timezone: json['timezone'] as String? ?? 'America/Sao_Paulo',
    onboardingCompleted: json['onboarding_completed'] as bool? ?? false,
    isPremium: json['is_premium'] as bool? ?? false,
    plan: json['plan'] as String? ?? 'free',
    goal: json['goal'] as String?,
    experienceLevel: json['experience_level'] as String?,
    notificationEnabled: json['notification_enabled'] as bool?,
    notificationTime: json['notification_time'] as String?,
    avatarUrl: json['avatar_url'] as String?,
    avatarEmoji: json['avatar_emoji'] as String?,
    showInRanking: json['show_in_ranking'] as bool? ?? false,
  );
}

AuthSession sessionFromJson(Map<String, dynamic> json) {
  return AuthSession(
    token: json['token'] as String,
    user: userFromJson(json['user'] as Map<String, dynamic>),
  );
}

DeviceLookup deviceLookupFromJson(Map<String, dynamic> json) {
  return DeviceLookup(
    associated: json['associated'] as bool? ?? false,
    maskedEmail: json['masked_email'] as String?,
  );
}
