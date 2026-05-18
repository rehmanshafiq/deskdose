part of 'routines_bloc.dart';

sealed class RoutinesEvent {
  const RoutinesEvent();
}

final class RoutinesLoadRequested extends RoutinesEvent {
  const RoutinesLoadRequested({this.initialCategory});

  final String? initialCategory;
}

final class RoutinesCategoryFilterChanged extends RoutinesEvent {
  const RoutinesCategoryFilterChanged(this.category);

  final String? category;
}

final class RoutinesShowFreeOnlyToggled extends RoutinesEvent {
  const RoutinesShowFreeOnlyToggled();
}
