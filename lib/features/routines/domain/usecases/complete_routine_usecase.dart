import 'package:dartz/dartz.dart';
import 'package:deskdose/core/error/failures.dart';
import 'package:deskdose/core/usecases/usecase.dart';
import 'package:deskdose/features/routines/domain/entities/workout_session_entity.dart';
import 'package:deskdose/features/routines/domain/repositories/routine_repository.dart';
import 'package:equatable/equatable.dart';

class CompleteRoutineUseCase
    implements UseCase<WorkoutSessionEntity, CompleteRoutineParams> {
  CompleteRoutineUseCase(this._repository);

  final RoutineRepository _repository;

  @override
  Future<Either<Failure, WorkoutSessionEntity>> call(
    CompleteRoutineParams params,
  ) {
    return _repository.completeRoutine(
      routineId: params.routineId,
      durationSeconds: params.durationSeconds,
      caloriesBurned: params.caloriesBurned,
    );
  }
}

class CompleteRoutineParams extends Equatable {
  const CompleteRoutineParams({
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
