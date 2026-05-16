import 'package:dartz/dartz.dart';
import 'package:deskdose/core/error/exceptions.dart';
import 'package:deskdose/core/error/failures.dart';

/// Maps data-layer exceptions to domain failures.
Failure mapExceptionToFailure(Object exception) {
  if (exception is ServerException) {
    return ServerFailure(message: exception.message);
  }
  if (exception is NetworkException) {
    return NetworkFailure(message: exception.message);
  }
  if (exception is AuthException) {
    return AuthFailure(message: exception.message);
  }
  if (exception is NotFoundException) {
    return NotFoundFailure(message: exception.message);
  }
  if (exception is CacheException) {
    return CacheFailure(message: exception.message);
  }
  return UnexpectedFailure(message: exception.toString());
}

/// Executes a remote/local call and returns [Either].
Future<Either<Failure, T>> guard<T>(Future<T> Function() call) async {
  try {
    final result = await call();
    return Right(result);
  } catch (e) {
    return Left(mapExceptionToFailure(e));
  }
}
