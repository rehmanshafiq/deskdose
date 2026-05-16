import 'package:dartz/dartz.dart';
import 'package:deskdose/core/error/failures.dart';
import 'package:deskdose/core/network/network_info.dart';
import 'package:deskdose/core/utils/exception_handler.dart';
import 'package:deskdose/features/posture/data/datasources/posture_remote_datasource.dart';
import 'package:deskdose/features/posture/domain/repositories/posture_repository.dart';
import 'package:deskdose/features/routines/data/models/routine_model.dart';
import 'package:deskdose/features/routines/domain/entities/routine_entity.dart';

class PostureRepositoryImpl implements PostureRepository {
  PostureRepositoryImpl({
    required PostureRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remote = remoteDataSource,
        _networkInfo = networkInfo;

  final PostureRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, List<RoutineEntity>>> getPostureRoutines() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    return guard(() async {
      final models = await _remote.getPostureRoutines();
      return models.map((m) => m.toEntity()).toList();
    });
  }
}
