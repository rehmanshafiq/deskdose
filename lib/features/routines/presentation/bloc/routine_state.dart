import 'package:deskdose/features/routines/domain/entities/routine_entity.dart';
import 'package:deskdose/features/routines/domain/entities/workout_session_entity.dart';
import 'package:equatable/equatable.dart';

sealed class RoutineState extends Equatable {
  const RoutineState();

  @override
  List<Object?> get props => [];
}

class RoutineInitial extends RoutineState {
  const RoutineInitial();
}

class RoutineLoading extends RoutineState {
  const RoutineLoading();
}

class RoutineLoaded extends RoutineState {
  const RoutineLoaded({
    required this.routines,
    this.selectedRoutine,
    this.lastCompletedSession,
    this.isCompleting = false,
  });

  final List<RoutineEntity> routines;
  final RoutineEntity? selectedRoutine;
  final WorkoutSessionEntity? lastCompletedSession;
  final bool isCompleting;

  RoutineLoaded copyWith({
    List<RoutineEntity>? routines,
    RoutineEntity? selectedRoutine,
    WorkoutSessionEntity? lastCompletedSession,
    bool? isCompleting,
    bool clearSelected = false,
    bool clearSession = false,
  }) {
    return RoutineLoaded(
      routines: routines ?? this.routines,
      selectedRoutine:
          clearSelected ? null : (selectedRoutine ?? this.selectedRoutine),
      lastCompletedSession: clearSession
          ? null
          : (lastCompletedSession ?? this.lastCompletedSession),
      isCompleting: isCompleting ?? this.isCompleting,
    );
  }

  @override
  List<Object?> get props =>
      [routines, selectedRoutine, lastCompletedSession, isCompleting];
}

class RoutineError extends RoutineState {
  const RoutineError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
