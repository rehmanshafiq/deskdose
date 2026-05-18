import 'package:flutter_bloc/flutter_bloc.dart';

part 'paywall_state.dart';

enum PaywallPlan { monthly, yearly }

class PaywallCubit extends Cubit<PaywallState> {
  PaywallCubit() : super(const PaywallInitial());

  Future<void> purchase(PaywallPlan plan) async {
    emit(const PaywallPurchasing());

    try {
      // Stub: integrate with in_app_purchase later.
      await Future<void>.delayed(const Duration(milliseconds: 400));
      emit(PaywallSuccess(plan: plan));
    } catch (e) {
      emit(PaywallError(message: e.toString()));
    }
  }

  void reset() {
    emit(const PaywallInitial());
  }
}
