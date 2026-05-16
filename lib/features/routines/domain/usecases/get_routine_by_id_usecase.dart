import 'package:dartz/dartz.dart';
import 'package:deskdose/core/error/failures.dart';
import 'package:deskdose/core/usecases/usecase.dart';
import 'package:deskdose/features/routines/domain/entities/routine_entity.dart';
import 'package:deskdose/features/routines/domain/repositories/routine_repository.dart';
import 'package:equatable/equatable.dart';

class GetRoutineByIdUseCase implements UseCase<RoutineEntity, GetRoutineByIdParams> {
  GetRoutineByIdUseCase(this._repository);

  final RoutineRepository _repository;

  @override
  Future<Either<Failure, RoutineEntity>> call(GetRoutineByIdParams params) {
    return _repository.getRoutineById(params.id);
  }
}

class GetRoutineByIdParams extends Equatable {
  const GetRoutineByIdParams({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
