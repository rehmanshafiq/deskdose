import 'package:deskdose/core/bloc_observer.dart';
import 'package:deskdose/core/config/env_config.dart';
import 'package:deskdose/core/constants/app_constants.dart';
import 'package:deskdose/core/di/injection.dart';
import 'package:deskdose/core/router/app_router.dart';
import 'package:deskdose/core/theme/app_theme.dart';
import 'package:deskdose/core/utils/anonymous_user_helper.dart';
import 'package:deskdose/features/home/bloc/home_bloc.dart';
import 'package:deskdose/features/hydration/bloc/hydration_bloc.dart';
import 'package:deskdose/features/reminders/bloc/reminders_bloc.dart';
import 'package:deskdose/features/reminders/services/reminder_notification_service.dart';
import 'package:deskdose/features/routines/bloc/routines_bloc.dart';
import 'package:deskdose/features/subscription/presentation/bloc/subscription_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1️⃣ Load .env first — everything depends on this
  await _loadEnvironment();

  // 2️⃣ Initialize Supabase — must be before any client usage
  await _initializeSupabase();

  // 3️⃣ Setup GetIt locator — registers SharedPreferences and all repos
  //    Must be BEFORE getOrCreateAnonymousUserId()
  await setupLocator();

  // 4️⃣ BLoC observer — set before any BLoC is created
  Bloc.observer = AppBlocObserver();

  // 5️⃣ Anonymous user ID — now safe, SharedPreferences is registered
  final userId = await getOrCreateAnonymousUserId();

  // 6️⃣ Set RLS user context — wrapped in try/catch so offline users
  //    can still open the app (RLS will re-apply on next warm start)
  if (EnvConfig.isConfigured) {
    try {
      await Supabase.instance.client.rpc(
        'set_user_context',
        params: {'user_id': userId},
      );
    } catch (e) {
      // Non-fatal: app works offline, RLS context set on next launch
      debugPrint('⚠️ Could not set user context: $e');
    }
  }

  // 7️⃣ Notification service — last, depends on everything above
  await ReminderNotificationService.instance.initialize();

  runApp(const DeskDoseApp());
}

Future<void> _loadEnvironment() async {
  try {
    await dotenv.load(fileName: AppConstants.envFileName);
  } catch (_) {
    debugPrint(
      'Warning: ${AppConstants.envFileName} not found. '
          'Set SUPABASE_URL and SUPABASE_ANON_KEY.',
    );
  }
}

Future<void> _initializeSupabase() async {
  // Guard: skip if .env keys are missing (e.g. during unit tests)
  if (!EnvConfig.isConfigured) {
    debugPrint('⚠️ Supabase not initialized — EnvConfig not configured.');
    return;
  }
  await Supabase.initialize(
    url: EnvConfig.supabaseUrl,
    anonKey: EnvConfig.supabaseAnonKey,
  );
}

class DeskDoseApp extends StatelessWidget {
  const DeskDoseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<HomeBloc>()..add(const HomeLoadRequested()),
        ),
        BlocProvider(
          create: (_) =>
          sl<RoutinesBloc>()..add(const RoutinesLoadRequested()),
        ),
        BlocProvider(
          create: (_) =>
          sl<HydrationBloc>()..add(HydrationLoadRequested(DateTime.now())),
        ),
        BlocProvider(
          create: (_) =>
          sl<RemindersBloc>()..add(const RemindersLoadRequested()),
        ),
        BlocProvider(
          create: (_) =>
          sl<SubscriptionBloc>()..add(const LoadSubscriptionEvent()),
        ),
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        theme: AppTheme.dark,
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}