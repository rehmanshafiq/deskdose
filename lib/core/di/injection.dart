import 'package:deskdose/core/config/env_config.dart';
import 'package:deskdose/core/identity/anonymous_user_id_provider.dart';
import 'package:deskdose/core/utils/anonymous_user_helper.dart';
import 'package:deskdose/data/datasources/supabase_datasource.dart';
import 'package:deskdose/data/repositories/hydration_repository.dart';
import 'package:deskdose/data/repositories/hydration_repository_impl.dart';
import 'package:deskdose/data/repositories/reminder_repository.dart';
import 'package:deskdose/data/repositories/reminder_repository_impl.dart';
import 'package:deskdose/data/repositories/routine_repository.dart';
import 'package:deskdose/data/repositories/routine_repository_impl.dart';
import 'package:deskdose/data/repositories/session_repository.dart';
import 'package:deskdose/data/repositories/session_repository_impl.dart';
import 'package:deskdose/features/home/bloc/home_bloc.dart';
import 'package:deskdose/features/hydration/bloc/hydration_bloc.dart';
import 'package:deskdose/features/reminders/bloc/reminders_bloc.dart';
import 'package:deskdose/features/reminders/services/reminder_notification_service.dart';
import 'package:deskdose/features/routines/bloc/routines_bloc.dart';
import 'package:deskdose/features/workout_player/bloc/workout_player_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GetIt sl = GetIt.instance;

/// Registers all app dependencies. Call after Supabase init and dotenv load.
Future<void> setupLocator() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  sl.registerLazySingleton<AnonymousUserIdProvider>(
    AnonymousUserIdProviderImpl.new,
  );

  if (EnvConfig.isConfigured) {
    sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

    sl.registerLazySingleton<SupabaseDataSource>(
      () => SupabaseDataSource(sl<SupabaseClient>()),
    );

    sl.registerLazySingleton<RoutineRepository>(
      () => RoutineRepositoryImpl(sl<SupabaseDataSource>()),
    );

    sl.registerLazySingleton<SessionRepository>(
      () => SessionRepositoryImpl(sl<SupabaseDataSource>()),
    );

    sl.registerLazySingleton<HydrationRepository>(
      () => HydrationRepositoryImpl(sl<SupabaseDataSource>()),
    );

    sl.registerLazySingleton<ReminderRepository>(
      () => ReminderRepositoryImpl(sl<SupabaseDataSource>()),
    );
  }

  sl.registerLazySingleton<ReminderNotificationService>(
    () => ReminderNotificationService.instance,
  );

  sl.registerFactory(
    () => HomeBloc(
      routineRepository: sl<RoutineRepository>(),
      sessionRepository: sl<SessionRepository>(),
      hydrationRepository: sl<HydrationRepository>(),
    ),
  );

  sl.registerFactory(
    () => RoutinesBloc(routineRepository: sl<RoutineRepository>()),
  );

  sl.registerFactory(
    () => HydrationBloc(hydrationRepository: sl<HydrationRepository>()),
  );

  sl.registerFactory(
    () => RemindersBloc(
      reminderRepository: sl<ReminderRepository>(),
      notificationService: sl<ReminderNotificationService>(),
    ),
  );

  sl.registerFactory(
    () => WorkoutPlayerBloc(sessionRepository: sl<SessionRepository>()),
  );

  await sl<AnonymousUserIdProvider>().getOrCreate();
  await getOrCreateAnonymousUserId();
}
