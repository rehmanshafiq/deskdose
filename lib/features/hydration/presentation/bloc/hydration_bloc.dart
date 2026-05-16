import 'package:deskdose/features/hydration/domain/entities/hydration_log_entity.dart';
import 'package:deskdose/features/hydration/domain/usecases/log_water_intake_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'hydration_event.dart';
part 'hydration_state.dart';

class HydrationBloc extends Bloc<HydrationEvent, HydrationState> {
  HydrationBloc({required LogWaterIntakeUseCase logWaterIntake})
      : _logWaterIntake = logWaterIntake,
        super(const HydrationInitial()) {
    on<LogWaterEvent>(_onLogWater);
  }

  final LogWaterIntakeUseCase _logWaterIntake;

  Future<void> _onLogWater(
    LogWaterEvent event,
    Emitter<HydrationState> emit,
  ) async {
    emit(const HydrationLoading());
    final result = await _logWaterIntake(LogWaterIntakeParams(amountMl: event.amountMl));
    result.fold(
      (f) => emit(HydrationError(message: f.message)),
      (log) => emit(HydrationLogged(lastLog: log)),
    );
  }
}
