part of 'hydration_bloc.dart';

abstract class HydrationEvent extends Equatable {
  const HydrationEvent();

  @override
  List<Object?> get props => [];
}

class LogWaterEvent extends HydrationEvent {
  const LogWaterEvent({required this.amountMl});

  final int amountMl;

  @override
  List<Object?> get props => [amountMl];
}
