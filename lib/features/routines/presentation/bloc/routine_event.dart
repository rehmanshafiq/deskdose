import 'package:deskdose/features/routines/domain/entities/routine_entity.dart';
import 'package:equatable/equatable.dart';

abstract class RoutineEvent extends Equatable {
  const RoutineEvent();

  @override
  List<Object?> get props => [];
}

class LoadRoutinesEvent extends RoutineEvent {
  const LoadRoutinesEvent({this.category});

  final RoutineCategory? category;

  @override
  List<Object?> get props => [category];
}

class LoadRoutineDetailEvent extends RoutineEvent {
  const LoadRoutineDetailEvent({required this.routineId});

  final String routineId;

  @override
  List<Object?> get props => [routineId];
}

class CompleteRoutineEvent extends RoutineEvent {
  const CompleteRoutineEvent({
    required this.routineId,
    required this.durationSeconds,
    this.caloriesBurned,
  });

  final String routineId;
  final int durationSeconds;
  final double? caloriesBurned;

  @override
  List<Object?> get props => [routineId, durationSeconds, caloriesBurned];
}

class RefreshRoutinesEvent extends RoutineEvent {
  const RefreshRoutinesEvent();
}
