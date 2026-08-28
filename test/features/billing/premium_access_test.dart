import 'package:flutter_test/flutter_test.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/features/auth/domain/entities/auth_entities.dart';
import 'package:mindvibe_app/features/billing/premium_access.dart';

void main() {
  const free = UserAccount(
    id: 1,
    name: 'Lia',
    email: 'lia@gmail.com',
    locale: 'pt-BR',
    timezone: 'America/Sao_Paulo',
    onboardingCompleted: true,
    isPremium: false,
    plan: 'free',
  );
  const premium = UserAccount(
    id: 2,
    name: 'Henrique',
    email: 'ribeiro.henriquem@gmail.com',
    locale: 'pt-BR',
    timezone: 'America/Sao_Paulo',
    onboardingCompleted: true,
    isPremium: true,
    plan: 'premium',
  );

  test('free account is locked on premium rooms and open on free tools', () {
    expect(isPremiumAccount(free), isFalse);
    expect(isPremiumAccount(premium), isTrue);

    expect(locationRequiresPremium(AppRoutes.daily), isTrue);
    expect(locationRequiresPremium(AppRoutes.dailyCircuit), isTrue);
    expect(locationRequiresPremium(AppRoutes.practice), isTrue);
    expect(locationRequiresPremium(AppRoutes.moments), isTrue);
    expect(locationRequiresPremium(AppRoutes.listen), isTrue);
    expect(locationRequiresPremium(AppRoutes.exerciseLibrary), isTrue);
    expect(locationRequiresPremium(AppRoutes.breathing), isTrue);
    expect(locationRequiresPremium(AppRoutes.pomodoro), isTrue);
    expect(locationRequiresPremium(AppRoutes.silentRoom), isTrue);
    expect(locationRequiresPremium(AppRoutes.thoughts), isTrue);
    expect(locationRequiresPremium(AppRoutes.dayClose), isTrue);

    expect(locationRequiresPremium(AppRoutes.checkin), isFalse);
    expect(locationRequiresPremium(AppRoutes.journal), isFalse);
    expect(locationRequiresPremium(AppRoutes.clearMind), isFalse);
    expect(locationRequiresPremium(AppRoutes.home), isFalse);
    expect(locationRequiresPremium(AppRoutes.explore), isFalse);
  });
}
