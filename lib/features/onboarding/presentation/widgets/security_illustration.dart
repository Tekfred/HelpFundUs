import 'package:flutter/material.dart';
import '../../../../core/animation/reveal_on_enter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';

class SecurityIllustration extends StatelessWidget {
  const SecurityIllustration({super.key});

  static const _trustItems = [
    (Icons.lock_outline, '256-bit SSL on all transactions'),
    (Icons.shield_outlined, 'Every campaign verified by our team'),
    (Icons.check_circle_outline, 'Refund guarantee if fraud occurs'),
  ];

  static const _paymentMethods = [
    'Visa',
    'Mastercard',
    'Apple Pay',
    'Google Pay',
    'PayPal',
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
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: 300,
          child: Column(
            children: List.generate(_trustItems.length, (i) {
              final (icon, label) = _trustItems[i];
              return RevealOnEnter(
                index: 2 + i,
                child: Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, size: 16, color: AppColors.primary),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          label,
                          style: AppTextStyles.bodyMd.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          alignment: WrapAlignment.center,
          children: _paymentMethods
              .map((m) => Text(m, style: AppTextStyles.caption))
              .toList(),
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
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
          ),
          const Icon(Icons.shield, color: AppColors.primary, size: 56),
          Positioned(
            bottom: 14,
            right: 118 / 2 - 34,
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
