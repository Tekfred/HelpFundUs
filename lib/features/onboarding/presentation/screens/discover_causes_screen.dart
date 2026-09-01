import 'package:flutter/material.dart';
import '../../../../core/widgets/app_button.dart';
import '../widgets/category_grid_illustration.dart';
import '../widgets/onboarding_slide_scaffold.dart';

class DiscoverCausesScreen extends StatelessWidget {
  const DiscoverCausesScreen({super.key, required this.onNext, required this.onBack, required this.onSkip});
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return OnboardingSlideScaffold(
      onBack: onBack,
      onSkip: onSkip,
      dotIndex: 0,
      illustration: const CategoryGridIllustration(),
      headline: 'Discover causes\nthat matter',
      body: 'Browse thousands of verified campaigns across medical, education, '
          'environment, community and more — sorted by what your community cares about.',
      cta: PrimaryButton(label: 'Next', icon: Icons.arrow_forward, onPressed: onNext),
    );
  }
}
