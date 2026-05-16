import 'package:deskdose/features/home/domain/entities/daily_stats_entity.dart';
import 'package:flutter/material.dart';

class DailyStatsCard extends StatelessWidget {
  const DailyStatsCard({super.key, required this.stats});

  final DailyStatsEntity stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Today's Wellness", style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  value: '${stats.workoutsCompleted}',
                  label: 'Workouts',
                  icon: Icons.fitness_center,
                ),
                _StatItem(
                  value: '${stats.totalWorkoutMinutes}m',
                  label: 'Active',
                  icon: Icons.timer,
                ),
                _StatItem(
                  value: '${stats.hydrationMl}ml',
                  label: 'Water',
                  icon: Icons.water_drop,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(height: 8),
        Text(value, style: theme.textTheme.titleLarge),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
