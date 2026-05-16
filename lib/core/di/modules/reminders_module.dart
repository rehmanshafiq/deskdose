import 'package:deskdose/core/network/network_info.dart';
import 'package:deskdose/core/network/supabase_client_wrapper.dart';
import 'package:deskdose/features/reminders/data/datasources/reminder_remote_datasource.dart';
import 'package:deskdose/features/reminders/data/repositories/reminder_repository_impl.dart';
import 'package:deskdose/features/reminders/domain/repositories/reminder_repository.dart';
import 'package:deskdose/features/reminders/domain/usecases/get_reminder_settings_usecase.dart';
import 'package:deskdose/features/reminders/presentation/bloc/reminder_bloc.dart';
import 'package:get_it/get_it.dart';

abstract final class RemindersModule {
  static void register(GetIt sl) {
    sl.registerLazySingleton<ReminderRemoteDataSource>(
      () => ReminderRemoteDataSourceImpl(sl<SupabaseClientWrapper>()),
    );

    sl.registerLazySingleton<ReminderRepository>(
      () => ReminderRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl<NetworkInfo>(),
      ),
    );

    sl.registerLazySingleton(() => GetReminderSettingsUseCase(sl()));

    sl.registerFactory(() => ReminderBloc(getReminderSettings: sl()));
  }
}
