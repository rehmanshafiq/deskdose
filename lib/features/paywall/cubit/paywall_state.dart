part of 'paywall_cubit.dart';

sealed class PaywallState {
  const PaywallState();
}

final class PaywallInitial extends PaywallState {
  const PaywallInitial();
}

final class PaywallPurchasing extends PaywallState {
  const PaywallPurchasing();
}

final class PaywallSuccess extends PaywallState {
  const PaywallSuccess({required this.plan});

  final PaywallPlan plan;
}

final class PaywallError extends PaywallState {
  const PaywallError({required this.message});

  final String message;
}
