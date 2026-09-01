import 'package:flutter/material.dart';
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

  static const _paymentMethods = ['Visa', 'Mastercard', 'Apple Pay', 'Google Pay', 'PayPal'];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 700),
          curve: Curves.elasticOut,
          builder: (context, v, child) => Transform.scale(scale: v, child: child),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), shape: BoxShape.circle),
              ),
              const Icon(Icons.shield, color: AppColors.primary, size: 56),
              Positioned(
                bottom: 14,
                right: 118 / 2 - 34,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.check, color: AppColors.surface, size: 16),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: 300,
          child: Column(
            children: List.generate(_trustItems.length, (i) {
              final (icon, label) = _trustItems[i];
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeOut,
                builder: (context, raw, child) {
                  final t = ((raw * 3) - i * 0.5).clamp(0.0, 1.0);
                  return Opacity(opacity: t, child: Transform.translate(offset: Offset(0, (1 - t) * 12), child: child));
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.12), shape: BoxShape.circle),
                        child: Icon(icon, size: 16, color: AppColors.primary),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: Text(label, style: AppTextStyles.bodyMd.copyWith(color: AppColors.textPrimary))),
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
