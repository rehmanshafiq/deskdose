import 'package:deskdose/features/routines/domain/usecases/complete_routine_usecase.dart';
import 'package:deskdose/features/routines/domain/usecases/get_routine_by_id_usecase.dart';
import 'package:deskdose/features/routines/domain/usecases/get_routines_usecase.dart';
import 'package:deskdose/features/routines/presentation/bloc/routine_event.dart';
import 'package:deskdose/features/routines/presentation/bloc/routine_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoutineBloc extends Bloc<RoutineEvent, RoutineState> {
  RoutineBloc({
    required GetRoutinesUseCase getRoutines,
    required GetRoutineByIdUseCase getRoutineById,
    required CompleteRoutineUseCase completeRoutine,
  })  : _getRoutines = getRoutines,
        _getRoutineById = getRoutineById,
        _completeRoutine = completeRoutine,
        super(const RoutineInitial()) {
    on<LoadRoutinesEvent>(_onLoadRoutines);
    on<LoadRoutineDetailEvent>(_onLoadRoutineDetail);
    on<CompleteRoutineEvent>(_onCompleteRoutine);
    on<RefreshRoutinesEvent>(_onRefreshRoutines);
  }

  final GetRoutinesUseCase _getRoutines;
  final GetRoutineByIdUseCase _getRoutineById;
  final CompleteRoutineUseCase _completeRoutine;

  Future<void> _onLoadRoutines(
    LoadRoutinesEvent event,
    Emitter<RoutineState> emit,
  ) async {
    emit(const RoutineLoading());
    final result = await _getRoutines(
      GetRoutinesParams(category: event.category),
    );
    result.fold(
      (failure) => emit(RoutineError(message: failure.message)),
      (routines) => emit(RoutineLoaded(routines: routines)),
    );
  }

  Future<void> _onLoadRoutineDetail(
    LoadRoutineDetailEvent event,
    Emitter<RoutineState> emit,
  ) async {
    final current = state;
    if (current is RoutineLoaded) {
      emit(current.copyWith(clearSelected: true));
    } else {
      emit(const RoutineLoading());
    }

    final result = await _getRoutineById(GetRoutineByIdParams(id: event.routineId));
    result.fold(
      (failure) => emit(RoutineError(message: failure.message)),
      (routine) {
        if (current is RoutineLoaded) {
          emit(current.copyWith(selectedRoutine: routine));
        } else {
          emit(RoutineLoaded(routines: const [], selectedRoutine: routine));
        }
      },
    );
  }

  Future<void> _onCompleteRoutine(
    CompleteRoutineEvent event,
    Emitter<RoutineState> emit,
  ) async {
    final current = state;
    if (current is! RoutineLoaded) return;

    emit(current.copyWith(isCompleting: true));

    final result = await _completeRoutine(
      CompleteRoutineParams(
        routineId: event.routineId,
        durationSeconds: event.durationSeconds,
        caloriesBurned: event.caloriesBurned,
      ),
    );

    result.fold(
      (failure) => emit(RoutineError(message: failure.message)),
      (session) => emit(
        current.copyWith(
          isCompleting: false,
          lastCompletedSession: session,
        ),
      ),
    );
  }

  Future<void> _onRefreshRoutines(
    RefreshRoutinesEvent event,
    Emitter<RoutineState> emit,
  ) async {
    add(const LoadRoutinesEvent());
  }
}
