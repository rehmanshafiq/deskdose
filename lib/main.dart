import 'package:deskdose/core/bloc_observer.dart';
import 'package:deskdose/core/config/env_config.dart';
import 'package:deskdose/core/constants/app_constants.dart';
import 'package:deskdose/core/di/injection.dart';
import 'package:deskdose/core/router/app_router.dart';
import 'package:deskdose/core/theme/app_theme.dart';
import 'package:deskdose/features/home/bloc/home_bloc.dart';
import 'package:deskdose/features/hydration/bloc/hydration_bloc.dart';
import 'package:deskdose/features/reminders/bloc/reminders_bloc.dart';
import 'package:deskdose/features/reminders/services/reminder_notification_service.dart';
import 'package:deskdose/features/routines/bloc/routines_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _loadEnvironment();
  await _initializeSupabase();
  Bloc.observer = AppBlocObserver();
  await setupLocator();
  await ReminderNotificationService.instance.initialize();

  runApp(const DeskDoseApp());
}

Future<void> _loadEnvironment() async {
  try {
    await dotenv.load(fileName: AppConstants.envFileName);
  } catch (_) {
    if (!EnvConfig.isConfigured &&
        const bool.fromEnvironment('dart.vm.product')) {
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<HomeBloc>()..add(const HomeLoadRequested()),
        ),
        BlocProvider(
          create: (_) => sl<RoutinesBloc>()..add(const RoutinesLoadRequested()),
        ),
        BlocProvider(
          create: (_) => sl<HydrationBloc>()
            ..add(HydrationLoadRequested(DateTime.now())),
        ),
        BlocProvider(
          create: (_) => sl<RemindersBloc>()..add(const RemindersLoadRequested()),
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
