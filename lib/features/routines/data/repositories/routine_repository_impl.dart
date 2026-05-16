import 'package:dartz/dartz.dart';
import 'package:deskdose/core/error/failures.dart';
import 'package:deskdose/core/network/network_info.dart';
import 'package:deskdose/core/utils/exception_handler.dart';
import 'package:deskdose/features/routines/data/datasources/routine_remote_datasource.dart';
import 'package:deskdose/features/routines/data/models/routine_model.dart';
import 'package:deskdose/features/routines/data/models/workout_session_model.dart';
import 'package:deskdose/features/routines/domain/entities/routine_entity.dart';
import 'package:deskdose/features/routines/domain/entities/workout_session_entity.dart';
import 'package:deskdose/features/routines/domain/repositories/routine_repository.dart';

class RoutineRepositoryImpl implements RoutineRepository {
  RoutineRepositoryImpl({
    required RoutineRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remote = remoteDataSource,
        _networkInfo = networkInfo;

  final RoutineRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, List<RoutineEntity>>> getRoutines({
    RoutineCategory? category,
    int limit = 20,
    int offset = 0,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    return guard(() async {
      final models = await _remote.getRoutines(
        category: category,
        limit: limit,
        offset: offset,
      );
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, RoutineEntity>> getRoutineById(String id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    return guard(() async {
      final model = await _remote.getRoutineById(id);
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, WorkoutSessionEntity>> completeRoutine({
    required String routineId,
    required int durationSeconds,
    double? caloriesBurned,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    return guard(() async {
      final model = await _remote.completeRoutine(
        routineId: routineId,
        durationSeconds: durationSeconds,
        caloriesBurned: caloriesBurned,
      );
      return model.toEntity();
    });
  }
}
