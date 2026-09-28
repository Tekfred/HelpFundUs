import 'package:flutter/material.dart';
import 'core/animation/spring_page_switcher.dart';
import 'features/app_shell/presentation/app_shell.dart';
import 'features/auth/presentation/auth_flow.dart';
import 'features/auth/state/auth_controller.dart';
import 'features/account/data/models/user_profile.dart';
import 'features/onboarding/presentation/onboarding_flow.dart';
import 'features/onboarding/state/onboarding_controller.dart';

enum _AppMode { onboarding, auth, appShell }

/// The only widget that knows onboarding, auth, and the app shell all
/// exist. It swaps between the three through the same spring transition
/// used inside each flow, so handing off between them feels like one
/// continuous motion system rather than a jump cut.
///
/// It also owns [OnboardingController] and [AuthController] so the debug
/// [DevScreenNav] — the "Screens" pill — can jump straight into any
/// screen for demoing, without any of the three flows needing to know
/// that nav bar exists.
class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  _AppMode _mode = _AppMode.onboarding;
  bool _isGuest = false;
  UserProfile? _profile;
  late final _onboardingController = OnboardingController();
  late final _authController = AuthController();

  @override
  void dispose() {
    _onboardingController.dispose();
    _authController.dispose();
    super.dispose();
  }

  void _jumpToOnboarding(OnboardingStep step) {
    setState(() {
      _mode = _AppMode.onboarding;
      _onboardingController.goTo(step);
    });
  }

  void _jumpToAuth(AuthStep step) {
    setState(() {
      _mode = _AppMode.auth;
      _isGuest = false;
      _authController.reset(step);
    });
  }

  void _exitAuth() => setState(() {
    _isGuest = false;
    _mode = _AppMode.onboarding;
  });

  void _jumpToAppShell() => setState(() {
    _isGuest = false;
    _mode = _AppMode.appShell;
  });

  void _finishSignedIn(UserProfile profile) => setState(() {
    _profile = profile;
    _isGuest = false;
    _mode = _AppMode.appShell;
  });

  void _enterGuest() => setState(() {
    _isGuest = true;
    _mode = _AppMode.appShell;
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SpringPageSwitcher(
          direction: SlideDirection.forward,
          child: KeyedSubtree(
            key: ValueKey(_mode),
            child: switch (_mode) {
              _AppMode.onboarding => OnboardingFlow(
                controller: _onboardingController,
                onSignIn: () => _jumpToAuth(AuthStep.signIn),
                onCreateAccount: () => _jumpToAuth(AuthStep.createAccount),
                onBrowseCampaigns: _enterGuest,
              ),
              _AppMode.auth => AuthFlow(
                controller: _authController,
                onFinished: _jumpToAppShell,
                onSignedIn: _finishSignedIn,
                onExit: _exitAuth,
              ),
              _AppMode.appShell => AppShell(
                isGuest: _isGuest,
                profile: _profile,
                onGuestSignIn: () => _jumpToAuth(AuthStep.signIn),
                onGuestCreateAccount: () => _jumpToAuth(AuthStep.createAccount),
                onSignOut: () => setState(() {
                  _isGuest = false;
                  _profile = null;
                  _mode = _AppMode.onboarding;
                }),
              ),
            },
          ),
        ),
        // DevScreenNav(groups: _navGroups),
      ],
    );
  }

  // Labels match the reference "SCREEN NAVIGATOR — DEMO MODE" bar exactly:
  // Onboarding / Auth / App Shell groups, with the same short labels
  // (Register, OTP Reg, Passless, Expired, Restricted, etc).
  // List<DevNavGroup> get _navGroups => [
  //       DevNavGroup('Onboarding', [
  //         DevNavEntry('Splash', () => _jumpToOnboarding(OnboardingStep.splash)),
  //         DevNavEntry('Welcome', () => _jumpToOnboarding(OnboardingStep.welcome)),
  //         DevNavEntry('Discover', () => _jumpToOnboarding(OnboardingStep.discover)),
  //         DevNavEntry('Donate', () => _jumpToOnboarding(OnboardingStep.donate)),
  //         DevNavEntry('Fundraise', () => _jumpToOnboarding(OnboardingStep.fundraiser)),
  //         DevNavEntry('Journey', () => _jumpToOnboarding(OnboardingStep.journey)),
  //       ]),
  //       DevNavGroup('Auth', [
  //         DevNavEntry('Register', () => _jumpToAuth(AuthStep.createAccount)),
  //         DevNavEntry('OTP Reg', () => _jumpToAuth(AuthStep.verifyRegistrationOtp)),
  //         DevNavEntry('Success', () => _jumpToAuth(AuthStep.registrationSuccess)),
  //         DevNavEntry('Sign In', () => _jumpToAuth(AuthStep.signIn)),
  //         DevNavEntry('Passless', () => _jumpToAuth(AuthStep.passwordlessRequest)),
  //         DevNavEntry('OTP Login', () => _jumpToAuth(AuthStep.verifyLoginOtp)),
  //         DevNavEntry('MFA', () => _jumpToAuth(AuthStep.mfaVerification)),
  //         DevNavEntry('Forgot PW', () => _jumpToAuth(AuthStep.forgotPassword)),
  //         DevNavEntry('Reset PW', () => _jumpToAuth(AuthStep.resetPassword)),
  //         DevNavEntry('Expired', () => _jumpToAuth(AuthStep.sessionExpired)),
  //         DevNavEntry('Restricted', () => _jumpToAuth(AuthStep.accountRestricted)),
  //       ]),
  //       DevNavGroup('App Shell', [
  //         DevNavEntry('App Shell', _jumpToAppShell),
  //       ]),
  //     ];
}
