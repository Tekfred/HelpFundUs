import 'package:flutter/material.dart';
import '../../../../core/widgets/app_button.dart';
import '../widgets/fundraiser_timeline_illustration.dart';
import '../widgets/onboarding_slide_scaffold.dart';

class StartFundraiserScreen extends StatelessWidget {
  const StartFundraiserScreen({super.key, required this.onCreateAccount, required this.onBack, required this.onSkip});
  final VoidCallback onCreateAccount;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return OnboardingSlideScaffold(
      onBack: onBack,
      onSkip: onSkip,
      dotIndex: 2,
      illustration: const FundraiserTimelineIllustration(),
      headline: 'Start making\na difference',
      body: 'Create your campaign story, complete a quick identity check, and our team '
          'reviews it within 24 hours. Then go live and receive funds directly.',
      cta: PrimaryButton(label: 'Create Account', onPressed: onCreateAccount),
    );
  }
}
