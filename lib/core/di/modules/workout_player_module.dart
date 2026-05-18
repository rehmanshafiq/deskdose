import 'package:deskdose/data/repositories/session_repository.dart';
import 'package:deskdose/features/workout_player/bloc/workout_player_bloc.dart';
import 'package:get_it/get_it.dart';

abstract final class WorkoutPlayerModule {
  static void register(GetIt sl) {
    sl.registerFactory(
      () => WorkoutPlayerBloc(sessionRepository: sl<SessionRepository>()),
    );
  }
}
