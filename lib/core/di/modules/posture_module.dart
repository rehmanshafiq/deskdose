import 'package:deskdose/core/network/network_info.dart';
import 'package:deskdose/core/network/supabase_client_wrapper.dart';
import 'package:deskdose/features/posture/data/datasources/posture_remote_datasource.dart';
import 'package:deskdose/features/posture/data/repositories/posture_repository_impl.dart';
import 'package:deskdose/features/posture/domain/repositories/posture_repository.dart';
import 'package:deskdose/features/posture/domain/usecases/get_posture_routines_usecase.dart';
import 'package:deskdose/features/posture/presentation/bloc/posture_bloc.dart';
import 'package:get_it/get_it.dart';

abstract final class PostureModule {
  static void register(GetIt sl) {
    sl.registerLazySingleton<PostureRemoteDataSource>(
      () => PostureRemoteDataSourceImpl(sl<SupabaseClientWrapper>()),
    );

    sl.registerLazySingleton<PostureRepository>(
      () => PostureRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl<NetworkInfo>(),
      ),
    );

    sl.registerLazySingleton(() => GetPostureRoutinesUseCase(sl()));

    sl.registerFactory(() => PostureBloc(getPostureRoutines: sl()));
  }
}
