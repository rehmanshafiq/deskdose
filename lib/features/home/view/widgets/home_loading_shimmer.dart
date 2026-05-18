import 'package:deskdose/core/presentation/widgets/shimmer_box.dart';
import 'package:flutter/material.dart';

class HomeLoadingShimmer extends StatelessWidget {
  const HomeLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: const [
        ShimmerBox(height: 32, width: 180),
        SizedBox(height: 8),
        ShimmerBox(height: 28, width: 120),
        SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: ShimmerBox(height: 88)),
            SizedBox(width: 12),
            Expanded(child: ShimmerBox(height: 88)),
            SizedBox(width: 12),
            Expanded(child: ShimmerBox(height: 88)),
          ],
        ),
        SizedBox(height: 24),
        ShimmerBox(height: 20, width: 100),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: ShimmerBox(height: 140)),
            SizedBox(width: 12),
            Expanded(child: ShimmerBox(height: 140)),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: ShimmerBox(height: 140)),
            SizedBox(width: 12),
            Expanded(child: ShimmerBox(height: 140)),
          ],
        ),
        SizedBox(height: 24),
        ShimmerBox(height: 100),
      ],
    );
  }
}
