import 'package:flutter/material.dart';
import '../../../../core/animation/reveal_on_enter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/circular_back_button.dart';
import '../../../../core/widgets/dot_indicator.dart';

/// Common chrome for Discover Causes / Donate Securely / Start a
/// Fundraiser: back chevron + Skip row, illustration slot, headline,
/// body copy, dot progress (n of 3), and a primary CTA pinned to the
/// bottom.
///
/// Reveal order matches the reference recording: back/skip/CTA pop in
/// together almost immediately (index 0), the illustration's own content
/// cascades in next (each illustration staggers its own children starting
/// at index 1), then the dot indicator, headline (with extra blur), and
/// body text follow last, in that order.
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
    this.contentRevealCount = 4,
  });

  final VoidCallback onBack;
  final VoidCallback onSkip;
  final Widget illustration;
  final String headline;
  final String body;
  final int dotIndex;
  final Widget cta;

  /// How many staggered items the [illustration] itself reveals (cards,
  /// timeline steps, trust rows...) — used so the dot indicator/headline/
  /// body queue up right after the illustration finishes, instead of a
  /// hardcoded index that might land mid-cascade for a shorter or longer
  /// illustration.
  final int contentRevealCount;

  @override
  Widget build(BuildContext context) {
    final tailIndex = 1 + contentRevealCount;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.sm),
              RevealOnEnter(
                index: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircularBackButton(onPressed: onBack),
                    TextButton(
                      onPressed: onSkip,
                      child: Text(
                        'Skip',
                        style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(child: Center(child: illustration)),
              const SizedBox(height: AppSpacing.lg),
              RevealOnEnter(
                index: tailIndex,
                child: DotIndicator(count: 3, activeIndex: dotIndex),
              ),
              const SizedBox(height: AppSpacing.lg),
              RevealOnEnter(
                index: tailIndex + 1,
                blurSigma: 8,
                child: Text(
                  headline,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h1,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              RevealOnEnter(
                index: tailIndex + 2,
                child: Text(
                  body,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMd,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              RevealOnEnter(index: 0, child: cta),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
