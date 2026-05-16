import 'package:deskdose/core/identity/anonymous_user_id_provider.dart';
import 'package:deskdose/core/network/network_info.dart';
import 'package:deskdose/core/network/supabase_client_wrapper.dart';
import 'package:deskdose/features/home/data/datasources/home_remote_datasource.dart';
import 'package:deskdose/features/home/data/repositories/home_repository_impl.dart';
import 'package:deskdose/features/home/domain/repositories/home_repository.dart';
import 'package:deskdose/features/home/domain/usecases/get_daily_stats_usecase.dart';
import 'package:deskdose/features/home/presentation/bloc/home_bloc.dart';
import 'package:get_it/get_it.dart';

abstract final class HomeModule {
  static void register(GetIt sl) {
    sl.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(
        supabase: sl<SupabaseClientWrapper>(),
        anonymousUserId: sl<AnonymousUserIdProvider>(),
      ),
    );

    sl.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl<NetworkInfo>(),
      ),
    );

    sl.registerLazySingleton(() => GetDailyStatsUseCase(sl()));

    sl.registerFactory(
      () => HomeBloc(getDailyStats: sl()),
    );
  }
}
