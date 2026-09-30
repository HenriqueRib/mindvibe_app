class UserAccount {
  const UserAccount({
    required this.id,
    required this.name,
    required this.email,
    required this.locale,
    required this.timezone,
    required this.onboardingCompleted,
    required this.isPremium,
    required this.plan,
    this.goal,
    this.experienceLevel,
    this.notificationEnabled,
    this.notificationTime,
    this.notificationDays,
    this.notificationBody,
    this.avatarUrl,
    this.avatarEmoji,
    this.showInRanking = false,
  });

  final int id;
  final String name;
  final String email;
  final String locale;
  final String timezone;
  final bool onboardingCompleted;
  final bool isPremium;
  final String plan;
  final String? goal;
  final String? experienceLevel;
  final bool? notificationEnabled;
  final String? notificationTime;
  final List<int>? notificationDays;
  final String? notificationBody;
  final String? avatarUrl;
  final String? avatarEmoji;
  final bool showInRanking;

  /// ISO weekdays: Monday=1 … Sunday=7. Null means every day.
  List<int> get reminderDays =>
      notificationDays == null || notificationDays!.isEmpty
      ? const [1, 2, 3, 4, 5, 6, 7]
      : List<int>.unmodifiable(notificationDays!);
}

class AuthSession {
  const AuthSession({required this.token, required this.user});

  final String token;
  final UserAccount user;
}

class DeviceLookup {
  const DeviceLookup({required this.associated, this.maskedEmail});

  final bool associated;
  final String? maskedEmail;
}
