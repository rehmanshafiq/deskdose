import 'package:deskdose/features/subscription/domain/entities/subscription_entity.dart';

class SubscriptionModel {
  const SubscriptionModel({
    required this.tier,
    required this.isActive,
    this.expiresAt,
    this.productId,
  });

  final String tier;
  final bool isActive;
  final DateTime? expiresAt;
  final String? productId;
}

extension SubscriptionModelMapper on SubscriptionModel {
  SubscriptionEntity toEntity() => SubscriptionEntity(
        tier: SubscriptionTier.values.firstWhere(
          (e) => e.name == tier,
          orElse: () => SubscriptionTier.free,
        ),
        isActive: isActive,
        expiresAt: expiresAt,
        productId: productId,
      );
}
