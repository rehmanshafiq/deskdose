import 'package:deskdose/core/router/app_routes.dart';
import 'package:deskdose/core/router/go_router_refresh_stream.dart';
import 'package:deskdose/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:deskdose/features/auth/presentation/bloc/auth_state.dart';
import 'package:deskdose/features/auth/presentation/pages/login_page.dart';
import 'package:deskdose/features/auth/presentation/pages/splash_page.dart';
import 'package:deskdose/features/home/presentation/pages/home_page.dart';
import 'package:deskdose/features/hydration/presentation/pages/hydration_page.dart';
import 'package:deskdose/features/posture/presentation/pages/posture_page.dart';
import 'package:deskdose/features/reminders/presentation/pages/reminders_page.dart';
import 'package:deskdose/features/routines/presentation/pages/routine_detail_page.dart';
import 'package:deskdose/features/routines/presentation/pages/routines_page.dart';
import 'package:deskdose/features/subscription/presentation/pages/subscription_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter({required AuthBloc authBloc}) : _authBloc = authBloc {
    _refreshListenable = GoRouterRefreshStream(_authBloc.stream);
  }

  final AuthBloc _authBloc;
  late final GoRouterRefreshStream _refreshListenable;

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: _refreshListenable,
    redirect: _redirect,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.routines,
        builder: (context, state) => const RoutinesPage(),
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
      GoRoute(
        path: AppRoutes.reminders,
        builder: (context, state) => const RemindersPage(),
      ),
      GoRoute(
        path: AppRoutes.hydration,
        builder: (context, state) => const HydrationPage(),
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

  String? _redirect(BuildContext context, GoRouterState state) {
    final authState = _authBloc.state;
    final location = state.matchedLocation;
    final onSplash = location == AppRoutes.splash;
    final onLogin = location == AppRoutes.login;

    if (authState is AuthInitial || authState is AuthLoading) {
      return onSplash ? null : AppRoutes.splash;
    }

    if (authState is AuthAuthenticated) {
      if (onSplash || onLogin) return AppRoutes.home;
      return null;
    }

    if (authState is AuthUnauthenticated || authState is AuthError) {
      if (onSplash) return AppRoutes.login;
      if (onLogin) return null;
      return AppRoutes.login;
    }

    return null;
  }
}
