import 'package:flutter/material.dart';
import '../../../../core/animation/reveal_on_enter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/circular_back_button.dart';
import '../widgets/journey_card.dart';

enum JourneyChoice { donor, fundraiser }

class ChooseJourneyScreen extends StatefulWidget {
  const ChooseJourneyScreen({
    super.key,
    required this.onBack,
    required this.onContinue,
    required this.onBrowseFirst,
    required this.onSignIn,
  });

  final VoidCallback onBack;
  final ValueChanged<JourneyChoice> onContinue;
  final VoidCallback onBrowseFirst;
  final VoidCallback onSignIn;

  @override
  State<ChooseJourneyScreen> createState() => _ChooseJourneyScreenState();
}

class _ChooseJourneyScreenState extends State<ChooseJourneyScreen> {
  // A journey is intentionally not inferred. The Continue CTA becomes
  // available only after the person has made their own choice.
  JourneyChoice? _choice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.sm),
              RevealOnEnter(
                index: 0,
                child: CircularBackButton(onPressed: widget.onBack),
              ),
              const SizedBox(height: 18),
              RevealOnEnter(
                index: 1,
                blurSigma: 8,
                child: Text(
                  'How would you\nlike to start?',
                  style: AppTextStyles.h1,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              RevealOnEnter(
                index: 2,
                child: Text(
                  'One account supports both — you can always switch later.',
                  style: AppTextStyles.bodyMd,
                ),
              ),
              const SizedBox(height: 18),
              RevealOnEnter(
                index: 3,
                child: JourneyCard(
                  emoji: '❤️',
                  title: 'I want to donate',
                  description:
                      'Discover verified causes, give securely, and track your impact.',
                  selected: _choice == JourneyChoice.donor,
                  onTap: () => setState(() => _choice = JourneyChoice.donor),
                ),
              ),
              const SizedBox(height: 10),
              RevealOnEnter(
                index: 4,
                child: JourneyCard(
                  emoji: '🚀',
                  title: 'I want to raise funds',
                  description:
                      'Create a campaign, verify your identity, and reach supporters worldwide.',
                  selected: _choice == JourneyChoice.fundraiser,
                  onTap: () =>
                      setState(() => _choice = JourneyChoice.fundraiser),
                ),
              ),
              const SizedBox(height: 12),
              RevealOnEnter(
                index: 5,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.people_outline,
                        size: 16,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'A single account lets you donate and create campaigns — your choice here '
                          'only personalises your start.',
                          style: AppTextStyles.bodySm,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              RevealOnEnter(
                index: 0,
                child: PrimaryButton(
                  label: 'Continue',
                  onPressed: _choice == null
                      ? null
                      : () => widget.onContinue(_choice!),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: widget.onBrowseFirst,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Browse campaigns first',
                    style: AppTextStyles.buttonMd.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: AppTextStyles.bodyMd,
                    ),
                    TextButton(
                      onPressed: widget.onSignIn,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Sign in',
                        style: AppTextStyles.buttonMd.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
