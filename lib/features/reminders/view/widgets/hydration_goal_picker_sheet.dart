import 'package:deskdose/core/theme/app_theme.dart';
import 'package:deskdose/features/hydration/bloc/hydration_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _HydrationGoalPickerCubit extends Cubit<int> {
  _HydrationGoalPickerCubit(int initialMl) : super(initialMl);

  void setGoalMl(int goalMl) => emit(goalMl);
}

class HydrationGoalPickerSheet extends StatelessWidget {
  const HydrationGoalPickerSheet({super.key, required this.initialGoalMl});

  final int initialGoalMl;

  static const minMl = 500;
  static const maxMl = 5000;
  static const stepMl = 100;

  static Future<void> show(BuildContext context, {required int initialGoalMl}) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => BlocProvider(
        create: (_) => _HydrationGoalPickerCubit(initialGoalMl),
        child: HydrationGoalPickerSheet(initialGoalMl: initialGoalMl),
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
          Text(
            'Daily water goal',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          BlocBuilder<_HydrationGoalPickerCubit, int>(
            builder: (context, goalMl) {
              final steps = (maxMl - minMl) ~/ stepMl;
              final index = ((goalMl - minMl) / stepMl).round().clamp(0, steps);

              return Column(
                children: [
                  Text(
                    '$goalMl ml',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: const Color(0xFF378ADD),
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Slider(
                    value: index.toDouble(),
                    min: 0,
                    max: steps.toDouble(),
                    divisions: steps,
                    label: '$goalMl ml',
                    onChanged: (value) {
                      context.read<_HydrationGoalPickerCubit>().setGoalMl(
                            minMl + value.round() * stepMl,
                          );
                    },
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () {
              final goalMl = context.read<_HydrationGoalPickerCubit>().state;
              context.read<HydrationBloc>().add(HydrationGoalChanged(goalMl));
              Navigator.of(context).pop();
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
