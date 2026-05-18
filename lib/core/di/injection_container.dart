import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:deskdose/core/config/env_config.dart';
import 'package:deskdose/core/di/modules/core_module.dart';
import 'package:deskdose/core/di/modules/data_module.dart';
import 'package:deskdose/core/di/modules/home_module.dart';
import 'package:deskdose/core/di/modules/hydration_module.dart';
import 'package:deskdose/core/di/modules/posture_module.dart';
import 'package:deskdose/core/di/modules/reminders_module.dart';
import 'package:deskdose/core/di/modules/routines_module.dart';
import 'package:deskdose/core/di/modules/subscription_module.dart';
import 'package:deskdose/core/identity/anonymous_user_id_provider.dart';
import 'package:deskdose/core/network/supabase_client_wrapper.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GetIt sl = GetIt.instance;

/// Initializes all dependencies. Call after Supabase and dotenv are ready.
Future<void> initDependencies() async {
  if (EnvConfig.isConfigured) {
    sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
    sl.registerLazySingleton<SupabaseClientWrapper>(
      () => SupabaseClientWrapperImpl(sl()),
    );
  } else {
    sl.registerLazySingleton<SupabaseClientWrapper>(
      () => _UnconfiguredSupabaseWrapper(),
    );
  }

  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  CoreModule.register(sl);
  DataModule.register(sl);
  await sl<AnonymousUserIdProvider>().getOrCreate();
  RoutinesModule.register(sl);
  HomeModule.register(sl);
  RemindersModule.register(sl);
  HydrationModule.register(sl);
  PostureModule.register(sl);
  SubscriptionModule.register(sl);
}

class _UnconfiguredSupabaseWrapper implements SupabaseClientWrapper {
  @override
  SupabaseClient get client => throw UnimplementedError(
        'Supabase not configured. Add SUPABASE_URL and SUPABASE_ANON_KEY to .env',
      );

  @override
  Future<T> execute<T>(Future<T> Function(SupabaseClient client) action) async {
    throw UnimplementedError('Supabase not configured');
  }
}
