import 'package:deskdose/core/utils/typedef.dart';
import 'package:deskdose/features/routines/domain/entities/workout_session_entity.dart';

class WorkoutSessionModel {
  const WorkoutSessionModel({
    required this.id,
    required this.anonymousUserId,
    required this.routineId,
    required this.completedAt,
    required this.durationSeconds,
    this.caloriesBurned,
  });

  final String id;
  final String anonymousUserId;
  final String routineId;
  final DateTime completedAt;
  final int durationSeconds;
  final double? caloriesBurned;

  factory WorkoutSessionModel.fromJson(DataMap json) {
    return WorkoutSessionModel(
      id: json['id'] as String,
      anonymousUserId: json['anonymous_user_id'] as String,
      routineId: json['routine_id'] as String,
      completedAt: DateTime.parse(json['completed_at'] as String),
      durationSeconds: json['duration_seconds'] as int,
      caloriesBurned: (json['calories_burned'] as num?)?.toDouble(),
    );
  }

  DataMap toJson() => {
        'anonymous_user_id': anonymousUserId,
        'routine_id': routineId,
        'completed_at': completedAt.toIso8601String(),
        'duration_seconds': durationSeconds,
        if (caloriesBurned != null) 'calories_burned': caloriesBurned,
      };
}

extension WorkoutSessionModelMapper on WorkoutSessionModel {
  WorkoutSessionEntity toEntity() => WorkoutSessionEntity(
        id: id,
        anonymousUserId: anonymousUserId,
        routineId: routineId,
        completedAt: completedAt,
        durationSeconds: durationSeconds,
        caloriesBurned: caloriesBurned,
      );
}
