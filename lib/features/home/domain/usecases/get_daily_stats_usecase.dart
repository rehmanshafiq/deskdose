import 'package:dartz/dartz.dart';
import 'package:deskdose/core/error/failures.dart';
import 'package:deskdose/core/usecases/usecase.dart';
import 'package:deskdose/features/home/domain/entities/daily_stats_entity.dart';
import 'package:deskdose/features/home/domain/repositories/home_repository.dart';
import 'package:equatable/equatable.dart';

class GetDailyStatsUseCase implements UseCase<DailyStatsEntity, GetDailyStatsParams> {
  GetDailyStatsUseCase(this._repository);

  final HomeRepository _repository;

  @override
  Future<Either<Failure, DailyStatsEntity>> call(GetDailyStatsParams params) {
    return _repository.getDailyStats(date: params.date);
  }
}

class GetDailyStatsParams extends Equatable {
  const GetDailyStatsParams({this.date});

  final DateTime? date;

  @override
  List<Object?> get props => [date];
}
