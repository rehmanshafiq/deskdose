import 'package:deskdose/core/utils/typedef.dart';
import 'package:deskdose/features/home/domain/entities/daily_stats_entity.dart';

class DailyStatsModel {
  const DailyStatsModel({
    required this.workoutsCompleted,
    required this.totalWorkoutMinutes,
    required this.hydrationMl,
    required this.hydrationGoalMl,
    required this.postureSessionsCompleted,
    required this.streakDays,
  });

  final int workoutsCompleted;
  final int totalWorkoutMinutes;
  final int hydrationMl;
  final int hydrationGoalMl;
  final int postureSessionsCompleted;
  final int streakDays;

  factory DailyStatsModel.fromJson(DataMap json) => DailyStatsModel(
        workoutsCompleted: json['workouts_completed'] as int? ?? 0,
        totalWorkoutMinutes: json['total_workout_minutes'] as int? ?? 0,
        hydrationMl: json['hydration_ml'] as int? ?? 0,
        hydrationGoalMl: json['hydration_goal_ml'] as int? ?? 2000,
        postureSessionsCompleted:
            json['posture_sessions_completed'] as int? ?? 0,
        streakDays: json['streak_days'] as int? ?? 0,
      );
}

extension DailyStatsModelMapper on DailyStatsModel {
  DailyStatsEntity toEntity() => DailyStatsEntity(
        workoutsCompleted: workoutsCompleted,
        totalWorkoutMinutes: totalWorkoutMinutes,
        hydrationMl: hydrationMl,
        hydrationGoalMl: hydrationGoalMl,
        postureSessionsCompleted: postureSessionsCompleted,
        streakDays: streakDays,
      );
}
