part of 'home_bloc.dart';

sealed class HomeState {
  const HomeState();
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.todaySessionCount,
    required this.weeklyMinutes,
    required this.todayWaterMl,
    required this.currentStreak,
    required this.recentRoutines,
  });

  final int todaySessionCount;
  final int weeklyMinutes;
  final int todayWaterMl;
  final int currentStreak;
  final List<Routine> recentRoutines;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is HomeLoaded &&
            todaySessionCount == other.todaySessionCount &&
            weeklyMinutes == other.weeklyMinutes &&
            todayWaterMl == other.todayWaterMl &&
            currentStreak == other.currentStreak &&
            _listEquals(recentRoutines, other.recentRoutines);
  }

  @override
  int get hashCode => Object.hash(
        todaySessionCount,
        weeklyMinutes,
        todayWaterMl,
        currentStreak,
        Object.hashAll(recentRoutines),
      );
}

bool _listEquals<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

final class HomeError extends HomeState {
  const HomeError({required this.message});

  final String message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is HomeError && message == other.message;

  @override
  int get hashCode => message.hashCode;
}
