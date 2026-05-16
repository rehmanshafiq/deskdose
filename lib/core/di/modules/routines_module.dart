import 'package:deskdose/core/identity/anonymous_user_id_provider.dart';
import 'package:deskdose/core/network/network_info.dart';
import 'package:deskdose/core/network/supabase_client_wrapper.dart';
import 'package:deskdose/features/routines/data/datasources/routine_remote_datasource.dart';
import 'package:deskdose/features/routines/data/repositories/routine_repository_impl.dart';
import 'package:deskdose/features/routines/domain/repositories/routine_repository.dart';
import 'package:deskdose/features/routines/domain/usecases/complete_routine_usecase.dart';
import 'package:deskdose/features/routines/domain/usecases/get_routine_by_id_usecase.dart';
import 'package:deskdose/features/routines/domain/usecases/get_routines_usecase.dart';
import 'package:deskdose/features/routines/presentation/bloc/routine_bloc.dart';
import 'package:get_it/get_it.dart';

abstract final class RoutinesModule {
  static void register(GetIt sl) {
    // Data sources
    sl.registerLazySingleton<RoutineRemoteDataSource>(
      () => RoutineRemoteDataSourceImpl(
        supabase: sl<SupabaseClientWrapper>(),
        anonymousUserId: sl<AnonymousUserIdProvider>(),
      ),
    );

    // Repositories
    sl.registerLazySingleton<RoutineRepository>(
      () => RoutineRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl<NetworkInfo>(),
      ),
    );

    // Use cases
    sl.registerLazySingleton(() => GetRoutinesUseCase(sl()));
    sl.registerLazySingleton(() => GetRoutineByIdUseCase(sl()));
    sl.registerLazySingleton(() => CompleteRoutineUseCase(sl()));

    // BLoCs — factory: new instance per screen
    sl.registerFactory(
      () => RoutineBloc(
        getRoutines: sl(),
        getRoutineById: sl(),
        completeRoutine: sl(),
      ),
    );
  }
}
