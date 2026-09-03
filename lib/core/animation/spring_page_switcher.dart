import 'package:flutter/widgets.dart';

/// Direction of travel through a flow's screen stack. Kept for API
/// compatibility with OnboardingController/AuthController (and in case a
/// future screen genuinely wants a directional slide) even though the
/// current onboarding transition — matched frame-by-frame against the
/// reference recording — turned out to be a fade, not a slide.
enum SlideDirection { forward, backward }

/// Screen-to-screen transition. Slide mode keeps pages travelling
/// continuously with no blank interval, while each new screen's contents
/// still run their own [RevealOnEnter] cascade. Fade remains available as an
/// explicit opt-in for a flow that needs the previous behavior.
///
/// Wrap the screen you're currently showing in this switcher and change
/// `child`'s key whenever you navigate.
enum PageTransitionStyle { fade, slide }

class SpringPageSwitcher extends StatefulWidget {
  const SpringPageSwitcher({
    super.key,
    required this.child,
    required this.direction,
    this.transitionStyle = PageTransitionStyle.slide,
  });

  /// Must have a unique [Key] per screen so the switcher can detect changes.
  final Widget child;
  final SlideDirection direction;
  final PageTransitionStyle transitionStyle;

  @override
  State<SpringPageSwitcher> createState() => _SpringPageSwitcherState();
}

class _SpringPageSwitcherState extends State<SpringPageSwitcher>
    with TickerProviderStateMixin {
  final List<_Entry> _entries = [];

  static const _exitDuration = Duration(milliseconds: 150);
  static const _blankGap = Duration(milliseconds: 70);
  static const _enterDuration = Duration(milliseconds: 180);
  static const _slideDuration = Duration(milliseconds: 320);

  @override
  void initState() {
    super.initState();
    _entries.add(_Entry(widget.child, this, startVisible: true));
  }

  @override
  void didUpdateWidget(covariant SpringPageSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.child.key != oldWidget.child.key) {
      final entry = _Entry(widget.child, this, startVisible: false);
      _entries.add(entry);

      // Old screen(s) leave in the opposite direction to the incoming page.
      for (final old in _entries.where((e) => e != entry)) {
        old.exiting = true;
        old.controller.duration =
            widget.transitionStyle == PageTransitionStyle.slide
            ? _slideDuration
            : _exitDuration;
        old.controller.reverse(from: 1);
      }

      entry.controller.duration =
          widget.transitionStyle == PageTransitionStyle.slide
          ? _slideDuration
          : _enterDuration;
      void enter() {
        if (!mounted) return;
        entry.controller.forward().whenComplete(() {
          if (mounted) {
            setState(
              () => _entries.removeWhere(
                (e) => e != entry && e.controller.value == 0,
              ),
            );
          }
        });
      }

      if (widget.transitionStyle == PageTransitionStyle.slide) {
        enter();
      } else {
        Future.delayed(_blankGap, enter);
      }
    }
  }

  @override
  void dispose() {
    for (final e in _entries) {
      e.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: _entries.map((entry) {
          return Positioned.fill(
            child: AnimatedBuilder(
              animation: entry.controller,
              builder: (context, child) {
                final value = entry.controller.value;
                if (widget.transitionStyle == PageTransitionStyle.slide) {
                  final distance = constraints.maxWidth * (1 - value);
                  final sign = entry.exiting
                      ? (widget.direction == SlideDirection.forward ? -1 : 1)
                      : (widget.direction == SlideDirection.forward ? 1 : -1);
                  return Transform.translate(
                    offset: Offset(sign * distance, 0),
                    child: child,
                  );
                }
                return Opacity(opacity: value, child: child);
              },
              child: entry.widget,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _Entry {
  _Entry(this.widget, TickerProvider vsync, {required bool startVisible})
    : controller = AnimationController(
        vsync: vsync,
        value: startVisible ? 1 : 0,
      );

  final Widget widget;
  final AnimationController controller;
  bool exiting = false;
}
