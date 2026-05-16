import 'package:dartz/dartz.dart';
import 'package:deskdose/core/error/failures.dart';
import 'package:deskdose/features/hydration/domain/entities/hydration_log_entity.dart';

abstract class HydrationRepository {
  Future<Either<Failure, HydrationLogEntity>> logWaterIntake({required int amountMl});
}
