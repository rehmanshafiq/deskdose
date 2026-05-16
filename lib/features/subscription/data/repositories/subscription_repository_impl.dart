import 'package:dartz/dartz.dart';
import 'package:deskdose/core/error/failures.dart';
import 'package:deskdose/core/utils/exception_handler.dart';
import 'package:deskdose/features/subscription/data/datasources/subscription_remote_datasource.dart';
import 'package:deskdose/features/subscription/data/models/subscription_model.dart';
import 'package:deskdose/features/subscription/domain/entities/subscription_entity.dart';
import 'package:deskdose/features/subscription/domain/repositories/subscription_repository.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  SubscriptionRepositoryImpl({required SubscriptionRemoteDataSource remoteDataSource})
      : _remote = remoteDataSource;

  final SubscriptionRemoteDataSource _remote;

  @override
  Future<Either<Failure, SubscriptionEntity>> getSubscriptionStatus() {
    return guard(() async {
      final model = await _remote.getSubscriptionStatus();
      return model.toEntity();
    });
  }
}
