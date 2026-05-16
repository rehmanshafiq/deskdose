import 'package:deskdose/core/identity/anonymous_user_id_provider.dart';
import 'package:deskdose/core/network/network_info.dart';
import 'package:deskdose/core/network/supabase_client_wrapper.dart';
import 'package:deskdose/features/hydration/data/datasources/hydration_remote_datasource.dart';
import 'package:deskdose/features/hydration/data/repositories/hydration_repository_impl.dart';
import 'package:deskdose/features/hydration/domain/repositories/hydration_repository.dart';
import 'package:deskdose/features/hydration/domain/usecases/log_water_intake_usecase.dart';
import 'package:deskdose/features/hydration/presentation/bloc/hydration_bloc.dart';
import 'package:get_it/get_it.dart';

abstract final class HydrationModule {
  static void register(GetIt sl) {
    sl.registerLazySingleton<HydrationRemoteDataSource>(
      () => HydrationRemoteDataSourceImpl(
        supabase: sl<SupabaseClientWrapper>(),
        anonymousUserId: sl<AnonymousUserIdProvider>(),
      ),
    );

    sl.registerLazySingleton<HydrationRepository>(
      () => HydrationRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl<NetworkInfo>(),
      ),
    );

    sl.registerLazySingleton(() => LogWaterIntakeUseCase(sl()));

    sl.registerFactory(() => HydrationBloc(logWaterIntake: sl()));
  }
}
