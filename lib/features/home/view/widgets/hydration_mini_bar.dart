import 'package:deskdose/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class HydrationMiniBar extends StatelessWidget {
  const HydrationMiniBar({
    super.key,
    required this.waterMl,
    required this.goalMl,
    required this.onTap,
    this.cupSizeMl = 250,
  });

  final int waterMl;
  final int goalMl;
  final VoidCallback onTap;
  final int cupSizeMl;

  @override
  Widget build(BuildContext context) {
    final progress = goalMl > 0 ? (waterMl / goalMl).clamp(0.0, 1.0) : 0.0;
    final cupCount = (goalMl / cupSizeMl).ceil().clamp(1, 8);
    final filledCups = (waterMl / cupSizeMl).floor().clamp(0, cupCount);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outline),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.water_drop_outlined,
                      color: AppColors.hydrationAccent,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Hydration',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const Spacer(),
                    Text(
                      '${waterMl}ml / ${goalMl}ml',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: AppColors.outlineVariant,
                    color: AppColors.hydrationAccent,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(cupCount, (index) {
                    final filled = index < filledCups;
                    return Icon(
                      filled ? Icons.local_cafe : Icons.local_cafe_outlined,
                      size: 22,
                      color: filled
                          ? AppColors.hydrationAccent
                          : AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
