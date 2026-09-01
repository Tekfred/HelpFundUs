import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

/// Direction of travel through the onboarding stack.
enum SlideDirection { forward, backward }


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

  static const SpringDescription _spring = SpringDescription(
    mass: 1,
    stiffness: 210,
    damping: 26,
  );

  @override
  void initState() {
    super.initState();
    _entries.add(_Entry(widget.child, widget.direction, this, isNew: false));
  }

  @override
  void didUpdateWidget(covariant SpringPageSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.child.key != oldWidget.child.key) {
      final entry = _Entry(widget.child, widget.direction, this, isNew: true);
      _entries.add(entry);
      entry.controller.animateWith(SpringSimulation(_spring, 0, 1, 0)).then((_) {
        if (mounted) {
          setState(() => _entries.removeWhere((e) => e != entry && e.controller.isCompleted));
        }
      });
      // Reverse-out the previous entries so they slide away underneath.
      // Their controller value currently reads 1 (fully arrived) — reset it
      // to 0 so it represents "exit progress" rather than "arrival progress"
      // before springing back up to 1.
      for (final old in _entries.where((e) => e != entry)) {
        old.exiting = true;
        old.controller.value = 0;
        old.controller.animateWith(SpringSimulation(_spring, 0, 1, 0));
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
    return Stack(
      children: _entries.map((entry) {
        return Positioned.fill(child: AnimatedBuilder(
          animation: entry.controller,
          builder: (context, child) {
            final t = entry.controller.value;
            final forward = entry.direction == SlideDirection.forward;
            double beginX;
            double endX;
            if (!entry.exiting) {
              // Incoming screen: slides in from the direction-appropriate edge.
              beginX = forward ? 1 : -1;
              endX = 0;
            } else {
              // Outgoing screen: slides out the opposite edge, slightly.
              beginX = 0;
              endX = forward ? -0.28 : 0.28;
            }
            final dx = beginX + (endX - beginX) * t;
            final opacity = entry.exiting ? (1 - t).clamp(0.0, 1.0) : t.clamp(0.0, 1.0);
            return Opacity(
              opacity: opacity,
              child: FractionalTranslation(
                translation: Offset(dx, 0),
                child: child,
              ),
            );
          },
          child: entry.widget,
        ));
      }).toList(),
    );
  }
}

class _Entry {
  _Entry(this.widget, this.direction, TickerProvider vsync, {required bool isNew})
      : controller = AnimationController(vsync: vsync, value: isNew ? 0 : 1);

  final Widget widget;
  final SlideDirection direction;
  final AnimationController controller;
  bool exiting = false;
}
