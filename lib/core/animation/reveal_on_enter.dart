import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Animates [child] in with a fade + slight upward rise + blur-to-focus,
/// starting automatically after [delay] once this widget mounts.
///
/// This is the building block behind the onboarding screens' cascading
/// reveal: wrap each element you want to stagger in with a
/// `RevealOnEnter(index: n, child: ...)`, and because a fresh
/// [RevealOnEnter] is created every time a screen is (re)built — which
/// happens on every navigation, thanks to the `ValueKey` per step in each
/// flow — the whole cascade naturally replays every time you land on
/// that screen, matching the reference recording.
class RevealOnEnter extends StatefulWidget {
  const RevealOnEnter({
    super.key,
    required this.child,
    this.index = 0,
    this.baseDelay = const Duration(milliseconds: 70),
    this.step = const Duration(milliseconds: 45),
    this.duration = const Duration(milliseconds: 420),
    this.offsetY = 14,
    this.blurSigma = 6,
    this.curve = Curves.easeOutCubic,
  });

  final Widget child;

  /// Position of this element in the reveal order — 0 is first.
  final int index;

  /// Delay before the very first element (index 0) starts.
  final Duration baseDelay;

  /// Extra delay per index — this is what creates the cascade.
  final Duration step;

  final Duration duration;
  final double offsetY;
  final double blurSigma;
  final Curve curve;

  @override
  State<RevealOnEnter> createState() => _RevealOnEnterState();
}

class _RevealOnEnterState extends State<RevealOnEnter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _t = CurvedAnimation(
    parent: _controller,
    curve: widget.curve,
  );

  @override
  void initState() {
    super.initState();
    final delay = widget.baseDelay + widget.step * widget.index;
    Future.delayed(delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _t,
      builder: (context, child) {
        final v = _t.value;
        final sigma = (1 - v).clamp(0.0, 1.0) * widget.blurSigma;
        Widget result = Opacity(
          opacity: v.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - v) * widget.offsetY),
            child: child,
          ),
        );
        // Skip the filter entirely once it's a no-op — ImageFiltered isn't
        // free, and most of the cascade is at sigma≈0 well before it ends.
        if (sigma > 0.06) {
          result = ImageFiltered(
            imageFilter: ui.ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
            child: result,
          );
        }
        return result;
      },
      child: widget.child,
    );
  }
}

/// Convenience for staggering a whole list of same-level siblings (like
/// the 2x2 category grid) without hand-computing indices — wrap the
/// list once instead of every child individually.
class RevealStagger extends StatelessWidget {
  const RevealStagger({
    super.key,
    required this.children,
    this.startIndex = 0,
    this.baseDelay = const Duration(milliseconds: 70),
    this.step = const Duration(milliseconds: 45),
  });

  final List<Widget> children;
  final int startIndex;
  final Duration baseDelay;
  final Duration step;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < children.length; i++)
          RevealOnEnter(
            index: startIndex + i,
            baseDelay: baseDelay,
            step: step,
            child: children[i],
          ),
      ],
    );
  }
}
