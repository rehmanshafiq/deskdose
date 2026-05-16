import 'package:dartz/dartz.dart';
import 'package:deskdose/core/error/failures.dart';
import 'package:equatable/equatable.dart';

/// Base contract for all domain use cases.
///
/// [Type] — return type
/// [Params] — input parameters (use [NoParams] when none)
abstract class UseCase<TResult, Params> {
  Future<Either<Failure, TResult>> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
