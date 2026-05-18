import 'package:deskdose/core/presentation/widgets/screen_safe_area.dart';
import 'package:deskdose/core/router/app_routes.dart';
import 'package:deskdose/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: ScreenSafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Settings'),
            backgroundColor: AppColors.background,
          ),
          body: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: const Text('Reminders'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(AppRoutes.reminders),
              ),
              ListTile(
                leading: const Icon(Icons.workspace_premium_outlined),
                title: const Text('Premium'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(AppRoutes.subscription),
              ),
              ListTile(
                leading: const Icon(Icons.self_improvement_outlined),
                title: const Text('Posture routines'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(AppRoutes.posture),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
