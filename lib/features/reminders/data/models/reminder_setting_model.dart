import 'package:deskdose/core/utils/typedef.dart';
import 'package:deskdose/features/reminders/domain/entities/reminder_setting_entity.dart';

class ReminderSettingModel {
  const ReminderSettingModel({
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
  final String type;
  final bool isEnabled;
  final int intervalMinutes;
  final String? startTime;
  final String? endTime;

  factory ReminderSettingModel.fromJson(DataMap json) => ReminderSettingModel(
        id: json['id'] as String,
        anonymousUserId: json['anonymous_user_id'] as String,
        type: json['type'] as String,
        isEnabled: json['is_enabled'] as bool? ?? true,
        intervalMinutes: json['interval_minutes'] as int? ?? 60,
        startTime: json['start_time'] as String?,
        endTime: json['end_time'] as String?,
      );
}

extension ReminderSettingModelMapper on ReminderSettingModel {
  ReminderSettingEntity toEntity() => ReminderSettingEntity(
        id: id,
        anonymousUserId: anonymousUserId,
        type: ReminderType.values.firstWhere(
          (e) => e.name == type,
          orElse: () => ReminderType.workout,
        ),
        isEnabled: isEnabled,
        intervalMinutes: intervalMinutes,
        startTime: startTime,
        endTime: endTime,
      );
}
