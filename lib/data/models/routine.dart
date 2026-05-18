import 'package:equatable/equatable.dart';

class Routine extends Equatable {
  const Routine({
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
    required this.createdAt,
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
  final DateTime createdAt;

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
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
      createdAt: _parseDateTime(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() => {
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
        'created_at': createdAt.toUtc().toIso8601String(),
      };

  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    if (minutes > 0 && seconds > 0) return '${minutes}m ${seconds}s';
    if (minutes > 0) return '$minutes min';
    return '${seconds}s';
  }

  Routine copyWith({
    String? id,
    String? title,
    String? description,
    int? durationSeconds,
    String? category,
    String? difficulty,
    String? thumbnailUrl,
    bool? isPremium,
    int? exerciseCount,
    List<String>? tags,
    DateTime? createdAt,
  }) {
    return Routine(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      isPremium: isPremium ?? this.isPremium,
      exerciseCount: exerciseCount ?? this.exerciseCount,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
    );
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
        createdAt,
      ];
}

DateTime _parseDateTime(Object? value) {
  if (value is DateTime) return value;
  if (value is String) return DateTime.parse(value);
  return DateTime.now().toUtc();
}
