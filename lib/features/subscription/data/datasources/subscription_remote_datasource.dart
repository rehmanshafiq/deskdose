import 'package:deskdose/features/subscription/data/models/subscription_model.dart';

/// RevenueCat / store integration boundary.
///
/// Replace stub implementation with Purchases SDK calls when wiring RevenueCat.
abstract class SubscriptionRemoteDataSource {
  Future<SubscriptionModel> getSubscriptionStatus();
}

class SubscriptionRemoteDataSourceImpl implements SubscriptionRemoteDataSource {
  @override
  Future<SubscriptionModel> getSubscriptionStatus() async {
    // TODO: Integrate RevenueCat Purchases.getCustomerInfo()
    return const SubscriptionModel(
      tier: 'free',
      isActive: false,
    );
  }
}
