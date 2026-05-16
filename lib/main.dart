import 'package:deskdose/app/app.dart';
import 'package:deskdose/core/base/app_bloc_observer.dart';
import 'package:deskdose/core/config/env_config.dart';
import 'package:deskdose/core/constants/app_constants.dart';
import 'package:deskdose/core/di/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  await _loadEnvironment();
  Bloc.observer = AppBlocObserver();
  await initDependencies();

  runApp(DeskDoseApp());
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
