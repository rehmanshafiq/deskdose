import 'package:dartz/dartz.dart';
import 'package:deskdose/core/error/failures.dart';
import 'package:deskdose/features/home/domain/entities/daily_stats_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, DailyStatsEntity>> getDailyStats({DateTime? date});
}
