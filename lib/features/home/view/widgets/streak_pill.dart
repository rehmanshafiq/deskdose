import 'package:deskdose/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class StreakPill extends StatelessWidget {
  const StreakPill({super.key, required this.streakDays});

  final int streakDays;

  @override
  Widget build(BuildContext context) {
    final label = '$streakDays day streak';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.premiumAccent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.premiumAccent.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.premiumAccent,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
