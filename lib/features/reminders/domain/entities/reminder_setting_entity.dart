import 'package:equatable/equatable.dart';

enum ReminderType { workout, hydration, posture, breakReminder }

class ReminderSettingEntity extends Equatable {
  const ReminderSettingEntity({
    required this.id,
    required this.anonymousUserId,
    required this.type,
    required this.isEnabled,
    required this.intervalMinutes,
    this.startTime,
    this.endTime,
  });

  final String id;
  final String anonymousUserId;
  final ReminderType type;
  final bool isEnabled;
  final int intervalMinutes;
  final String? startTime;
  final String? endTime;

  @override
  List<Object?> get props => [
        id,
        anonymousUserId,
        type,
        isEnabled,
        intervalMinutes,
        startTime,
        endTime,
      ];
}
