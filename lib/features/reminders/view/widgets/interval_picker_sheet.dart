import 'package:deskdose/core/theme/app_theme.dart';
import 'package:deskdose/features/reminders/bloc/reminders_bloc.dart';
import 'package:deskdose/features/reminders/cubit/interval_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IntervalPickerSheet extends StatelessWidget {
  const IntervalPickerSheet({
    super.key,
    required this.reminderType,
    required this.initialMinutes,
  });

  final String reminderType;
  final int initialMinutes;

  static Future<void> show(
    BuildContext context, {
    required String reminderType,
    required int initialMinutes,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => BlocProvider(
        create: (_) => IntervalPickerCubit(initialMinutes),
        child: IntervalPickerSheet(
          reminderType: reminderType,
          initialMinutes: initialMinutes,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        24 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Reminder interval',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          BlocBuilder<IntervalPickerCubit, int>(
            builder: (context, minutes) {
              final values = IntervalPickerCubit.allowedValues;
              final index = values.indexOf(minutes).clamp(0, values.length - 1);

              return Column(
                children: [
                  Text(
                    'Every $minutes minutes',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Slider(
                    value: index.toDouble(),
                    min: 0,
                    max: (values.length - 1).toDouble(),
                    divisions: values.length - 1,
                    label: '$minutes min',
                    onChanged: (value) {
                      context
                          .read<IntervalPickerCubit>()
                          .setMinutes(values[value.round()]);
                    },
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () {
              final minutes = context.read<IntervalPickerCubit>().state;
              context.read<RemindersBloc>().add(
                    ReminderIntervalChanged(
                      type: reminderType,
                      intervalMinutes: minutes,
                    ),
                  );
              Navigator.of(context).pop();
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
