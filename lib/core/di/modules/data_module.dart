import 'package:deskdose/core/config/env_config.dart';
import 'package:deskdose/data/datasources/supabase_datasource.dart';
import 'package:deskdose/data/repositories/hydration_repository.dart';
import 'package:deskdose/data/repositories/hydration_repository_impl.dart';
import 'package:deskdose/data/repositories/reminder_repository.dart';
import 'package:deskdose/data/repositories/reminder_repository_impl.dart';
import 'package:deskdose/data/repositories/routine_repository.dart';
import 'package:deskdose/data/repositories/routine_repository_impl.dart';
import 'package:deskdose/data/repositories/session_repository.dart';
import 'package:deskdose/data/repositories/session_repository_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract final class DataModule {
  static void register(GetIt sl) {
    if (!EnvConfig.isConfigured) return;

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
}
