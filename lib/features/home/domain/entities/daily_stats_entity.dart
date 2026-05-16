import 'package:equatable/equatable.dart';

class DailyStatsEntity extends Equatable {
  const DailyStatsEntity({
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

  double get hydrationProgress =>
      hydrationGoalMl > 0 ? (hydrationMl / hydrationGoalMl).clamp(0.0, 1.0) : 0;

  @override
  List<Object?> get props => [
        workoutsCompleted,
        totalWorkoutMinutes,
        hydrationMl,
        hydrationGoalMl,
        postureSessionsCompleted,
        streakDays,
      ];
}
