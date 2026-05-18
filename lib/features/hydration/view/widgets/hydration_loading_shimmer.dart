import 'package:deskdose/core/presentation/widgets/shimmer_box.dart';
import 'package:flutter/material.dart';

/// Skeleton layout for [HydrationScreen] while loading.
class HydrationLoadingShimmer extends StatelessWidget {
  const HydrationLoadingShimmer({super.key});

  static const _base = Color(0xFF1A2438);
  static const _highlight = Color(0xFF243044);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: const [
        ShimmerBox(
          height: 28,
          width: 120,
          baseColor: _base,
          highlightColor: _highlight,
        ),
        SizedBox(height: 24),
        Center(
          child: ShimmerBox(
            height: 200,
            width: 200,
            borderRadius: 100,
            shape: BoxShape.circle,
            baseColor: _base,
            highlightColor: _highlight,
          ),
        ),
        SizedBox(height: 12),
        Center(
          child: ShimmerBox(
            height: 18,
            width: 100,
            borderRadius: 8,
            baseColor: _base,
            highlightColor: _highlight,
          ),
        ),
        SizedBox(height: 28),
        Row(
          children: [
            Expanded(
              child: ShimmerBox(
                height: 100,
                baseColor: _base,
                highlightColor: _highlight,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ShimmerBox(
                height: 100,
                baseColor: _base,
                highlightColor: _highlight,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ShimmerBox(
                height: 100,
                baseColor: _base,
                highlightColor: _highlight,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ShimmerBox(
                height: 100,
                baseColor: _base,
                highlightColor: _highlight,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Center(
          child: ShimmerBox(
            height: 36,
            width: 160,
            borderRadius: 20,
            baseColor: _base,
            highlightColor: _highlight,
          ),
        ),
        SizedBox(height: 24),
        ShimmerBox(
          height: 22,
          width: 100,
          borderRadius: 8,
          baseColor: _base,
          highlightColor: _highlight,
        ),
        SizedBox(height: 12),
        ShimmerBox(height: 56, baseColor: _base, highlightColor: _highlight),
        SizedBox(height: 8),
        ShimmerBox(height: 56, baseColor: _base, highlightColor: _highlight),
        SizedBox(height: 8),
        ShimmerBox(height: 56, baseColor: _base, highlightColor: _highlight),
      ],
    );
  }
}
