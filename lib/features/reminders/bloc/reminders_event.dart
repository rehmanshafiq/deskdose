part of 'reminders_bloc.dart';

sealed class RemindersEvent extends Equatable {
  const RemindersEvent();

  @override
  List<Object?> get props => [];
}

final class RemindersLoadRequested extends RemindersEvent {
  const RemindersLoadRequested();
}

final class ReminderToggled extends RemindersEvent {
  const ReminderToggled({required this.type, required this.isEnabled});

  final String type;
  final bool isEnabled;

  @override
  List<Object?> get props => [type, isEnabled];
}

final class ReminderIntervalChanged extends RemindersEvent {
  const ReminderIntervalChanged({
    required this.type,
    required this.intervalMinutes,
  });

  final String type;
  final int intervalMinutes;

  @override
  List<Object?> get props => [type, intervalMinutes];
}

final class WorkHoursChanged extends RemindersEvent {
  const WorkHoursChanged({required this.startTime, required this.endTime});

  final String startTime;
  final String endTime;

  @override
  List<Object?> get props => [startTime, endTime];
}
