import 'package:deskdose/core/presentation/widgets/shimmer_box.dart';
import 'package:flutter/material.dart';

/// Skeleton layout for [SettingsScreen] while loading.
class SettingsLoadingShimmer extends StatelessWidget {
  const SettingsLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: const [
        ShimmerBox(height: 88, borderRadius: 16),
        SizedBox(height: 28),
        ShimmerBox(height: 16, width: 90, borderRadius: 8),
        SizedBox(height: 12),
        _SettingsRowShimmer(),
        _SettingsRowShimmer(),
        _SettingsRowShimmer(),
        SizedBox(height: 28),
        ShimmerBox(height: 16, width: 100, borderRadius: 8),
        SizedBox(height: 12),
        _SettingsRowShimmer(),
        _SettingsRowShimmer(),
        SizedBox(height: 28),
        ShimmerBox(height: 16, width: 80, borderRadius: 8),
        SizedBox(height: 12),
        _SettingsRowShimmer(),
        _SettingsRowShimmer(),
      ],
    );
  }
}

class _SettingsRowShimmer extends StatelessWidget {
  const _SettingsRowShimmer();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ShimmerBox(height: 40, width: 40, borderRadius: 12),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(height: 16, width: 160, borderRadius: 8),
                SizedBox(height: 8),
                ShimmerBox(height: 12, borderRadius: 6),
              ],
            ),
          ),
          SizedBox(width: 12),
          ShimmerBox(height: 28, width: 48, borderRadius: 14),
        ],
      ),
    );
  }
}
