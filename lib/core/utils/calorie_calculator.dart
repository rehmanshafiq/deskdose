/// Estimates calories burned from workout duration and difficulty.
abstract final class CalorieCalculator {
  static const _caloriesPerMinute = <String, double>{
    'beginner': 3,
    'moderate': 5,
    'advanced': 7,
  };

  /// Returns estimated calories for [durationSeconds] at [difficulty].
  static double estimateCalories(int durationSeconds, String difficulty) {
    final minutes = durationSeconds / 60;
    final rate = _caloriesPerMinute[difficulty.toLowerCase()] ?? 5;
    return minutes * rate;
  }
}
