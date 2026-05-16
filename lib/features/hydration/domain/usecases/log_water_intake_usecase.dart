import 'package:dartz/dartz.dart';
import 'package:deskdose/core/error/failures.dart';
import 'package:deskdose/core/usecases/usecase.dart';
import 'package:deskdose/features/hydration/domain/entities/hydration_log_entity.dart';
import 'package:deskdose/features/hydration/domain/repositories/hydration_repository.dart';
import 'package:equatable/equatable.dart';

class LogWaterIntakeUseCase
    implements UseCase<HydrationLogEntity, LogWaterIntakeParams> {
  LogWaterIntakeUseCase(this._repository);

  final HydrationRepository _repository;

  @override
  Future<Either<Failure, HydrationLogEntity>> call(LogWaterIntakeParams params) {
    return _repository.logWaterIntake(amountMl: params.amountMl);
  }
}

class LogWaterIntakeParams extends Equatable {
  const LogWaterIntakeParams({required this.amountMl});

  final int amountMl;

  @override
  List<Object?> get props => [amountMl];
}
