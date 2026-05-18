import 'package:deskdose/core/presentation/widgets/screen_safe_area.dart';
import 'package:deskdose/core/router/app_routes.dart';
import 'package:deskdose/core/theme/app_theme.dart';
import 'package:deskdose/features/workout_player/bloc/workout_player_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class WorkoutCompleteScreen extends StatelessWidget {
  const WorkoutCompleteScreen({super.key, required this.result});

  final WorkoutPlayerComplete result;

  @override
  Widget build(BuildContext context) {
    final minutes = result.totalSeconds ~/ 60;
    final seconds = result.totalSeconds % 60;
    final durationLabel = minutes > 0
        ? '${minutes}m ${seconds}s'
        : '${result.totalSeconds}s';

    return Material(
      color: AppColors.background,
      child: ScreenSafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              SizedBox(
                height: 200,
                child: Lottie.asset(
                  'assets/lottie/confetti.json',
                  repeat: true,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.celebration,
                    size: 120,
                    color: AppColors.premiumAccent,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Workout complete!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                result.routine.title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 32),
              _StatTile(label: 'Duration', value: durationLabel),
              const SizedBox(height: 12),
              _StatTile(
                label: 'Calories',
                value: '${result.caloriesBurned} kcal',
              ),
              const SizedBox(height: 12),
              _StatTile(
                label: 'Exercises',
                value: '${result.exercisesCompleted} done',
              ),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  context.go(AppRoutes.routines);
                },
                child: const Text('Log another session'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
          ),
        ],
      ),
    );
  }
}
