import 'package:deskdose/core/usecases/usecase.dart';
import 'package:deskdose/features/posture/domain/usecases/get_posture_routines_usecase.dart';
import 'package:deskdose/features/routines/domain/entities/routine_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'posture_event.dart';
part 'posture_state.dart';

class PostureBloc extends Bloc<PostureEvent, PostureState> {
  PostureBloc({required GetPostureRoutinesUseCase getPostureRoutines})
      : _getPostureRoutines = getPostureRoutines,
        super(const PostureInitial()) {
    on<LoadPostureRoutinesEvent>(_onLoad);
  }

  final GetPostureRoutinesUseCase _getPostureRoutines;

  Future<void> _onLoad(
    LoadPostureRoutinesEvent event,
    Emitter<PostureState> emit,
  ) async {
    emit(const PostureLoading());
    final result = await _getPostureRoutines(const NoParams());
    result.fold(
      (f) => emit(PostureError(message: f.message)),
      (routines) => emit(PostureLoaded(routines: routines)),
    );
  }
}
