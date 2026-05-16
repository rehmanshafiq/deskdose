import 'package:dartz/dartz.dart';
import 'package:deskdose/core/error/failures.dart';
import 'package:deskdose/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  /// Launches Google OAuth via Supabase. Session is completed on redirect.
  Future<Either<Failure, void>> signInWithGoogle();

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, UserEntity?>> getCurrentUser();
}
