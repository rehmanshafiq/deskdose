part of 'hydration_bloc.dart';

sealed class HydrationState extends Equatable {
  const HydrationState();

  @override
  List<Object?> get props => [];
}

final class HydrationInitial extends HydrationState {
  const HydrationInitial();
}

final class HydrationLoading extends HydrationState {
  const HydrationLoading();
}

final class HydrationLoaded extends HydrationState {
  const HydrationLoaded({
    required this.todayLogs,
    required this.totalMl,
    required this.goalMl,
    required this.percentage,
    this.isLogging = false,
  });

  final List<HydrationLog> todayLogs;
  final int totalMl;
  final int goalMl;
  final double percentage;
  final bool isLogging;

  HydrationLoaded copyWith({
    List<HydrationLog>? todayLogs,
    int? totalMl,
    int? goalMl,
    double? percentage,
    bool? isLogging,
  }) {
    return HydrationLoaded(
      todayLogs: todayLogs ?? this.todayLogs,
      totalMl: totalMl ?? this.totalMl,
      goalMl: goalMl ?? this.goalMl,
      percentage: percentage ?? this.percentage,
      isLogging: isLogging ?? this.isLogging,
    );
  }

  @override
  List<Object?> get props =>
      [todayLogs, totalMl, goalMl, percentage, isLogging];
}

final class HydrationError extends HydrationState {
  const HydrationError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
