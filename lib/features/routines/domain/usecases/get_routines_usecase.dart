import 'package:dartz/dartz.dart';
import 'package:deskdose/core/error/failures.dart';
import 'package:deskdose/core/usecases/usecase.dart';
import 'package:deskdose/features/routines/domain/entities/routine_entity.dart';
import 'package:deskdose/features/routines/domain/repositories/routine_repository.dart';
import 'package:equatable/equatable.dart';

class GetRoutinesUseCase implements UseCase<List<RoutineEntity>, GetRoutinesParams> {
  GetRoutinesUseCase(this._repository);

  final RoutineRepository _repository;

  @override
  Future<Either<Failure, List<RoutineEntity>>> call(GetRoutinesParams params) {
    return _repository.getRoutines(
      category: params.category,
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class GetRoutinesParams extends Equatable {
  const GetRoutinesParams({
    this.category,
    this.limit = 20,
    this.offset = 0,
  });

  final RoutineCategory? category;
  final int limit;
  final int offset;

  @override
  List<Object?> get props => [category, limit, offset];
}
