import 'package:equatable/equatable.dart';

enum ReminderType { workout, hydration, posture, breakReminder }

class ReminderSettingEntity extends Equatable {
  const ReminderSettingEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.isEnabled,
    required this.intervalMinutes,
    this.startTime,
    this.endTime,
  });

  final String id;
  final String userId;
  final ReminderType type;
  final bool isEnabled;
  final int intervalMinutes;
  final String? startTime;
  final String? endTime;

  @override
  List<Object?> get props =>
      [id, userId, type, isEnabled, intervalMinutes, startTime, endTime];
}
