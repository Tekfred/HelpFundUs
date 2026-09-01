import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../widgets/campaign_card_illustration.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, required this.onGetStarted, required this.onExplore, required this.onSignIn});
  final VoidCallback onGetStarted;
  final VoidCallback onExplore;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.lg),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (context, v, child) => Transform.scale(scale: v, child: child),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.favorite, color: AppColors.surface, size: 30),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text('HelpFundUs', style: AppTextStyles.brand),
              const SizedBox(height: 2),
              Text('Crowdfunding that cares', style: AppTextStyles.tagline),
              const SizedBox(height: AppSpacing.lg),
              const CampaignCardIllustration(),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Fund what matters,\ngive where it counts',
                textAlign: TextAlign.center,
                style: AppTextStyles.h1,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Discover verified campaigns, donate securely, or launch your own fundraiser in minutes.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMd,
              ),
              const Spacer(),
              PrimaryButton(label: 'Get Started', onPressed: onGetStarted),
              const SizedBox(height: AppSpacing.sm),
              SecondaryButton(label: 'Sign In', onPressed: onSignIn),
              const SizedBox(height: AppSpacing.sm),
              TextLinkButton(label: 'Explore Campaigns', trailingArrow: true, onPressed: onExplore),
              const SizedBox(height: AppSpacing.sm),
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Text.rich(
                  TextSpan(
                    style: AppTextStyles.caption,
                    
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
