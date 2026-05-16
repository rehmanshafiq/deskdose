part of 'reminder_bloc.dart';

sealed class ReminderState extends Equatable {
  const ReminderState();

  @override
  List<Object?> get props => [];
}

class ReminderInitial extends ReminderState {
  const ReminderInitial();
}

class ReminderLoading extends ReminderState {
  const ReminderLoading();
}

class ReminderLoaded extends ReminderState {
  const ReminderLoaded({required this.settings});

  final List<ReminderSettingEntity> settings;

  @override
  List<Object?> get props => [settings];
}

class ReminderError extends ReminderState {
  const ReminderError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
