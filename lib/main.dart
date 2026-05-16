import 'package:deskdose/app/app.dart';
import 'package:deskdose/core/base/app_bloc_observer.dart';
import 'package:deskdose/core/config/env_config.dart';
import 'package:deskdose/core/constants/app_constants.dart';
import 'package:deskdose/core/di/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _loadEnvironment();
  Bloc.observer = AppBlocObserver();
  await initDependencies();

  runApp(const DeskDoseApp());
}

Future<void> _loadEnvironment() async {
  try {
    await dotenv.load(fileName: AppConstants.envFileName);
  } catch (_) {
    // .env is optional in development; use --dart-define for CI builds.
    if (!EnvConfig.isConfigured && const bool.fromEnvironment('dart.vm.product')) {
      debugPrint(
        'Warning: ${AppConstants.envFileName} not found. '
        'Set SUPABASE_URL and SUPABASE_ANON_KEY.',
      );
    }
  }
}
