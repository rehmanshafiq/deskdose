part of 'reminders_bloc.dart';

sealed class RemindersState extends Equatable {
  const RemindersState();

  @override
  List<Object?> get props => [];
}

final class RemindersInitial extends RemindersState {
  const RemindersInitial();
}

final class RemindersLoading extends RemindersState {
  const RemindersLoading();
}

final class RemindersLoaded extends RemindersState {
  const RemindersLoaded({
    required this.settings,
    required this.workStart,
    required this.workEnd,
  });

  final List<ReminderSettings> settings;
  final String workStart;
  final String workEnd;

  ReminderSettings? settingFor(ReminderType type) {
    for (final setting in settings) {
      if (setting.type == type) return setting;
    }
    return null;
  }

  @override
  List<Object?> get props => [settings, workStart, workEnd];
}

final class RemindersError extends RemindersState {
  const RemindersError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
