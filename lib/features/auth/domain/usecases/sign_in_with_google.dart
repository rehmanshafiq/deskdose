import 'package:dartz/dartz.dart';
import 'package:deskdose/core/error/failures.dart';
import 'package:deskdose/core/usecases/usecase.dart';
import 'package:deskdose/features/auth/domain/repositories/auth_repository.dart';

class SignInWithGoogleUseCase implements UseCase<void, NoParams> {
  SignInWithGoogleUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return _repository.signInWithGoogle();
  }
}
