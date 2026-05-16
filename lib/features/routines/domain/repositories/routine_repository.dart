import 'package:dartz/dartz.dart';
import 'package:deskdose/core/error/failures.dart';
import 'package:deskdose/features/routines/domain/entities/routine_entity.dart';
import 'package:deskdose/features/routines/domain/entities/workout_session_entity.dart';

abstract class RoutineRepository {
  Future<Either<Failure, List<RoutineEntity>>> getRoutines({
    RoutineCategory? category,
    int limit,
    int offset,
  });

  Future<Either<Failure, RoutineEntity>> getRoutineById(String id);

  Future<Either<Failure, WorkoutSessionEntity>> completeRoutine({
    required String routineId,
    required int durationSeconds,
    double? caloriesBurned,
  });
}
