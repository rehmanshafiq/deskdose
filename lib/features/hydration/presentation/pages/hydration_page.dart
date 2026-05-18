import 'package:deskdose/core/presentation/widgets/screen_safe_area.dart';
import 'package:deskdose/core/theme/app_theme.dart';
import 'package:deskdose/features/hydration/presentation/bloc/hydration_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HydrationPage extends StatelessWidget {
  const HydrationPage({super.key});

  static const _presets = [150, 250, 350, 500];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: ScreenSafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Hydration'),
            backgroundColor: AppColors.background,
          ),
          body: BlocConsumer<HydrationBloc, HydrationState>(
            listener: (context, state) {
              if (state is HydrationLogged) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Logged ${state.lastLog.amountMl}ml'),
                  ),
                );
              }
            },
            builder: (context, state) {
              final loading = state is HydrationLoading;
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Quick log',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _presets.map((ml) {
                        return ActionChip(
                          label: Text('${ml}ml'),
                          onPressed: loading
                              ? null
                              : () => context
                                  .read<HydrationBloc>()
                                  .add(LogWaterEvent(amountMl: ml)),
                        );
                      }).toList(),
                    ),
                    if (state is HydrationError) ...[
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
