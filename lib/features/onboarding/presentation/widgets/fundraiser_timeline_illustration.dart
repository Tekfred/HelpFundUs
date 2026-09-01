import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';

class FundraiserTimelineIllustration extends StatelessWidget {
  const FundraiserTimelineIllustration({super.key});

  static const _steps = [
    ('Create your story', 'Write your campaign and set a fundraising goal'),
    ('Verify your identity', 'Quick ID check to build trust with donors'),
    ('24 h review process', 'Our team reviews your campaign for approval'),
    ('Launch and receive funds', 'Go live and receive donations directly to you'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: List.generate(_steps.length, (i) {
          final (title, desc) = _steps[i];
          final isLast = i == _steps.length - 1;
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            builder: (context, raw, child) {
              final t = ((raw * 4) - i * 0.7).clamp(0.0, 1.0);
              return Opacity(opacity: t, child: Transform.translate(offset: Offset((1 - t) * 20, 0), child: child));
            },
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                        child: Text('${i + 1}', style: AppTextStyles.buttonMd.copyWith(color: AppColors.surface)),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            color: AppColors.border,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: AppTextStyles.buttonMd),
                          const SizedBox(height: 2),
                          Text(desc, style: AppTextStyles.bodySm),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
