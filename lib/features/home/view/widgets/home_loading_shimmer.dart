import 'package:deskdose/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeLoadingShimmer extends StatelessWidget {
  const HomeLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: const [
        _ShimmerBox(height: 32, width: 180),
        SizedBox(height: 8),
        _ShimmerBox(height: 28, width: 120),
        SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: _ShimmerBox(height: 88)),
            SizedBox(width: 12),
            Expanded(child: _ShimmerBox(height: 88)),
            SizedBox(width: 12),
            Expanded(child: _ShimmerBox(height: 88)),
          ],
        ),
        SizedBox(height: 24),
        _ShimmerBox(height: 20, width: 100),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _ShimmerBox(height: 140)),
            SizedBox(width: 12),
            Expanded(child: _ShimmerBox(height: 140)),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _ShimmerBox(height: 140)),
            SizedBox(width: 12),
            Expanded(child: _ShimmerBox(height: 140)),
          ],
        ),
        SizedBox(height: 24),
        _ShimmerBox(height: 100),
      ],
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({required this.height, this.width});

  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceContainerHigh,
      highlightColor: AppColors.surfaceContainer,
      child: Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
