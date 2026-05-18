import 'package:deskdose/core/theme/app_theme.dart';
import 'package:deskdose/data/models/routine.dart';
import 'package:flutter/material.dart';

class RoutineCard extends StatelessWidget {
  const RoutineCard({
    super.key,
    required this.routine,
    required this.isPremium,
    required this.hasProAccess,
    required this.onTap,
  });

  final Routine routine;
  final bool isPremium;
  final bool hasProAccess;
  final VoidCallback onTap;

  bool get _isLocked => isPremium && !hasProAccess;

  @override
  Widget build(BuildContext context) {
    final style = _categoryStyle(routine.category);

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
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                _CategoryThumbnail(
                  emoji: style.emoji,
                  color: style.color,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              routine.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _BadgeChip(isPremium: isPremium),
                          if (_isLocked) ...[
                            const SizedBox(width: 6),
                            Icon(
                              Icons.lock,
                              size: 18,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_formatDuration(routine.durationSeconds)} · ${_capitalize(routine.difficulty)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds / 60).ceil();
    return '$minutes min';
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }

  _CategoryStyle _categoryStyle(String category) {
    return switch (category) {
      'stretch' => const _CategoryStyle('🧘', AppColors.primary),
      'eyes' => const _CategoryStyle('👁️', AppColors.hydrationAccent),
      'mobility' => const _CategoryStyle('🦴', AppColors.premiumAccent),
      'posture' => const _CategoryStyle('🧍', Color(0xFF9B6ED9)),
      _ => const _CategoryStyle('💪', AppColors.onSurfaceVariant),
    };
  }
}

class _CategoryThumbnail extends StatelessWidget {
  const _CategoryThumbnail({required this.emoji, required this.color});

  final String emoji;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.2),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      alignment: Alignment.center,
      child: Text(emoji, style: const TextStyle(fontSize: 24)),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({required this.isPremium});

  final bool isPremium;

  @override
  Widget build(BuildContext context) {
    final label = isPremium ? 'PRO' : 'FREE';
    final color = isPremium ? AppColors.premiumAccent : AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 10,
            ),
      ),
    );
  }
}

class _CategoryStyle {
  const _CategoryStyle(this.emoji, this.color);

  final String emoji;
  final Color color;
}
