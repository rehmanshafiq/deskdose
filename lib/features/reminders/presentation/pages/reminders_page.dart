import 'package:deskdose/core/presentation/widgets/screen_safe_area.dart';
import 'package:deskdose/core/theme/app_theme.dart';
import 'package:deskdose/features/reminders/presentation/bloc/reminder_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  @override
  void initState() {
    super.initState();
    context.read<ReminderBloc>().add(const LoadRemindersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: ScreenSafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Reminders'),
            backgroundColor: AppColors.background,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          body: BlocBuilder<ReminderBloc, ReminderState>(
        builder: (context, state) {
          return switch (state) {
            ReminderLoading() || ReminderInitial() =>
              const Center(child: CircularProgressIndicator()),
            ReminderError(:final message) => Center(child: Text(message)),
            ReminderLoaded(:final settings) => settings.isEmpty
                ? const Center(
                    child: Text('No reminders configured yet.'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: settings.length,
                    itemBuilder: (_, i) {
                      final s = settings[i];
                      return Card(
                        child: SwitchListTile(
                          title: Text(s.type.name),
                          subtitle: Text('Every ${s.intervalMinutes} min'),
                          value: s.isEnabled,
                          onChanged: null,
                        ),
                      );
                    },
                  ),
          };
        },
          ),
        ),
      ),
    );
  }
}
