import 'package:equatable/equatable.dart';

enum RoutineCategory {
  stretch,
  mobility,
  strength,
  breathing,
  posture,
  eyes,
}

enum RoutineDifficulty { beginner, intermediate, advanced }

/// Pure domain entity — no Flutter or JSON dependencies.
class RoutineEntity extends Equatable {
  const RoutineEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.durationSeconds,
    required this.category,
    required this.difficulty,
    required this.thumbnailUrl,
    required this.isPremium,
    required this.exerciseCount,
    this.tags = const [],
  });

  final String id;
  final String title;
  final String description;
  final int durationSeconds;
  final RoutineCategory category;
  final RoutineDifficulty difficulty;
  final String? thumbnailUrl;
  final bool isPremium;
  final int exerciseCount;
  final List<String> tags;

  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    if (minutes > 0 && seconds > 0) return '${minutes}m ${seconds}s';
    if (minutes > 0) return '${minutes}m';
    return '${seconds}s';
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        durationSeconds,
        category,
        difficulty,
        thumbnailUrl,
        isPremium,
        exerciseCount,
        tags,
      ];
}
