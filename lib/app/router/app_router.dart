import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/app/router/app_shell.dart';
import 'package:mindvibe_app/features/audio_player/presentation/pages/now_playing_page.dart';
import 'package:mindvibe_app/features/audio_player/presentation/widgets/page_with_mini_player.dart';
import 'package:mindvibe_app/features/auth/presentation/pages/device_associated_page.dart';
import 'package:mindvibe_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:mindvibe_app/features/auth/presentation/pages/login_page.dart';
import 'package:mindvibe_app/features/auth/presentation/pages/register_page.dart';
import 'package:mindvibe_app/features/auth/presentation/pages/reset_password_page.dart';
import 'package:mindvibe_app/features/auth/presentation/pages/splash_page.dart';
import 'package:mindvibe_app/features/auth/presentation/pages/welcome_page.dart';
import 'package:mindvibe_app/features/auth/presentation/providers/session_controller.dart';
import 'package:mindvibe_app/features/auth/presentation/providers/session_state.dart';
import 'package:mindvibe_app/features/billing/premium_access.dart';
import 'package:mindvibe_app/features/billing/presentation/pages/billing_page.dart';
import 'package:mindvibe_app/features/billing/presentation/pages/paywall_page.dart';
import 'package:mindvibe_app/features/catalog/presentation/pages/catalog_page.dart';
import 'package:mindvibe_app/features/catalog/presentation/pages/choose_plan_page.dart';
import 'package:mindvibe_app/features/catalog/presentation/pages/listen_page.dart';
import 'package:mindvibe_app/features/catalog/presentation/pages/moments_page.dart';
import 'package:mindvibe_app/features/catalog/presentation/pages/program_detail_page.dart';
import 'package:mindvibe_app/features/exercises/presentation/pages/breathing_hub_page.dart';
import 'package:mindvibe_app/features/exercises/presentation/pages/daily_circuit_page.dart';
import 'package:mindvibe_app/features/exercises/presentation/pages/daily_hub_page.dart';
import 'package:mindvibe_app/features/exercises/presentation/pages/library_exercises_page.dart';
import 'package:mindvibe_app/features/exercises/presentation/pages/practice_exercise_page.dart';
import 'package:mindvibe_app/features/home/presentation/pages/home_page.dart';
import 'package:mindvibe_app/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:mindvibe_app/features/profile/presentation/pages/developer_message_page.dart';
import 'package:mindvibe_app/features/profile/presentation/pages/profile_page.dart';
import 'package:mindvibe_app/features/progress/presentation/pages/history_page.dart';
import 'package:mindvibe_app/features/progress/presentation/pages/progress_page.dart';
import 'package:mindvibe_app/features/progress/presentation/pages/ranking_page.dart';
import 'package:mindvibe_app/features/progress/presentation/pages/xp_info_page.dart';
import 'package:mindvibe_app/features/tools/presentation/pages/checkin_page.dart';
import 'package:mindvibe_app/features/tools/presentation/pages/clear_mind_page.dart';
import 'package:mindvibe_app/features/tools/presentation/pages/day_close_page.dart';
import 'package:mindvibe_app/features/tools/presentation/pages/journal_page.dart';
import 'package:mindvibe_app/features/tools/presentation/pages/pomodoro_page.dart';
import 'package:mindvibe_app/features/tools/presentation/pages/silent_room_page.dart';
import 'package:mindvibe_app/features/tools/presentation/pages/thought_page.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/features/training/presentation/pages/plan_page.dart';
import 'package:mindvibe_app/features/training/presentation/pages/session_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen<SessionState>(sessionControllerProvider, (previous, next) {
    refresh.value++;
  });
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refresh,
    redirect: (context, state) {
      final session = ref.read(sessionControllerProvider);
      final location = state.matchedLocation;
      final isSplash = location == AppRoutes.splash;
      final isAuth = {
        AppRoutes.welcome,
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.forgotPassword,
        AppRoutes.resetPassword,
        AppRoutes.device,
      }.contains(location);

      return switch (session.status) {
        SessionStatus.loading => isSplash ? null : AppRoutes.splash,
        SessionStatus.guest => isAuth ? null : AppRoutes.welcome,
        SessionStatus.deviceAssociated => isAuth ? null : AppRoutes.device,
        SessionStatus.onboarding =>
          location == AppRoutes.onboarding ? null : AppRoutes.onboarding,
        SessionStatus.ready =>
          isAuth || isSplash || location == AppRoutes.onboarding
              ? AppRoutes.home
              : (!isPremiumAccount(session.user) &&
                        locationRequiresPremium(location)
                    ? AppRoutes.paywall
                    : null),
      };
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) => const ResetPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.device,
        builder: (context, state) => const DeviceAssociatedPage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.paywall,
        builder: (context, state) =>
            const PageWithMiniPlayer(child: PaywallPage()),
      ),
      GoRoute(
        path: AppRoutes.explore,
        builder: (context, state) =>
            const PageWithMiniPlayer(child: CatalogPage()),
      ),
      GoRoute(
        path: AppRoutes.program,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return PageWithMiniPlayer(child: ProgramDetailPage(programId: id));
        },
      ),
      GoRoute(
        path: AppRoutes.moments,
        builder: (context, state) => PageWithMiniPlayer(
          child: MomentsPage(
            categorySlug: state.uri.queryParameters['category'],
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.exerciseLibrary,
        redirect: (context, state) {
          if (state.uri.queryParameters['type'] == 'breathing') {
            return AppRoutes.breathing;
          }
          return null;
        },
        builder: (context, state) => PageWithMiniPlayer(
          child: LibraryExercisesPage(
            typeFilter: state.uri.queryParameters['type'],
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.breathing,
        builder: (context, state) =>
            const PageWithMiniPlayer(child: BreathingHubPage()),
      ),
      GoRoute(
        path: AppRoutes.daily,
        builder: (context, state) =>
            const PageWithMiniPlayer(child: DailyHubPage()),
      ),
      GoRoute(
        path: AppRoutes.dailyCircuit,
        redirect: (context, state) {
          final extra = state.extra;
          if (extra is List && extra.whereType<ExerciseSpec>().length >= 2) {
            return null;
          }
          return AppRoutes.daily;
        },
        builder: (context, state) {
          final steps = (state.extra as List)
              .whereType<ExerciseSpec>()
              .toList();
          return PageWithMiniPlayer(child: DailyCircuitPage(steps: steps));
        },
      ),
      GoRoute(
        path: AppRoutes.practice,
        redirect: (context, state) {
          if (state.extra is ExerciseSpec) {
            return null;
          }
          return AppRoutes.home;
        },
        builder: (context, state) {
          return PageWithMiniPlayer(
            child: PracticeExercisePage(exercise: state.extra! as ExerciseSpec),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.pomodoro,
        builder: (context, state) =>
            const PageWithMiniPlayer(child: PomodoroPage()),
      ),
      GoRoute(
        path: AppRoutes.checkin,
        builder: (context, state) =>
            const PageWithMiniPlayer(child: CheckinPage()),
      ),
      GoRoute(
        path: AppRoutes.clearMind,
        builder: (context, state) =>
            const PageWithMiniPlayer(child: ClearMindPage()),
      ),
      GoRoute(
        path: AppRoutes.journal,
        builder: (context, state) =>
            const PageWithMiniPlayer(child: JournalPage()),
      ),
      GoRoute(
        path: AppRoutes.thoughts,
        builder: (context, state) =>
            const PageWithMiniPlayer(child: ThoughtPage()),
      ),
      GoRoute(
        path: AppRoutes.dayClose,
        builder: (context, state) =>
            const PageWithMiniPlayer(child: DayClosePage()),
      ),
      GoRoute(
        path: AppRoutes.silentRoom,
        builder: (context, state) =>
            const PageWithMiniPlayer(child: SilentRoomPage()),
      ),
      GoRoute(
        path: AppRoutes.listen,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is ListenLaunch) {
            return PageWithMiniPlayer(
              child: ListenPage(moment: extra.moment, queue: extra.queue),
            );
          }
          if (extra is ListenMoment) {
            return PageWithMiniPlayer(child: ListenPage(moment: extra));
          }
          return const PageWithMiniPlayer(child: CatalogPage());
        },
      ),
      GoRoute(
        path: AppRoutes.nowPlaying,
        builder: (context, state) => const NowPlayingPage(),
      ),
      GoRoute(
        path: AppRoutes.session,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return PageWithMiniPlayer(
            child: SessionPage(
              sessionId: id,
              skipPrepare: state.uri.queryParameters['prepared'] == '1',
            ),
          );
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
                routes: [
                  GoRoute(
                    path: 'plan',
                    builder: (context, state) => const PlanPage(),
                  ),
                  GoRoute(
                    path: 'choose-plan',
                    builder: (context, state) => const ChoosePlanPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.progress,
                builder: (context, state) => const ProgressPage(),
                routes: [
                  GoRoute(
                    path: 'history',
                    builder: (context, state) => const HistoryPage(),
                  ),
                  GoRoute(
                    path: 'ranking',
                    builder: (context, state) => const RankingPage(),
                  ),
                  GoRoute(
                    path: 'xp',
                    builder: (context, state) => const XpInfoPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfilePage(),
                routes: [
                  GoRoute(
                    path: 'message',
                    builder: (context, state) => const DeveloperMessagePage(),
                  ),
                  GoRoute(
                    path: 'billing',
                    builder: (context, state) => const BillingPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
