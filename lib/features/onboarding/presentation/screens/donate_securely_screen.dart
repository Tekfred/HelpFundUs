import 'package:flutter/material.dart';
import '../../../../core/widgets/app_button.dart';
import '../widgets/onboarding_slide_scaffold.dart';
import '../widgets/security_illustration.dart';

class DonateSecurelyScreen extends StatelessWidget {
  const DonateSecurelyScreen({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.onSkip,
  });
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return OnboardingSlideScaffold(
      onBack: onBack,
      onSkip: onSkip,
      dotIndex: 1,
      illustration: const SecurityIllustration(),
      contentRevealCount: SecurityIllustration.revealCount,
      headline: 'Give with\nconfidence',
      body:
          'Every donation is protected with bank-grade encryption. All campaigns pass our '
          'verification process, with a refund guarantee if anything goes wrong.',
      cta: PrimaryButton(
        label: 'Next',
        icon: Icons.arrow_forward,
        onPressed: onNext,
      ),
    );
  }
}
