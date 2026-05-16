import 'package:dartz/dartz.dart';
import 'package:deskdose/core/error/failures.dart';
import 'package:deskdose/core/network/network_info.dart';
import 'package:deskdose/core/utils/exception_handler.dart';
import 'package:deskdose/features/hydration/data/datasources/hydration_remote_datasource.dart';
import 'package:deskdose/features/hydration/data/models/hydration_log_model.dart';
import 'package:deskdose/features/hydration/domain/entities/hydration_log_entity.dart';
import 'package:deskdose/features/hydration/domain/repositories/hydration_repository.dart';

class HydrationRepositoryImpl implements HydrationRepository {
  HydrationRepositoryImpl({
    required HydrationRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remote = remoteDataSource,
        _networkInfo = networkInfo;

  final HydrationRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, HydrationLogEntity>> logWaterIntake({
    required int amountMl,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    return guard(() async {
      final model = await _remote.logWaterIntake(amountMl: amountMl);
      return model.toEntity();
    });
  }
}
