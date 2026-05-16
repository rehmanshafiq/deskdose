part of 'posture_bloc.dart';

sealed class PostureState extends Equatable {
  const PostureState();

  @override
  List<Object?> get props => [];
}

class PostureInitial extends PostureState {
  const PostureInitial();
}

class PostureLoading extends PostureState {
  const PostureLoading();
}

class PostureLoaded extends PostureState {
  const PostureLoaded({required this.routines});

  final List<RoutineEntity> routines;

  @override
  List<Object?> get props => [routines];
}

class PostureError extends PostureState {
  const PostureError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
