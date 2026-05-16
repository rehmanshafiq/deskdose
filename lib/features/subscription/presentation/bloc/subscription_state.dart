part of 'subscription_bloc.dart';

sealed class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {
  const SubscriptionInitial();
}

class SubscriptionLoading extends SubscriptionState {
  const SubscriptionLoading();
}

class SubscriptionLoaded extends SubscriptionState {
  const SubscriptionLoaded({required this.subscription});

  final SubscriptionEntity subscription;

  @override
  List<Object?> get props => [subscription];
}

class SubscriptionError extends SubscriptionState {
  const SubscriptionError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
