import 'package:deskdose/data/models/exercise.dart';
import 'package:deskdose/data/models/routine.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Builds a playable exercise list from a [Routine] (no exercises table yet).
List<Exercise> buildExercisesFromRoutine(Routine routine) {
  final count = routine.exerciseCount.clamp(1, 8);
  final perExercise =
      (routine.durationSeconds / count).round().clamp(15, 180);
  final emoji = _categoryEmoji(routine.category);
  final names = _exerciseNames(routine.category, count);

  return List.generate(count, (index) {
    final name = index < names.length ? names[index] : 'Move ${index + 1}';
    return Exercise(
      id: _uuid.v4(),
      name: name,
      description: routine.description.isNotEmpty
          ? routine.description
          : 'Follow the movement slowly and breathe steadily.',
      durationSeconds: perExercise,
      emoji: emoji,
      instructions: [
        'Settle into a comfortable position.',
        'Move slowly through the full range of motion.',
        'Hold for a breath, then return to start.',
      ],
    );
  });
}

String _categoryEmoji(String category) {
  return switch (category) {
    'stretch' => '🧘',
    'eyes' => '👁️',
    'mobility' => '🦴',
    'posture' => '🧍',
    _ => '💪',
  };
}

List<String> _exerciseNames(String category, int count) {
  final pool = switch (category) {
    'stretch' => [
      'Neck rolls',
      'Shoulder shrugs',
      'Wrist circles',
      'Seated twist',
      'Hip opener',
    ],
    'eyes' => [
      'Palming',
      'Focus shift',
      'Figure eight',
      'Near-far focus',
      'Eye rolls',
    ],
    'mobility' => [
      'Cat-cow',
      'Hip hinge',
      'Thoracic twist',
      'Glute squeeze',
      'Hamstring reach',
    ],
    'posture' => [
      'Wall angels',
      'Chin tuck',
      'Scapular squeeze',
      'Chest opener',
      'Core brace',
    ],
    _ => ['Warm up', 'Main move', 'Cool down', 'Breathe', 'Reset'],
  };
  return List.generate(count, (i) => pool[i % pool.length]);
}
