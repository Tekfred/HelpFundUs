import 'package:flutter/material.dart';
import '../../../../core/animation/reveal_on_enter.dart';
import '../../../../core/theme/app_colors.dart';
import 'security_feature_row.dart';

class SecurityIllustration extends StatelessWidget {
  const SecurityIllustration({super.key});

  static const _trustItems = [
    (Icons.lock_outline, '256-bit SSL on all transactions'),
    (Icons.shield_outlined, 'Every campaign verified by our team'),
    (Icons.check_circle_outline, 'Refund guarantee if fraud occurs'),
  ];

  /// Shield (index 1) + one per trust row — used by the slide scaffold to
  /// queue the dot indicator/headline/body right after this finishes.
  static final revealCount = 1 + _trustItems.length;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const RevealOnEnter(
          index: 1,
          blurSigma:
              0, // the elastic pop below already reads as its own entrance
          child: _ShieldPop(),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) => SizedBox(
            width: constraints.maxWidth.clamp(280.0, 344.0).toDouble(),
            child: Column(
              children: List.generate(_trustItems.length, (i) {
                final (icon, label) = _trustItems[i];
                return RevealOnEnter(
                  index: 2 + i,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: i == _trustItems.length - 1 ? 0 : 8,
                    ),
                    child: SecurityFeatureRow(icon: icon, label: label),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}

/// The shield keeps its own elastic pop-in (distinct from the fade/rise
/// used everywhere else) since that snappier motion reads better for an
/// icon this size — [RevealOnEnter] just handles *when* it starts.
class _ShieldPop extends StatefulWidget {
  const _ShieldPop();

  @override
  State<_ShieldPop> createState() => _ShieldPopState();
}

class _ShieldPopState extends State<_ShieldPop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 124,
            height: 124,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
          ),
          const Icon(Icons.shield, color: AppColors.primary, size: 58),
          Positioned(
            bottom: 13,
            right: 124 / 2 - 35,
            child: Container(
              width: 26,
              height: 26,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: AppColors.surface,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
