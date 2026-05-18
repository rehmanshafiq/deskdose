import 'package:equatable/equatable.dart';

class Exercise extends Equatable {
  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.durationSeconds,
    required this.emoji,
    this.instructions = const [],
  });

  final String id;
  final String name;
  final String description;
  final int durationSeconds;
  final String emoji;
  final List<String> instructions;

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      durationSeconds: json['duration_seconds'] as int? ?? 30,
      emoji: json['emoji'] as String? ?? '💪',
      instructions: (json['instructions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'duration_seconds': durationSeconds,
        'emoji': emoji,
        'instructions': instructions,
      };

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    int? durationSeconds,
    String? emoji,
    List<String>? instructions,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      emoji: emoji ?? this.emoji,
      instructions: instructions ?? this.instructions,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, description, durationSeconds, emoji, instructions];
}
