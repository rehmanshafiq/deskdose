import 'package:equatable/equatable.dart';

/// Completed workout session record.
class WorkoutSessionEntity extends Equatable {
  const WorkoutSessionEntity({
    required this.id,
    required this.userId,
    required this.routineId,
    required this.completedAt,
    required this.durationSeconds,
    this.caloriesBurned,
  });

  final String id;
  final String userId;
  final String routineId;
  final DateTime completedAt;
  final int durationSeconds;
  final double? caloriesBurned;

  @override
  List<Object?> get props => [
        id,
        userId,
        routineId,
        completedAt,
        durationSeconds,
        caloriesBurned,
      ];
}
