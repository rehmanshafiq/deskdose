import 'package:dartz/dartz.dart';
import 'package:deskdose/core/error/failures.dart';
import 'package:deskdose/core/network/network_info.dart';
import 'package:deskdose/core/utils/exception_handler.dart';
import 'package:deskdose/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:deskdose/features/auth/data/models/user_model.dart';
import 'package:deskdose/features/auth/domain/entities/user_entity.dart';
import 'package:deskdose/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remote = remoteDataSource,
        _networkInfo = networkInfo;

  final AuthRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, void>> signInWithGoogle() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    return guard(_remote.signInWithGoogle);
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    return guard(_remote.signOut);
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    return guard(() async {
      final model = await _remote.getCurrentUser();
      return model?.toEntity();
    });
  }
}
