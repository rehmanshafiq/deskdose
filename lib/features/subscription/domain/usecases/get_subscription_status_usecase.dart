import 'package:dartz/dartz.dart';
import 'package:deskdose/core/error/failures.dart';
import 'package:deskdose/core/usecases/usecase.dart';
import 'package:deskdose/features/subscription/domain/entities/subscription_entity.dart';
import 'package:deskdose/features/subscription/domain/repositories/subscription_repository.dart';

class GetSubscriptionStatusUseCase
    implements UseCase<SubscriptionEntity, NoParams> {
  GetSubscriptionStatusUseCase(this._repository);

  final SubscriptionRepository _repository;

  @override
  Future<Either<Failure, SubscriptionEntity>> call(NoParams params) {
    return _repository.getSubscriptionStatus();
  }
}
