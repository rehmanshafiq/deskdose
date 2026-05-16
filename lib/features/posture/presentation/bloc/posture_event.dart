part of 'posture_bloc.dart';

abstract class PostureEvent extends Equatable {
  const PostureEvent();

  @override
  List<Object?> get props => [];
}

class LoadPostureRoutinesEvent extends PostureEvent {
  const LoadPostureRoutinesEvent();
}
