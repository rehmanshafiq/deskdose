import 'package:deskdose/data/repositories/routine_repository.dart';
import 'package:deskdose/features/routines/bloc/routines_bloc.dart';
import 'package:get_it/get_it.dart';

abstract final class RoutinesFeatureModule {
  static void register(GetIt sl) {
    sl.registerFactory(
      () => RoutinesBloc(routineRepository: sl<RoutineRepository>()),
    );
  }
}
