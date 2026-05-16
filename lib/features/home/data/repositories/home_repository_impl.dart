import 'package:dartz/dartz.dart';
import 'package:deskdose/core/error/failures.dart';
import 'package:deskdose/core/network/network_info.dart';
import 'package:deskdose/core/utils/exception_handler.dart';
import 'package:deskdose/features/home/data/datasources/home_remote_datasource.dart';
import 'package:deskdose/features/home/data/models/daily_stats_model.dart';
import 'package:deskdose/features/home/domain/entities/daily_stats_entity.dart';
import 'package:deskdose/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({
    required HomeRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remote = remoteDataSource,
        _networkInfo = networkInfo;

  final HomeRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, DailyStatsEntity>> getDailyStats({DateTime? date}) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    return guard(() async {
      final model = await _remote.getDailyStats(date: date);
      return model.toEntity();
    });
  }
}
