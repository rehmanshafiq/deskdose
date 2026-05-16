import 'package:dartz/dartz.dart';
import 'package:deskdose/core/error/failures.dart';
import 'package:deskdose/features/subscription/domain/entities/subscription_entity.dart';

abstract class SubscriptionRepository {
  Future<Either<Failure, SubscriptionEntity>> getSubscriptionStatus();
}
