import 'package:deskdose/core/utils/typedef.dart';
import 'package:deskdose/features/routines/domain/entities/routine_entity.dart';

/// DTO for Supabase `routines` table.
class RoutineModel {
  const RoutineModel({
    required this.id,
    required this.title,
    required this.description,
    required this.durationSeconds,
    required this.category,
    required this.difficulty,
    this.thumbnailUrl,
    required this.isPremium,
    required this.exerciseCount,
    this.tags = const [],
  });

  final String id;
  final String title;
  final String description;
  final int durationSeconds;
  final String category;
  final String difficulty;
  final String? thumbnailUrl;
  final bool isPremium;
  final int exerciseCount;
  final List<String> tags;

  factory RoutineModel.fromJson(DataMap json) {
    return RoutineModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      durationSeconds: json['duration_seconds'] as int? ?? 60,
      category: json['category'] as String? ?? 'stretch',
      difficulty: json['difficulty'] as String? ?? 'beginner',
      thumbnailUrl: json['thumbnail_url'] as String?,
      isPremium: json['is_premium'] as bool? ?? false,
      exerciseCount: json['exercise_count'] as int? ?? 1,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  DataMap toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'duration_seconds': durationSeconds,
        'category': category,
        'difficulty': difficulty,
        'thumbnail_url': thumbnailUrl,
        'is_premium': isPremium,
        'exercise_count': exerciseCount,
        'tags': tags,
      };
}

extension RoutineModelMapper on RoutineModel {
  RoutineEntity toEntity() => RoutineEntity(
        id: id,
        title: title,
        description: description,
        durationSeconds: durationSeconds,
        category: _parseCategory(category),
        difficulty: _parseDifficulty(difficulty),
        thumbnailUrl: thumbnailUrl,
        isPremium: isPremium,
        exerciseCount: exerciseCount,
        tags: tags,
      );

  static RoutineModel fromEntity(RoutineEntity entity) => RoutineModel(
        id: entity.id,
        title: entity.title,
        description: entity.description,
        durationSeconds: entity.durationSeconds,
        category: entity.category.name,
        difficulty: entity.difficulty.name,
        thumbnailUrl: entity.thumbnailUrl,
        isPremium: entity.isPremium,
        exerciseCount: entity.exerciseCount,
        tags: entity.tags,
      );
}

RoutineCategory _parseCategory(String value) {
  return RoutineCategory.values.firstWhere(
    (e) => e.name == value,
    orElse: () => RoutineCategory.stretch,
  );
}

RoutineDifficulty _parseDifficulty(String value) {
  return RoutineDifficulty.values.firstWhere(
    (e) => e.name == value,
    orElse: () => RoutineDifficulty.beginner,
  );
}
