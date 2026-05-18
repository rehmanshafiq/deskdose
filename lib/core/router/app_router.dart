import 'package:deskdose/core/presentation/pages/splash_page.dart';
import 'package:deskdose/core/router/app_routes.dart';
import 'package:deskdose/data/models/routine.dart';
import 'package:deskdose/features/home/view/home_screen.dart';
import 'package:deskdose/features/hydration/presentation/pages/hydration_page.dart';
import 'package:deskdose/features/posture/presentation/pages/posture_page.dart';
import 'package:deskdose/features/reminders/presentation/pages/reminders_page.dart';
import 'package:deskdose/features/routines/presentation/pages/routine_detail_page.dart';
import 'package:deskdose/features/routines/view/routines_screen.dart';
import 'package:deskdose/features/routines/view/workout_player_screen.dart';
import 'package:deskdose/features/settings/view/settings_screen.dart';
import 'package:deskdose/features/subscription/presentation/pages/subscription_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  late final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.routinesExplore,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final category = state.uri.queryParameters['category'];
          return RoutinesScreen(
            initialCategory: category,
            showBackButton: true,
          );
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomeTabView(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.routines,
                pageBuilder: (context, state) {
                  final category = state.uri.queryParameters['category'];
                  return NoTransitionPage(
                    child: RoutinesScreen(
                      initialCategory: category,
                      showBackButton: false,
                    ),
                  );
                },
                routes: [
                  GoRoute(
                    path: ':id/workout',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) {
                      final routine = state.extra as Routine?;
                      if (routine == null) {
                        return const Scaffold(
                          body: Center(child: Text('Routine not found')),
                        );
                      }
                      return WorkoutPlayerScreen(routine: routine);
                    },
                  ),
                  GoRoute(
                    path: ':id',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return RoutineDetailPage(routineId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.hydration,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HydrationPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: SettingsScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.reminders,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const RemindersPage(),
      ),
      GoRoute(
        path: AppRoutes.posture,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const PosturePage(),
      ),
      GoRoute(
        path: AppRoutes.subscription,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SubscriptionPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Route not found: ${state.uri}')),
    ),
  );
}
