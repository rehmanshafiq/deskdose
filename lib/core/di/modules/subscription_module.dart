import 'package:deskdose/features/subscription/data/datasources/subscription_remote_datasource.dart';
import 'package:deskdose/features/subscription/data/repositories/subscription_repository_impl.dart';
import 'package:deskdose/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:deskdose/features/subscription/domain/usecases/get_subscription_status_usecase.dart';
import 'package:deskdose/features/subscription/presentation/bloc/subscription_bloc.dart';
import 'package:get_it/get_it.dart';

abstract final class SubscriptionModule {
  static void register(GetIt sl) {
    // RevenueCat SDK will be wired here in production.
    sl.registerLazySingleton<SubscriptionRemoteDataSource>(
      SubscriptionRemoteDataSourceImpl.new,
    );

    sl.registerLazySingleton<SubscriptionRepository>(
      () => SubscriptionRepositoryImpl(remoteDataSource: sl()),
    );

    sl.registerLazySingleton(() => GetSubscriptionStatusUseCase(sl()));

    sl.registerFactory(() => SubscriptionBloc(getSubscriptionStatus: sl()));
  }
}
