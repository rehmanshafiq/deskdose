import 'package:flutter/material.dart';

/// Applies system safe-area insets. Use [bottom: false] inside the tab shell
/// where the bottom navigation bar already handles the lower inset.
class ScreenSafeArea extends StatelessWidget {
  const ScreenSafeArea({
    super.key,
    required this.child,
    this.bottom = true,
    this.top = true,
  });

  final Widget child;
  final bool bottom;
  final bool top;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: top,
      bottom: bottom,
      child: child,
    );
  }
}
