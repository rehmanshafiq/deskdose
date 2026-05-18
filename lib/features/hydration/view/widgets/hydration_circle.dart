import 'package:flutter/material.dart';

/// Animated circular progress for hydration goal (AnimationController only).
class HydrationCircle extends StatefulWidget {
  const HydrationCircle({
    super.key,
    required this.percentage,
    required this.totalMl,
    required this.goalMl,
    this.size = 200,
    this.strokeWidth = 12,
    this.progressColor = const Color(0xFF378ADD),
    this.backgroundColor = const Color(0xFF1A2A40),
    this.centerTextStyle,
    this.subtitleStyle,
  });

  final double percentage;
  final int totalMl;
  final int goalMl;
  final double size;
  final double strokeWidth;
  final Color progressColor;
  final Color backgroundColor;
  final TextStyle? centerTextStyle;
  final TextStyle? subtitleStyle;

  @override
  State<HydrationCircle> createState() => _HydrationCircleState();
}

class _HydrationCircleState extends State<HydrationCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _displayedPercentage = 0;

  @override
  void initState() {
    super.initState();
    _displayedPercentage = widget.percentage;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = AlwaysStoppedAnimation(widget.percentage);
  }

  @override
  void didUpdateWidget(HydrationCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percentage != widget.percentage) {
      _animation = Tween<double>(
        begin: _displayedPercentage,
        end: widget.percentage,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = _controller.isAnimating
            ? _animation.value
            : widget.percentage;
        _displayedPercentage = value;

        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: widget.size,
                height: widget.size,
                child: CircularProgressIndicator(
                  value: value.clamp(0.0, 1.0),
                  strokeWidth: widget.strokeWidth,
                  backgroundColor: widget.backgroundColor,
                  color: widget.progressColor,
                  strokeCap: StrokeCap.round,
                ),
              ),
              child ?? const SizedBox.shrink(),
            ],
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${widget.totalMl}',
            style: widget.centerTextStyle ??
                const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
          ),
          Text(
            'of ${widget.goalMl} ml',
            style: widget.subtitleStyle ??
                const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFB8B8C4),
                ),
          ),
        ],
      ),
    );
  }
}
