import 'package:deskdose/core/usecases/usecase.dart';
import 'package:deskdose/features/reminders/domain/usecases/get_reminder_settings_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deskdose/features/reminders/domain/entities/reminder_setting_entity.dart';

part 'reminder_event.dart';
part 'reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  ReminderBloc({required GetReminderSettingsUseCase getReminderSettings})
      : _getReminderSettings = getReminderSettings,
        super(const ReminderInitial()) {
    on<LoadRemindersEvent>(_onLoad);
  }

  final GetReminderSettingsUseCase _getReminderSettings;

  Future<void> _onLoad(
    LoadRemindersEvent event,
    Emitter<ReminderState> emit,
  ) async {
    emit(const ReminderLoading());
    final result = await _getReminderSettings(const NoParams());
    result.fold(
      (f) => emit(ReminderError(message: f.message)),
      (settings) => emit(ReminderLoaded(settings: settings)),
    );
  }
}
