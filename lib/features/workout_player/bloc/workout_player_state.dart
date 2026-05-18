part of 'workout_player_bloc.dart';

sealed class WorkoutPlayerState extends Equatable {
  const WorkoutPlayerState();

  @override
  List<Object?> get props => [];
}

final class WorkoutPlayerInitial extends WorkoutPlayerState {
  const WorkoutPlayerInitial();
}

final class WorkoutPlayerRunning extends WorkoutPlayerState {
  const WorkoutPlayerRunning({
    required this.exercise,
    required this.exerciseIndex,
    required this.totalExercises,
    required this.remainingSeconds,
    required this.isPaused,
    required this.totalElapsed,
    required this.routine,
  });

  final Exercise exercise;
  final int exerciseIndex;
  final int totalExercises;
  final int remainingSeconds;
  final bool isPaused;
  final int totalElapsed;
  final Routine routine;

  @override
  List<Object?> get props => [
        exercise,
        exerciseIndex,
        totalExercises,
        remainingSeconds,
        isPaused,
        totalElapsed,
        routine,
      ];
}

final class WorkoutPlayerPaused extends WorkoutPlayerState {
  const WorkoutPlayerPaused({
    required this.exercise,
    required this.exerciseIndex,
    required this.totalExercises,
    required this.remainingSeconds,
    required this.totalElapsed,
    required this.routine,
  });

  final Exercise exercise;
  final int exerciseIndex;
  final int totalExercises;
  final int remainingSeconds;
  final int totalElapsed;
  final Routine routine;

  @override
  List<Object?> get props => [
        exercise,
        exerciseIndex,
        totalExercises,
        remainingSeconds,
        totalElapsed,
        routine,
      ];
}

final class WorkoutPlayerComplete extends WorkoutPlayerState {
  const WorkoutPlayerComplete({
    required this.routine,
    required this.totalSeconds,
    required this.caloriesBurned,
    required this.exercisesCompleted,
  });

  final Routine routine;
  final int totalSeconds;
  final double caloriesBurned;
  final int exercisesCompleted;

  @override
  List<Object?> get props =>
      [routine, totalSeconds, caloriesBurned, exercisesCompleted];
}

final class WorkoutPlayerError extends WorkoutPlayerState {
  const WorkoutPlayerError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
