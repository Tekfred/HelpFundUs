import 'package:flutter/widgets.dart';

/// Direction of travel through a flow's screen stack. Kept for API
/// compatibility with OnboardingController/AuthController (and in case a
/// future screen genuinely wants a directional slide) even though the
/// current onboarding transition — matched frame-by-frame against the
/// reference recording — turned out to be a fade, not a slide.
enum SlideDirection { forward, backward }

/// Screen-to-screen transition: the outgoing screen fades out quickly,
/// there's a brief blank beat, then the incoming screen's container fades
/// in — at which point its own contents take over via [RevealOnEnter],
/// staggering in element-by-element. This split is deliberate: the
/// container transition here is intentionally understated so it doesn't
/// compete with the per-element cascade happening inside the new screen.
///
/// Usage unchanged: wrap the screen you're currently showing in this
/// switcher and change `child`'s key whenever you navigate.
class SpringPageSwitcher extends StatefulWidget {
  const SpringPageSwitcher({
    super.key,
    required this.child,
    required this.direction,
  });

  /// Must have a unique [Key] per screen so the switcher can detect changes.
  final Widget child;
  final SlideDirection direction;

  @override
  State<SpringPageSwitcher> createState() => _SpringPageSwitcherState();
}

class _SpringPageSwitcherState extends State<SpringPageSwitcher>
    with TickerProviderStateMixin {
  final List<_Entry> _entries = [];

  static const _exitDuration = Duration(milliseconds: 150);
  static const _blankGap = Duration(milliseconds: 70);
  static const _enterDuration = Duration(milliseconds: 180);

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

      // Old screen(s): fade out fast, no movement.
      for (final old in _entries.where((e) => e != entry)) {
        old.exiting = true;
        old.controller.duration = _exitDuration;
        old.controller.reverse(from: 1);
      }

      // Brief blank beat, then the new screen's container fades in — its
      // own children run their staggered reveal independently of this.
      entry.controller.duration = _enterDuration;
      Future.delayed(_blankGap, () {
        if (mounted) {
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
      });
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
    return Stack(
      children: _entries.map((entry) {
        return Positioned.fill(
          child: AnimatedBuilder(
            animation: entry.controller,
            builder: (context, child) =>
                Opacity(opacity: entry.controller.value, child: child),
            child: entry.widget,
          ),
        );
      }).toList(),
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
