import 'package:deskdose/core/network/network_info.dart';
import 'package:deskdose/core/network/supabase_client_wrapper.dart';
import 'package:deskdose/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:deskdose/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:deskdose/features/auth/domain/repositories/auth_repository.dart';
import 'package:deskdose/features/auth/domain/usecases/get_current_user.dart';
import 'package:deskdose/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:deskdose/features/auth/domain/usecases/sign_out.dart';
import 'package:deskdose/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';

abstract final class AuthModule {
  static void register(GetIt sl) {
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl<SupabaseClientWrapper>()),
    );

    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl<NetworkInfo>(),
      ),
    );

    sl.registerLazySingleton(() => SignInWithGoogleUseCase(sl()));
    sl.registerLazySingleton(() => SignOutUseCase(sl()));
    sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

    sl.registerLazySingleton(
      () => AuthBloc(
        signInWithGoogle: sl(),
        signOut: sl(),
        getCurrentUser: sl(),
        supabaseWrapper: sl<SupabaseClientWrapper>(),
      ),
    );
  }
}
