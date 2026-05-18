import 'package:deskdose/data/repositories/hydration_repository.dart';
import 'package:deskdose/features/hydration/bloc/hydration_bloc.dart';
import 'package:get_it/get_it.dart';

abstract final class HydrationFeatureModule {
  static void register(GetIt sl) {
    sl.registerFactory(
      () => HydrationBloc(hydrationRepository: sl<HydrationRepository>()),
    );
  }
}
