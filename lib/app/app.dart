import 'package:deskdose/core/constants/app_constants.dart';
import 'package:deskdose/core/di/injection_container.dart';
import 'package:deskdose/core/router/app_router.dart';
import 'package:deskdose/core/theme/app_theme.dart';
import 'package:deskdose/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:deskdose/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeskDoseApp extends StatefulWidget {
  const DeskDoseApp({super.key});

  @override
  State<DeskDoseApp> createState() => _DeskDoseAppState();
}

class _DeskDoseAppState extends State<DeskDoseApp> {
  late final AuthBloc _authBloc;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>()..add(const AppStarted());
    _appRouter = AppRouter(authBloc: _authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authBloc,
      child: MaterialApp.router(
        title: AppConstants.appName,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        routerConfig: _appRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
