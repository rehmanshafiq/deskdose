part of 'routines_bloc.dart';

sealed class RoutinesState {
  const RoutinesState();
}

final class RoutinesInitial extends RoutinesState {
  const RoutinesInitial();
}

final class RoutinesLoading extends RoutinesState {
  const RoutinesLoading();
}

final class RoutinesLoaded extends RoutinesState {
  const RoutinesLoaded({
    required this.routines,
    required this.selectedCategory,
    required this.showFreeOnly,
  });

  final List<Routine> routines;
  final String? selectedCategory;
  final bool showFreeOnly;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RoutinesLoaded &&
            selectedCategory == other.selectedCategory &&
            showFreeOnly == other.showFreeOnly &&
            _listEquals(routines, other.routines);
  }

  @override
  int get hashCode =>
      Object.hash(selectedCategory, showFreeOnly, Object.hashAll(routines));
}

bool _listEquals<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

final class RoutinesError extends RoutinesState {
  const RoutinesError({required this.message});

  final String message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoutinesError && message == other.message;

  @override
  int get hashCode => message.hashCode;
}
