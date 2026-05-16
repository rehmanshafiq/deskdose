part of 'hydration_bloc.dart';

sealed class HydrationState extends Equatable {
  const HydrationState();

  @override
  List<Object?> get props => [];
}

class HydrationInitial extends HydrationState {
  const HydrationInitial();
}

class HydrationLoading extends HydrationState {
  const HydrationLoading();
}

class HydrationLogged extends HydrationState {
  const HydrationLogged({required this.lastLog});

  final HydrationLogEntity lastLog;

  @override
  List<Object?> get props => [lastLog];
}

class HydrationError extends HydrationState {
  const HydrationError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
