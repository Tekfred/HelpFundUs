import 'package:flutter/material.dart';
import '../../../../core/animation/reveal_on_enter.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/brand_logo.dart';
import '../../../../core/widgets/theme_mode_toggle.dart';
import '../widgets/campaign_card_illustration.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    super.key,
    required this.onGetStarted,
    required this.onSignIn,
  });
  final VoidCallback onGetStarted;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.sm),
              const Align(
                alignment: Alignment.centerRight,
                child: ThemeModeToggle(),
              ),
              const SizedBox(height: AppSpacing.sm),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (context, v, child) =>
                    Transform.scale(scale: v, child: child),
                child: const BrandLogo(size: 100),
              ),
              const SizedBox(height: 14),
              RevealOnEnter(
                index: 1,
                child: Column(
                  children: [
                    AnimatedSwitcher(
                      duration: AppMotion.fast,
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(scale: animation, child: child),
                      ),
                      child: Image.asset(
                        context.isDarkTheme
                            ? 'assets/images/image (3).png'
                            : 'assets/images/image (5).png',
                        key: ValueKey(context.isDarkTheme),
                        width: 240,
                        height: 38,
                        fit: BoxFit.contain,
                        semanticLabel: 'HelpFundUs.org',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Crowdfunding that cares',
                      style: AppTextStyles.tagline.copyWith(
                        color: context.appTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const RevealOnEnter(index: 2, child: CampaignCardIllustration()),
              const SizedBox(height: 20),
              RevealOnEnter(
                index: 3,
                blurSigma: 8,
                child: Text(
                  'Fund what matters,\ngive where it counts',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h1.copyWith(
                    color: context.appTextPrimary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              RevealOnEnter(
                index: 4,
                child: Text(
                  'Discover verified campaigns, donate securely, or launch your own fundraiser in minutes.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMd.copyWith(
                    color: context.appTextSecondary,
                  ),
                ),
              ),
              const Spacer(),
              RevealOnEnter(
                index: 5,
                child: Column(
                  children: [
                    PrimaryButton(
                      label: 'Get Started',
                      onPressed: onGetStarted,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SecondaryButton(label: 'Sign In', onPressed: onSignIn),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Text.rich(
                  TextSpan(
                    style: AppTextStyles.caption.copyWith(
                      color: context.appTextMuted,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
