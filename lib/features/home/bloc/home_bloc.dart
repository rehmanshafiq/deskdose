import 'package:deskdose/core/utils/anonymous_user_helper.dart';
import 'package:deskdose/data/models/routine.dart';
import 'package:deskdose/data/models/workout_session.dart';
import 'package:deskdose/data/repositories/hydration_repository.dart';
import 'package:deskdose/data/repositories/routine_repository.dart';
import 'package:deskdose/data/repositories/session_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required RoutineRepository routineRepository,
    required SessionRepository sessionRepository,
    required HydrationRepository hydrationRepository,
  })  : _routineRepository = routineRepository,
        _sessionRepository = sessionRepository,
        _hydrationRepository = hydrationRepository,
        super(const HomeInitial()) {
    on<HomeLoadRequested>(_onLoadRequested);
    on<HomeRefreshRequested>(_onRefreshRequested);
  }

  final RoutineRepository _routineRepository;
  final SessionRepository _sessionRepository;
  final HydrationRepository _hydrationRepository;

  Future<void> _onLoadRequested(
    HomeLoadRequested event,
    Emitter<HomeState> emit,
  ) =>
      _load(emit);

  Future<void> _onRefreshRequested(
    HomeRefreshRequested event,
    Emitter<HomeState> emit,
  ) =>
      _load(emit);

  Future<void> _load(Emitter<HomeState> emit) async {
    emit(const HomeLoading());

    try {
      final userId = await getOrCreateAnonymousUserId();
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final weekStart = _startOfWeek(now);
      final streakLookback = todayStart.subtract(const Duration(days: 365));

      // Parallel: sessions (today + streak), water today, recent routines.
      final results = await Future.wait([
        _sessionRepository.fetchWorkoutSessionsForUser(
          userId,
          from: streakLookback,
        ),
        _hydrationRepository.getTodayHydrationTotal(userId),
        _routineRepository.fetchRoutines(),
      ]);

      final sessions = results[0] as List<WorkoutSession>;
      final todayWaterMl = results[1] as int;
      final routines = results[2] as List<Routine>;

      final todaySessionCount = _countSessionsOnDay(sessions, todayStart);
      final weeklyMinutes = _weeklyMinutes(sessions, weekStart);
      final currentStreak = _calculateStreak(sessions, now);
      final recentRoutines = routines.take(4).toList();

      emit(
        HomeLoaded(
          todaySessionCount: todaySessionCount,
          weeklyMinutes: weeklyMinutes,
          todayWaterMl: todayWaterMl,
          currentStreak: currentStreak,
          recentRoutines: recentRoutines,
        ),
      );
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  int _countSessionsOnDay(List<WorkoutSession> sessions, DateTime day) {
    return sessions
        .where((s) => _isSameDay(s.completedAt, day))
        .length;
  }

  int _weeklyMinutes(List<WorkoutSession> sessions, DateTime weekStart) {
    final totalSeconds = sessions
        .where((s) => !s.completedAt.isBefore(weekStart))
        .fold<int>(0, (sum, s) => sum + s.durationSeconds);
    return totalSeconds ~/ 60;
  }

  int _calculateStreak(List<WorkoutSession> sessions, DateTime now) {
    final daysWithSessions = <String>{};
    for (final session in sessions) {
      final day = session.completedAt;
      daysWithSessions.add(_dayKey(day));
    }

    if (daysWithSessions.isEmpty) return 0;

    var cursor = DateTime(now.year, now.month, now.day);
    final todayKey = _dayKey(cursor);

    if (!daysWithSessions.contains(todayKey)) {
      cursor = cursor.subtract(const Duration(days: 1));
    }

    var streak = 0;
    while (daysWithSessions.contains(_dayKey(cursor))) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  DateTime _startOfWeek(DateTime date) {
    final weekday = date.weekday;
    return DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: weekday - DateTime.monday));
  }

  bool _isSameDay(DateTime a, DateTime b) => _dayKey(a) == _dayKey(b);

  String _dayKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
