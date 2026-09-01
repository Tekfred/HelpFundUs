import 'package:flutter/material.dart';
import '../../../core/animation/spring_page_switcher.dart';
import '../state/onboarding_controller.dart';
import 'screens/choose_journey_screen.dart';
import 'screens/discover_causes_screen.dart';
import 'screens/donate_securely_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/start_fundraiser_screen.dart';
import 'screens/welcome_screen.dart';

/// Top-level onboarding coordinator. Splash is a real [OnboardingStep] like
/// every other screen — reachable from the dev screen-nav the same way as
/// Welcome/Discover/etc — it just happens to auto-advance itself via
/// [SplashScreen.onFinished] instead of waiting for a tap.
///
/// [onSignIn] and [onCreateAccount] bubble up to [AppRoot], which swaps
/// this whole flow out for [AuthFlow] — onboarding itself knows nothing
/// about auth screens.
class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({
    super.key,
    required this.controller,
    required this.onSignIn,
    required this.onCreateAccount,
  });

  final OnboardingController controller;
  final VoidCallback onSignIn;
  final VoidCallback onCreateAccount;

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  OnboardingController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return SpringPageSwitcher(
      direction: _controller.direction,
      child: KeyedSubtree(
        key: ValueKey(_controller.current),
        child: _buildScreen(_controller.current),
      ),
    );
  }

  Widget _buildScreen(OnboardingStep step) {
    switch (step) {
      case OnboardingStep.splash:
        return SplashScreen(onFinished: _controller.next);
      case OnboardingStep.welcome:
        return WelcomeScreen(
          onGetStarted: _controller.next,
          onSignIn: widget.onSignIn,
          onExplore: () {
            // TODO: route to the public campaign browser once it exists.
          },
        );
      case OnboardingStep.discover:
        return DiscoverCausesScreen(
          onNext: _controller.next,
          onBack: _controller.back,
          onSkip: _controller.skipToJourney,
        );
      case OnboardingStep.donate:
        return DonateSecurelyScreen(
          onNext: _controller.next,
          onBack: _controller.back,
          onSkip: _controller.skipToJourney,
        );
      case OnboardingStep.fundraiser:
        return StartFundraiserScreen(
          onCreateAccount: _controller.next,
          onBack: _controller.back,
          onSkip: _controller.skipToJourney,
        );
      case OnboardingStep.journey:
        return ChooseJourneyScreen(
          onBack: _controller.back,
          // Both donor and fundraiser choices land on Create Account for
          // now — the choice itself would be persisted once there's a
          // backend to send it to.
          onContinue: (choice) => widget.onCreateAccount(),
          onSignIn: widget.onSignIn,
          onBrowseFirst: () {
            // TODO: route to the public campaign browser once it exists.
          },
        );
    }
  }
}
