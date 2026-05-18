import 'package:deskdose/data/repositories/hydration_repository.dart';
import 'package:deskdose/data/repositories/routine_repository.dart';
import 'package:deskdose/data/repositories/session_repository.dart';
import 'package:deskdose/features/home/bloc/home_bloc.dart';
import 'package:get_it/get_it.dart';

abstract final class HomeModule {
  static void register(GetIt sl) {
    sl.registerFactory(
      () => HomeBloc(
        routineRepository: sl<RoutineRepository>(),
        sessionRepository: sl<SessionRepository>(),
        hydrationRepository: sl<HydrationRepository>(),
      ),
    );
  }
}
