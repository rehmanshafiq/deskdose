import 'package:deskdose/core/presentation/pages/splash_page.dart';
import 'package:deskdose/core/router/app_routes.dart';
import 'package:deskdose/features/home/view/home_screen.dart';
import 'package:deskdose/features/hydration/presentation/pages/hydration_page.dart';
import 'package:deskdose/features/posture/presentation/pages/posture_page.dart';
import 'package:deskdose/features/reminders/presentation/pages/reminders_page.dart';
import 'package:deskdose/features/routines/presentation/pages/routine_detail_page.dart';
import 'package:deskdose/features/routines/presentation/pages/routines_page.dart';
import 'package:deskdose/features/settings/view/settings_screen.dart';
import 'package:deskdose/features/subscription/presentation/pages/subscription_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
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
                    child: RoutinesPage(initialCategory: category),
                  );
                },
                routes: [
                  GoRoute(
                    path: ':id',
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
        builder: (context, state) => const RemindersPage(),
      ),
      GoRoute(
        path: AppRoutes.posture,
        builder: (context, state) => const PosturePage(),
      ),
      GoRoute(
        path: AppRoutes.subscription,
        builder: (context, state) => const SubscriptionPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Route not found: ${state.uri}')),
    ),
  );
}
