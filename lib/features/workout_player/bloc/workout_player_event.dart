part of 'workout_player_bloc.dart';

sealed class WorkoutPlayerEvent extends Equatable {
  const WorkoutPlayerEvent();

  @override
  List<Object?> get props => [];
}

final class WorkoutPlayerStarted extends WorkoutPlayerEvent {
  const WorkoutPlayerStarted({required this.routine, required this.exercises});

  final Routine routine;
  final List<Exercise> exercises;

  @override
  List<Object?> get props => [routine, exercises];
}

final class WorkoutPlayerPause extends WorkoutPlayerEvent {
  const WorkoutPlayerPause();
}

final class WorkoutPlayerResume extends WorkoutPlayerEvent {
  const WorkoutPlayerResume();
}

final class WorkoutPlayerNextExercise extends WorkoutPlayerEvent {
  const WorkoutPlayerNextExercise();
}

final class WorkoutPlayerPreviousExercise extends WorkoutPlayerEvent {
  const WorkoutPlayerPreviousExercise();
}

final class WorkoutPlayerTimerTicked extends WorkoutPlayerEvent {
  const WorkoutPlayerTimerTicked(this.remainingSeconds);

  final int remainingSeconds;

  @override
  List<Object?> get props => [remainingSeconds];
}

final class WorkoutPlayerCompleted extends WorkoutPlayerEvent {
  const WorkoutPlayerCompleted();
}
