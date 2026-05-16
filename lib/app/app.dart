import 'package:deskdose/core/constants/app_constants.dart';
import 'package:deskdose/core/router/app_router.dart';
import 'package:deskdose/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DeskDoseApp extends StatelessWidget {
  DeskDoseApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: _appRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
