import 'package:deskdose/core/di/injection.dart';
import 'package:deskdose/core/router/app_routes.dart';
import 'package:deskdose/data/models/routine.dart';
import 'package:deskdose/features/home/view/home_screen.dart';
import 'package:deskdose/features/hydration/view/hydration_screen.dart';
import 'package:deskdose/features/reminders/view/settings_screen.dart';
import 'package:deskdose/features/routines/view/routine_detail_screen.dart';
import 'package:deskdose/features/routines/view/routines_screen.dart';
import 'package:deskdose/features/workout_player/bloc/workout_player_bloc.dart';
import 'package:deskdose/features/workout_player/utils/routine_exercises_builder.dart';
import 'package:deskdose/features/workout_player/view/workout_complete_screen.dart';
import 'package:deskdose/features/workout_player/view/workout_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.home,
  routes: [
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
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.hydration,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HydrationScreen(),
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
      path: '${AppRoutes.routines}/:id',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final routine = state.extra as Routine?;
        return RoutineDetailScreen(
          routine: routine,
          routineId: routine == null ? id : null,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.workoutPlayer,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final routine = state.extra as Routine?;
        if (routine == null) {
          return const Scaffold(
            body: Center(child: Text('Routine not found')),
          );
        }
        final exercises = buildExercisesFromRoutine(routine);
        return BlocProvider(
          create: (_) => sl<WorkoutPlayerBloc>()
            ..add(
              WorkoutPlayerStarted(
                routine: routine,
                exercises: exercises,
              ),
            ),
          child: WorkoutPlayerScreen(routine: routine),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.workoutComplete,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final result = state.extra as WorkoutPlayerComplete?;
        if (result == null) {
          return const Scaffold(
            body: Center(child: Text('Workout result not found')),
          );
        }
        return WorkoutCompleteScreen(result: result);
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Route not found: ${state.uri}')),
  ),
);
