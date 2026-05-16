import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:deskdose/core/config/env_config.dart';
import 'package:deskdose/core/di/modules/auth_module.dart';
import 'package:deskdose/core/di/modules/core_module.dart';
import 'package:deskdose/core/di/modules/home_module.dart';
import 'package:deskdose/core/di/modules/hydration_module.dart';
import 'package:deskdose/core/di/modules/posture_module.dart';
import 'package:deskdose/core/di/modules/reminders_module.dart';
import 'package:deskdose/core/di/modules/routines_module.dart';
import 'package:deskdose/core/di/modules/subscription_module.dart';
import 'package:deskdose/core/network/supabase_client_wrapper.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GetIt sl = GetIt.instance;

/// Initializes all dependencies. Call before [runApp].
Future<void> initDependencies() async {
  await _initSupabase();
  CoreModule.register(sl);
  AuthModule.register(sl);
  RoutinesModule.register(sl);
  HomeModule.register(sl);
  RemindersModule.register(sl);
  HydrationModule.register(sl);
  PostureModule.register(sl);
  SubscriptionModule.register(sl);
}

Future<void> _initSupabase() async {
  if (EnvConfig.isConfigured) {
    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
    sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
    sl.registerLazySingleton<SupabaseClientWrapper>(
      () => SupabaseClientWrapperImpl(sl()),
    );
  } else {
    // Dev fallback: register wrapper with a placeholder client after init.
    // Production builds MUST provide .env credentials.
    sl.registerLazySingleton<SupabaseClientWrapper>(
      () => _UnconfiguredSupabaseWrapper(),
    );
  }

  sl.registerLazySingleton<Connectivity>(() => Connectivity());
}

/// Stub used when Supabase env vars are missing (local UI development).
class _UnconfiguredSupabaseWrapper implements SupabaseClientWrapper {
  @override
  SupabaseClient get client => throw UnimplementedError(
        'Supabase not configured. Add SUPABASE_URL and SUPABASE_ANON_KEY to .env',
      );

  @override
  User? get currentUser => null;

  @override
  bool get isAuthenticated => false;

  @override
  String? get currentUserId => null;

  @override
  Stream<AuthState> get authStateChanges => const Stream.empty();

  @override
  Future<T> execute<T>(Future<T> Function(SupabaseClient client) action) async {
    throw UnimplementedError('Supabase not configured');
  }
}
