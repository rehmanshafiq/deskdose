import 'dart:async';

import 'package:deskdose/core/utils/anonymous_user_helper.dart';
import 'package:deskdose/data/models/exercise.dart';
import 'package:deskdose/data/models/routine.dart';
import 'package:deskdose/data/models/workout_session.dart';
import 'package:deskdose/data/repositories/session_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'workout_player_event.dart';
part 'workout_player_state.dart';

class WorkoutPlayerBloc extends Bloc<WorkoutPlayerEvent, WorkoutPlayerState> {
  WorkoutPlayerBloc({required SessionRepository sessionRepository})
      : _sessionRepository = sessionRepository,
        super(const WorkoutPlayerInitial()) {
    on<WorkoutPlayerStarted>(_onStarted);
    on<WorkoutPlayerPause>(_onPaused);
    on<WorkoutPlayerResume>(_onResumed);
    on<WorkoutPlayerNextExercise>(_onNextExercise);
    on<WorkoutPlayerPreviousExercise>(_onPreviousExercise);
    on<WorkoutPlayerTimerTicked>(_onTimerTicked);
    on<WorkoutPlayerCompleted>(_onCompleted);
  }

  final SessionRepository _sessionRepository;

  Routine? _routine;
  List<Exercise> _exercises = [];
  int _exerciseIndex = 0;
  int _remainingSeconds = 0;
  int _totalElapsed = 0;
  StreamSubscription<int>? _timerSubscription;

  Exercise get _currentExercise => _exercises[_exerciseIndex];

  Future<void> _onStarted(
    WorkoutPlayerStarted event,
    Emitter<WorkoutPlayerState> emit,
  ) async {
    if (event.exercises.isEmpty) {
      emit(const WorkoutPlayerError(message: 'No exercises to play'));
      return;
    }

    _routine = event.routine;
    _exercises = event.exercises;
    _exerciseIndex = 0;
    _remainingSeconds = _exercises.first.durationSeconds;
    _totalElapsed = 0;

    _startTimer();
    emit(_runningState());
  }

  void _onPaused(
    WorkoutPlayerPause event,
    Emitter<WorkoutPlayerState> emit,
  ) {
    if (state is! WorkoutPlayerRunning) return;

    _timerSubscription?.cancel();
    _timerSubscription = null;
    emit(_pausedState());
  }

  void _onResumed(
    WorkoutPlayerResume event,
    Emitter<WorkoutPlayerState> emit,
  ) {
    if (state is! WorkoutPlayerPaused) return;

    _startTimer();
    emit(_runningState());
  }

  void _onNextExercise(
    WorkoutPlayerNextExercise event,
    Emitter<WorkoutPlayerState> emit,
  ) {
    if (_exercises.isEmpty) return;

    _timerSubscription?.cancel();
    if (_exerciseIndex < _exercises.length - 1) {
      _exerciseIndex++;
      _remainingSeconds = _currentExercise.durationSeconds;
      _startTimer();
      emit(_runningState());
    } else {
      add(const WorkoutPlayerCompleted());
    }
  }

  void _onPreviousExercise(
    WorkoutPlayerPreviousExercise event,
    Emitter<WorkoutPlayerState> emit,
  ) {
    if (_exercises.isEmpty || _exerciseIndex <= 0) return;

    _timerSubscription?.cancel();
    _exerciseIndex--;
    _remainingSeconds = _currentExercise.durationSeconds;
    _startTimer();
    emit(_runningState());
  }

  void _onTimerTicked(
    WorkoutPlayerTimerTicked event,
    Emitter<WorkoutPlayerState> emit,
  ) {
    if (state is! WorkoutPlayerRunning) return;

    _remainingSeconds = event.remainingSeconds;
    _totalElapsed += 1;

    if (_remainingSeconds <= 0) {
      if (_exerciseIndex < _exercises.length - 1) {
        _exerciseIndex++;
        _remainingSeconds = _currentExercise.durationSeconds;
        emit(_runningState());
      } else {
        add(const WorkoutPlayerCompleted());
      }
      return;
    }

    emit(_runningState());
  }

  Future<void> _onCompleted(
    WorkoutPlayerCompleted event,
    Emitter<WorkoutPlayerState> emit,
  ) async {
    _timerSubscription?.cancel();
    _timerSubscription = null;

    final routine = _routine;
    if (routine == null) {
      emit(const WorkoutPlayerError(message: 'Workout session lost'));
      return;
    }

    final totalSeconds = _totalElapsed;
    final caloriesBurned = _estimateCalories(totalSeconds);

    try {
      final userId = await getOrCreateAnonymousUserId();
      final now = DateTime.now().toUtc();

      await _sessionRepository.insertWorkoutSession(
        WorkoutSession(
          id: '',
          anonymousUserId: userId,
          routineId: routine.id,
          completedAt: now,
          durationSeconds: totalSeconds,
          caloriesBurned: caloriesBurned,
          createdAt: now,
        ),
      );

      emit(
        WorkoutPlayerComplete(
          routine: routine,
          totalSeconds: totalSeconds,
          caloriesBurned: caloriesBurned,
          exercisesCompleted: _exercises.length,
        ),
      );
    } catch (e) {
      emit(WorkoutPlayerError(message: e.toString()));
    }
  }

  void _startTimer() {
    _timerSubscription?.cancel();
    _timerSubscription =
        Stream<int>.periodic(const Duration(seconds: 1), (tick) => tick)
            .listen((_) {
      add(WorkoutPlayerTimerTicked(_remainingSeconds - 1));
    });
  }

  WorkoutPlayerRunning _runningState() => WorkoutPlayerRunning(
        exercise: _currentExercise,
        exerciseIndex: _exerciseIndex,
        totalExercises: _exercises.length,
        remainingSeconds: _remainingSeconds,
        isPaused: false,
        totalElapsed: _totalElapsed,
        routine: _routine!,
      );

  WorkoutPlayerPaused _pausedState() => WorkoutPlayerPaused(
        exercise: _currentExercise,
        exerciseIndex: _exerciseIndex,
        totalExercises: _exercises.length,
        remainingSeconds: _remainingSeconds,
        totalElapsed: _totalElapsed,
        routine: _routine!,
      );

  double _estimateCalories(int totalSeconds) =>
      double.parse((totalSeconds * 0.08).toStringAsFixed(1));

  @override
  Future<void> close() {
    _timerSubscription?.cancel();
    return super.close();
  }
}
