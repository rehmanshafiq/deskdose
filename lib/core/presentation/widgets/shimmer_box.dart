import 'package:deskdose/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Reusable shimmer placeholder matching DeskDose dark surfaces.
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    required this.height,
    this.width,
    this.borderRadius = 16,
    this.baseColor = AppColors.surfaceContainerHigh,
    this.highlightColor = AppColors.surfaceContainer,
    this.shape = BoxShape.rectangle,
  });

  final double height;
  final double? width;
  final double borderRadius;
  final Color baseColor;
  final Color highlightColor;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius:
              shape == BoxShape.circle ? null : BorderRadius.circular(borderRadius),
          shape: shape,
        ),
      ),
    );
  }
}
