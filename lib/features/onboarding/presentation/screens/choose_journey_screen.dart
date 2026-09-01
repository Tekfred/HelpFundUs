import 'package:flutter/material.dart';
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
  JourneyChoice? _choice = JourneyChoice.donor;

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
              CircularBackButton(onPressed: widget.onBack),
              const SizedBox(height: AppSpacing.lg),
              Text('How would you\nlike to start?', style: AppTextStyles.h1),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'One account supports both — you can always switch later.',
                style: AppTextStyles.bodyMd,
              ),
              const SizedBox(height: AppSpacing.lg),
              JourneyCard(
                emoji: '❤️',
                title: 'I want to donate',
                description: 'Discover verified causes, give securely, and track your impact.',
                selected: _choice == JourneyChoice.donor,
                onTap: () => setState(() => _choice = JourneyChoice.donor),
              ),
              const SizedBox(height: AppSpacing.sm),
              JourneyCard(
                emoji: '🚀',
                title: 'I want to raise funds',
                description: 'Create a campaign, verify your identity, and reach supporters worldwide.',
                selected: _choice == JourneyChoice.fundraiser,
                onTap: () => setState(() => _choice = JourneyChoice.fundraiser),
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.people_outline, size: 16, color: AppColors.textMuted),
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
              const Spacer(),
              PrimaryButton(
                label: 'Continue',
                onPressed: _choice == null ? null : () => widget.onContinue(_choice!),
              ),
              Center(
                child: TextLinkButton(label: 'Browse campaigns first', onPressed: widget.onBrowseFirst),
              ),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Text('Already have an account? ', style: AppTextStyles.bodyMd),
                    TextLinkButton(label: 'Sign in', onPressed: widget.onSignIn),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }
}
