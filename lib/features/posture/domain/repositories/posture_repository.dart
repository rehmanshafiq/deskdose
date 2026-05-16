import 'package:dartz/dartz.dart';
import 'package:deskdose/core/error/failures.dart';
import 'package:deskdose/features/routines/domain/entities/routine_entity.dart';

abstract class PostureRepository {
  Future<Either<Failure, List<RoutineEntity>>> getPostureRoutines();
}
