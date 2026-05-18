import 'package:deskdose/core/presentation/widgets/shimmer_box.dart';
import 'package:deskdose/features/routines/view/widgets/routines_header.dart';
import 'package:flutter/material.dart';

/// Skeleton layout for [RoutinesScreen] while loading.
class RoutinesLoadingShimmer extends StatelessWidget {
  const RoutinesLoadingShimmer({super.key, this.showBackButton = false});

  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        RoutinesHeader(showBackButton: showBackButton),
        const SizedBox(height: 16),
        const _FilterChipsShimmer(),
        const SizedBox(height: 16),
        ...List.generate(
          5,
          (_) => const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: _RoutineCardShimmer(),
          ),
        ),
      ],
    );
  }
}

class _FilterChipsShimmer extends StatelessWidget {
  const _FilterChipsShimmer();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 40,
      child: Row(
        children: [
          ShimmerBox(height: 36, width: 56, borderRadius: 20),
          SizedBox(width: 8),
          ShimmerBox(height: 36, width: 72, borderRadius: 20),
          SizedBox(width: 8),
          ShimmerBox(height: 36, width: 88, borderRadius: 20),
          SizedBox(width: 8),
          ShimmerBox(height: 36, width: 80, borderRadius: 20),
        ],
      ),
    );
  }
}

class _RoutineCardShimmer extends StatelessWidget {
  const _RoutineCardShimmer();

  @override
  Widget build(BuildContext context) {
    return const ShimmerBox(height: 120, borderRadius: 16);
  }
}
