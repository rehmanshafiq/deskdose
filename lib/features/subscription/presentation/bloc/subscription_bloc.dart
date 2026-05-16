import 'package:deskdose/core/usecases/usecase.dart';
import 'package:deskdose/features/subscription/domain/entities/subscription_entity.dart';
import 'package:deskdose/features/subscription/domain/usecases/get_subscription_status_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc({required GetSubscriptionStatusUseCase getSubscriptionStatus})
      : _getSubscriptionStatus = getSubscriptionStatus,
        super(const SubscriptionInitial()) {
    on<LoadSubscriptionEvent>(_onLoad);
  }

  final GetSubscriptionStatusUseCase _getSubscriptionStatus;

  Future<void> _onLoad(
    LoadSubscriptionEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(const SubscriptionLoading());
    final result = await _getSubscriptionStatus(const NoParams());
    result.fold(
      (f) => emit(SubscriptionError(message: f.message)),
      (sub) => emit(SubscriptionLoaded(subscription: sub)),
    );
  }
}
