import 'package:flutter_bloc/flutter_bloc.dart';

/// Selected interval in minutes for [IntervalPickerSheet].
class IntervalPickerCubit extends Cubit<int> {
  IntervalPickerCubit(int initialMinutes) : super(_snap(initialMinutes));

  static int _snap(int minutes) {
    final values = allowedValues;
    var closest = values.first;
    var smallestDiff = (minutes - closest).abs();
    for (final value in values) {
      final diff = (minutes - value).abs();
      if (diff < smallestDiff) {
        smallestDiff = diff;
        closest = value;
      }
    }
    return closest;
  }

  static const minMinutes = 15;
  static const maxMinutes = 120;
  static const stepMinutes = 15;

  static List<int> get allowedValues => List.generate(
        (maxMinutes - minMinutes) ~/ stepMinutes + 1,
        (index) => minMinutes + index * stepMinutes,
      );

  void setMinutes(int minutes) => emit(minutes);
}
