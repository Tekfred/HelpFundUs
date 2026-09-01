import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/circular_back_button.dart';
import '../../../../core/widgets/dot_indicator.dart';

/// Common chrome for Discover Causes / Donate Securely / Start a
/// Fundraiser: back chevron + Skip row, illustration slot, headline,
/// body copy, dot progress (n of 3), and a primary CTA pinned to the
/// bottom.
class OnboardingSlideScaffold extends StatelessWidget {
  const OnboardingSlideScaffold({
    super.key,
    required this.onBack,
    required this.onSkip,
    required this.illustration,
    required this.headline,
    required this.body,
    required this.dotIndex,
    required this.cta,
  });

  final VoidCallback onBack;
  final VoidCallback onSkip;
  final Widget illustration;
  final String headline;
  final String body;
  final int dotIndex;
  final Widget cta;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircularBackButton(onPressed: onBack),
                  TextButton(
                    onPressed: onSkip,
                    child: Text('Skip', style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary)),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(child: Center(child: illustration)),
              const SizedBox(height: AppSpacing.lg),
              DotIndicator(count: 3, activeIndex: dotIndex),
              const SizedBox(height: AppSpacing.lg),
              Text(headline, textAlign: TextAlign.center, style: AppTextStyles.h1),
              const SizedBox(height: AppSpacing.sm),
              Text(body, textAlign: TextAlign.center, style: AppTextStyles.bodyMd),
              const SizedBox(height: AppSpacing.lg),
              cta,
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
