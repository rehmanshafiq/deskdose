import 'package:deskdose/core/base/app_bloc_observer.dart';
import 'package:deskdose/core/config/env_config.dart';
import 'package:deskdose/core/constants/app_constants.dart';
import 'package:deskdose/core/di/injection_container.dart';
import 'package:deskdose/core/router/app_router.dart';
import 'package:deskdose/core/theme/app_theme.dart';
import 'package:deskdose/core/utils/anonymous_user_helper.dart';
import 'package:deskdose/features/home/presentation/bloc/home_bloc.dart';
import 'package:deskdose/features/home/presentation/bloc/home_event.dart';
import 'package:deskdose/features/hydration/presentation/bloc/hydration_bloc.dart';
import 'package:deskdose/features/posture/presentation/bloc/posture_bloc.dart';
import 'package:deskdose/features/reminders/presentation/bloc/reminder_bloc.dart';
import 'package:deskdose/features/routines/presentation/bloc/routine_bloc.dart';
import 'package:deskdose/features/subscription/presentation/bloc/subscription_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _loadEnvironment();
  await _initializeSupabase();
  Bloc.observer = AppBlocObserver();
  await initDependencies();
  await getOrCreateAnonymousUserId();

  runApp(const DeskDoseApp());
}

Future<void> _loadEnvironment() async {
  try {
    await dotenv.load(fileName: AppConstants.envFileName);
  } catch (_) {
    if (!EnvConfig.isConfigured && const bool.fromEnvironment('dart.vm.product')) {
      debugPrint(
        'Warning: ${AppConstants.envFileName} not found. '
        'Set SUPABASE_URL and SUPABASE_ANON_KEY.',
      );
    }
  }
}

Future<void> _initializeSupabase() async {
  if (!EnvConfig.isConfigured) return;

  await Supabase.initialize(
    url: EnvConfig.supabaseUrl,
    anonKey: EnvConfig.supabaseAnonKey,
  );
}

class DeskDoseApp extends StatelessWidget {
  const DeskDoseApp({super.key});

  static final _router = AppRouter().router;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<HomeBloc>()..add(const LoadDailyStatsEvent()),
        ),
        BlocProvider(create: (_) => sl<RoutineBloc>()),
        BlocProvider(create: (_) => sl<ReminderBloc>()),
        BlocProvider(create: (_) => sl<HydrationBloc>()),
        BlocProvider(create: (_) => sl<PostureBloc>()),
        BlocProvider(create: (_) => sl<SubscriptionBloc>()),
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        theme: AppTheme.dark,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
