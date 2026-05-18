import 'package:equatable/equatable.dart';

class WorkoutSession extends Equatable {
  const WorkoutSession({
    required this.id,
    required this.anonymousUserId,
    required this.routineId,
    required this.completedAt,
    required this.durationSeconds,
    this.caloriesBurned,
    required this.createdAt,
  });

  final String id;
  final String anonymousUserId;
  final String routineId;
  final DateTime completedAt;
  final int durationSeconds;
  final double? caloriesBurned;
  final DateTime createdAt;

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      id: json['id'] as String,
      anonymousUserId: json['anonymous_user_id'] as String,
      routineId: json['routine_id'] as String,
      completedAt: _parseDateTime(json['completed_at']),
      durationSeconds: json['duration_seconds'] as int,
      caloriesBurned: (json['calories_burned'] as num?)?.toDouble(),
      createdAt: _parseDateTime(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        if (id.isNotEmpty) 'id': id,
        'anonymous_user_id': anonymousUserId,
        'routine_id': routineId,
        'completed_at': completedAt.toUtc().toIso8601String(),
        'duration_seconds': durationSeconds,
        if (caloriesBurned != null) 'calories_burned': caloriesBurned,
        'created_at': createdAt.toUtc().toIso8601String(),
      };

  WorkoutSession copyWith({
    String? id,
    String? anonymousUserId,
    String? routineId,
    DateTime? completedAt,
    int? durationSeconds,
    double? caloriesBurned,
    DateTime? createdAt,
  }) {
    return WorkoutSession(
      id: id ?? this.id,
      anonymousUserId: anonymousUserId ?? this.anonymousUserId,
      routineId: routineId ?? this.routineId,
      completedAt: completedAt ?? this.completedAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        anonymousUserId,
        routineId,
        completedAt,
        durationSeconds,
        caloriesBurned,
        createdAt,
      ];
}

DateTime _parseDateTime(Object? value) {
  if (value is DateTime) return value;
  if (value is String) return DateTime.parse(value);
  return DateTime.now().toUtc();
}
