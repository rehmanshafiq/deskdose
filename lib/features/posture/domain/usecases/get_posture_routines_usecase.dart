import 'package:dartz/dartz.dart';
import 'package:deskdose/core/error/failures.dart';
import 'package:deskdose/core/usecases/usecase.dart';
import 'package:deskdose/features/posture/domain/repositories/posture_repository.dart';
import 'package:deskdose/features/routines/domain/entities/routine_entity.dart';

class GetPostureRoutinesUseCase
    implements UseCase<List<RoutineEntity>, NoParams> {
  GetPostureRoutinesUseCase(this._repository);

  final PostureRepository _repository;

  @override
  Future<Either<Failure, List<RoutineEntity>>> call(NoParams params) {
    return _repository.getPostureRoutines();
  }
}
