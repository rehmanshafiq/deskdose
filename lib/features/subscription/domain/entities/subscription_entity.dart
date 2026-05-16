import 'package:equatable/equatable.dart';

enum SubscriptionTier { free, premium, enterprise }

class SubscriptionEntity extends Equatable {
  const SubscriptionEntity({
    required this.tier,
    required this.isActive,
    this.expiresAt,
    this.productId,
  });

  final SubscriptionTier tier;
  final bool isActive;
  final DateTime? expiresAt;
  final String? productId;

  bool get isPremium =>
      isActive &&
      (tier == SubscriptionTier.premium || tier == SubscriptionTier.enterprise);

  @override
  List<Object?> get props => [tier, isActive, expiresAt, productId];
}
