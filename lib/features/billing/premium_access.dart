import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/features/auth/domain/entities/auth_entities.dart';

const premiumHomeSlugs = {'breathing', 'sleep', 'relaxation', 'memory'};

bool isPremiumAccount(UserAccount? user) => user?.isPremium == true;

bool homeSlugRequiresPremium(String slug) => premiumHomeSlugs.contains(slug);

bool locationRequiresPremium(String location) {
  const routes = {
    AppRoutes.moments,
    AppRoutes.listen,
    AppRoutes.exerciseLibrary,
    AppRoutes.breathing,
    AppRoutes.daily,
    AppRoutes.dailyCircuit,
    AppRoutes.practice,
    AppRoutes.pomodoro,
    AppRoutes.silentRoom,
    AppRoutes.thoughts,
    AppRoutes.dayClose,
  };
  return routes.contains(location);
}

void openMaybePremium(
  BuildContext context, {
  required bool isPremium,
  required VoidCallback action,
}) {
  if (isPremium) {
    action();
    return;
  }
  context.push(AppRoutes.paywall);
}
