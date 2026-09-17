import 'package:flutter/material.dart';

/// A progress indicator that fills in when its surrounding screen/card enters
/// the tree. It keeps the final layout identical to [LinearProgressIndicator].
class AnimatedProgressBar extends StatelessWidget {
  const AnimatedProgressBar({
    super.key,
    required this.value,
    required this.color,
    required this.backgroundColor,
    this.minHeight = 6,
    this.duration = const Duration(milliseconds: 760),
  });

  final double value;
  final Color color;
  final Color backgroundColor;
  final double minHeight;
  final Duration duration;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
    duration: duration,
    curve: Curves.easeOutCubic,
    builder: (context, progress, _) => LinearProgressIndicator(
      value: progress,
      minHeight: minHeight,
      color: color,
      backgroundColor: backgroundColor,
    ),
  );
}
