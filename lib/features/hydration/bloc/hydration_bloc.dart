import 'package:deskdose/core/utils/anonymous_user_helper.dart';
import 'package:deskdose/data/models/hydration_log.dart';
import 'package:deskdose/data/repositories/hydration_repository.dart';
import 'package:deskdose/features/hydration/utils/hydration_preferences.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'hydration_event.dart';
part 'hydration_state.dart';

class HydrationBloc extends Bloc<HydrationEvent, HydrationState> {
  HydrationBloc({required HydrationRepository hydrationRepository})
      : _hydrationRepository = hydrationRepository,
        super(const HydrationInitial()) {
    on<HydrationLoadRequested>(_onLoadRequested);
    on<HydrationLogAdded>(_onLogAdded);
    on<HydrationGoalChanged>(_onGoalChanged);
  }

  final HydrationRepository _hydrationRepository;
  DateTime _selectedDate = DateTime.now();

  Future<void> _onLoadRequested(
    HydrationLoadRequested event,
    Emitter<HydrationState> emit,
  ) async {
    emit(const HydrationLoading());
    _selectedDate = event.date;

    try {
      await _emitLoadedForDate(emit);
    } catch (e) {
      emit(HydrationError(message: e.toString()));
    }
  }

  Future<void> _onLogAdded(
    HydrationLogAdded event,
    Emitter<HydrationState> emit,
  ) async {
    final previous = state;
    if (previous is! HydrationLoaded) return;

    final userId = await getOrCreateAnonymousUserId();
    final loggedAt = DateTime.now();
    final optimisticTotal = previous.totalMl + event.amountMl;
    final optimisticLog = HydrationLog(
      id: 'pending-${loggedAt.millisecondsSinceEpoch}',
      anonymousUserId: userId,
      amountMl: event.amountMl,
      loggedAt: loggedAt,
    );

    emit(
      previous.copyWith(
        todayLogs: [optimisticLog, ...previous.todayLogs],
        totalMl: optimisticTotal,
        percentage: _percentage(optimisticTotal, previous.goalMl),
        isLogging: true,
        clearActionError: true,
      ),
    );

    try {
      await _hydrationRepository.insertHydrationLog(
        HydrationLog(
          id: '',
          anonymousUserId: userId,
          amountMl: event.amountMl,
          loggedAt: loggedAt,
        ),
      );

      await _emitLoadedForDate(emit);
    } catch (e) {
      emit(
        previous.copyWith(
          isLogging: false,
          actionError: _friendlyError(e),
        ),
      );
    }
  }

  String _friendlyError(Object error) {
    final message = error.toString();
    if (message.contains('row-level security')) {
      return 'Could not save — run supabase/rls_policies.sql in your Supabase project.';
    }
    return message;
  }

  Future<void> _emitLoadedForDate(Emitter<HydrationState> emit) async {
    final userId = await getOrCreateAnonymousUserId();
    final goalMl = await HydrationPreferences.getGoalMl();
    final logs = await _hydrationRepository.fetchHydrationLogsForUser(
      userId,
      _selectedDate,
    );
    final totalMl = logs.fold<int>(0, (sum, log) => sum + log.amountMl);

    emit(
      HydrationLoaded(
        todayLogs: logs,
        totalMl: totalMl,
        goalMl: goalMl,
        percentage: _percentage(totalMl, goalMl),
      ),
    );
  }

  Future<void> _onGoalChanged(
    HydrationGoalChanged event,
    Emitter<HydrationState> emit,
  ) async {
    try {
      await HydrationPreferences.setGoalMl(event.newGoalMl);

      if (state is HydrationLoaded) {
        final loaded = state as HydrationLoaded;
        emit(
          loaded.copyWith(
            goalMl: event.newGoalMl,
            percentage: _percentage(loaded.totalMl, event.newGoalMl),
          ),
        );
      } else {
        add(HydrationLoadRequested(_selectedDate));
      }
    } catch (e) {
      emit(HydrationError(message: e.toString()));
    }
  }

  double _percentage(int totalMl, int goalMl) {
    if (goalMl <= 0) return 0;
    return (totalMl / goalMl).clamp(0.0, 1.0);
  }
}
