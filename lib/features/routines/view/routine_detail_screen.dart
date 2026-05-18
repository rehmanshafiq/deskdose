import 'package:deskdose/core/presentation/widgets/screen_safe_area.dart';
import 'package:deskdose/core/router/app_routes.dart';
import 'package:deskdose/core/theme/app_theme.dart';
import 'package:deskdose/data/models/exercise.dart';
import 'package:deskdose/data/models/routine.dart';
import 'package:deskdose/features/routines/bloc/routines_bloc.dart';
import 'package:deskdose/features/workout_player/utils/routine_exercises_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Routine preview with exercise list before starting a workout.
class RoutineDetailScreen extends StatelessWidget {
  const RoutineDetailScreen({
    super.key,
    this.routine,
    this.routineId,
  }) : assert(routine != null || routineId != null);

  final Routine? routine;
  final String? routineId;

  @override
  Widget build(BuildContext context) {
    if (routine != null) {
      return _RoutineDetailContent(routine: routine!);
    }

    return BlocBuilder<RoutinesBloc, RoutinesState>(
      builder: (context, state) {
        if (state is RoutinesLoaded) {
          for (final candidate in state.routines) {
            if (candidate.id == routineId) {
              return _RoutineDetailContent(routine: candidate);
            }
          }
        }

        return const ColoredBox(
          color: AppColors.background,
          child: ScreenSafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(child: CircularProgressIndicator()),
            ),
          ),
        );
      },
    );
  }
}

class _RoutineDetailContent extends StatelessWidget {
  const _RoutineDetailContent({required this.routine});

  final Routine routine;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final exercises = buildExercisesFromRoutine(routine);

    return ColoredBox(
      color: AppColors.background,
      child: ScreenSafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Routine'),
            backgroundColor: AppColors.background,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              Text(
                routine.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                routine.formattedDuration,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                routine.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: routine.tags
                    .map((tag) => Chip(label: Text(tag)))
                    .toList(),
              ),
              const SizedBox(height: 24),
              Text(
                'Exercises',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ...exercises.map(
                (exercise) => _ExerciseTile(exercise: exercise),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => context.push(
                  AppRoutes.workoutPlayer,
                  extra: routine,
                ),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Start Workout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  const _ExerciseTile({required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: AppColors.surfaceContainer,
      child: ListTile(
        leading: Text(exercise.emoji, style: const TextStyle(fontSize: 28)),
        title: Text(exercise.name),
        subtitle: Text('${exercise.durationSeconds}s'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
