import 'package:equatable/equatable.dart';

enum ReminderType {
  workout,
  water,
  eye;

  static ReminderType fromString(String value) {
    return ReminderType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ReminderType.workout,
    );
  }
}

class ReminderSettings extends Equatable {
  const ReminderSettings({
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

  factory ReminderSettings.fromJson(Map<String, dynamic> json) {
    return ReminderSettings(
      id: json['id'] as String,
      anonymousUserId: json['anonymous_user_id'] as String,
      type: ReminderType.fromString(json['type'] as String),
      isEnabled: json['is_enabled'] as bool? ?? true,
      intervalMinutes: json['interval_minutes'] as int? ?? 60,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id.isNotEmpty) 'id': id,
        'anonymous_user_id': anonymousUserId,
        'type': type.name,
        'is_enabled': isEnabled,
        'interval_minutes': intervalMinutes,
        'start_time': startTime,
        'end_time': endTime,
      };

  ReminderSettings copyWith({
    String? id,
    String? anonymousUserId,
    ReminderType? type,
    bool? isEnabled,
    int? intervalMinutes,
    String? startTime,
    String? endTime,
  }) {
    return ReminderSettings(
      id: id ?? this.id,
      anonymousUserId: anonymousUserId ?? this.anonymousUserId,
      type: type ?? this.type,
      isEnabled: isEnabled ?? this.isEnabled,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

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
