import 'package:deskdose/core/di/injection_container.dart';
import 'package:deskdose/features/reminders/presentation/bloc/reminder_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RemindersPage extends StatelessWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ReminderBloc>()..add(const LoadRemindersEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Reminders')),
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
    );
  }
}
