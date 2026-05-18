part of 'hydration_bloc.dart';

sealed class HydrationEvent extends Equatable {
  const HydrationEvent();

  @override
  List<Object?> get props => [];
}

final class HydrationLoadRequested extends HydrationEvent {
  const HydrationLoadRequested(this.date);

  final DateTime date;

  @override
  List<Object?> get props => [date];
}

final class HydrationLogAdded extends HydrationEvent {
  const HydrationLogAdded(this.amountMl);

  final int amountMl;

  @override
  List<Object?> get props => [amountMl];
}

final class HydrationGoalChanged extends HydrationEvent {
  const HydrationGoalChanged(this.newGoalMl);

  final int newGoalMl;

  @override
  List<Object?> get props => [newGoalMl];
}
