import 'package:deskdose/features/routines/domain/entities/routine_entity.dart';
import 'package:flutter/material.dart';

class RoutineCard extends StatelessWidget {
  const RoutineCard({
    super.key,
    required this.routine,
    required this.onTap,
  });

  final RoutineEntity routine;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _CategoryIcon(category: routine.category),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            routine.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (routine.isPremium)
                          Icon(
                            Icons.workspace_premium,
                            size: 18,
                            color: theme.colorScheme.tertiary,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      routine.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _ChipLabel(
                          icon: Icons.timer_outlined,
                          label: routine.formattedDuration,
                        ),
                        const SizedBox(width: 8),
                        _ChipLabel(
                          icon: Icons.fitness_center_outlined,
                          label: '${routine.exerciseCount} exercises',
                        ),
                        const SizedBox(width: 8),
                        _ChipLabel(
                          label: routine.difficulty.name,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({required this.category});

  final RoutineCategory category;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (category) {
      RoutineCategory.stretch => (Icons.self_improvement, Colors.teal),
      RoutineCategory.mobility => (Icons.directions_walk, Colors.blue),
      RoutineCategory.strength => (Icons.fitness_center, Colors.orange),
      RoutineCategory.breathing => (Icons.air, Colors.cyan),
      RoutineCategory.posture => (Icons.accessibility_new, Colors.indigo),
      RoutineCategory.eyes => (Icons.remove_red_eye, Colors.purple),
    };

    return CircleAvatar(
      backgroundColor: color.withValues(alpha: 0.15),
      child: Icon(icon, color: color, size: 22),
    );
  }
}

class _ChipLabel extends StatelessWidget {
  const _ChipLabel({this.icon, required this.label});

  final IconData? icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 14, color: theme.colorScheme.outline),
          const SizedBox(width: 2),
        ],
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
      ],
    );
  }
}
