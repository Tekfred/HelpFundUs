import 'package:flutter/material.dart';
import '../../../core/animation/spring_page_switcher.dart';
import '../state/auth_controller.dart';
import 'screens/account_restricted_screen.dart';
import 'screens/create_account_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/mfa_verification_screen.dart';
import 'screens/passwordless_request_screen.dart';
import 'screens/registration_success_screen.dart';
import 'screens/reset_password_screen.dart';
import 'screens/session_expired_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/verify_login_otp_screen.dart';
import 'screens/verify_registration_otp_screen.dart';

/// Coordinates every registration / sign-in / recovery screen (2.1–2.11).
/// Mirrors OnboardingFlow's shape: an [AuthController] owns the history +
/// direction, this widget just renders whatever step is current through
/// the shared [SpringPageSwitcher].
class AuthFlow extends StatefulWidget {
  const AuthFlow({super.key, required this.controller, this.onFinished});

  final AuthController controller;

  /// Called once the person completes the whole flow (e.g. after
  /// Registration Successful's "Continue", or a normal sign-in) — wire
  /// this to hand off into the real app shell once it exists.
  final VoidCallback? onFinished;

  @override
  State<AuthFlow> createState() => _AuthFlowState();
}

class _AuthFlowState extends State<AuthFlow> {
  AuthController get _controller => widget.controller;
  String _pendingDestination = 'jane@example.com';

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

  String _mask(String value) {
    if (value.contains('@')) {
      final parts = value.split('@');
      final name = parts.first;
      final masked = name.length <= 2
          ? '${name[0]}•'
          : '${name[0]}${'•' * (name.length - 2)}${name[name.length - 1]}';
      return '$masked@${parts.last}';
    }
    return value.isEmpty ? '+233 •• •• 4821' : value;
  }

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

  Widget _buildScreen(AuthStep step) {
    switch (step) {
      case AuthStep.createAccount:
        return CreateAccountScreen(
          onBack: _controller.back,
          onSignIn: () => _controller.goTo(AuthStep.signIn),
          onCreated: () {
            _pendingDestination = 'jane@example.com';
            _controller.goTo(AuthStep.verifyRegistrationOtp);
          },
        );

      case AuthStep.verifyRegistrationOtp:
        return VerifyRegistrationOtpScreen(
          destination: _mask(_pendingDestination),
          onBack: _controller.back,
          onVerified: () => _controller.goTo(AuthStep.registrationSuccess),
          onChangeDestination: _controller.back,
        );

      case AuthStep.registrationSuccess:
        return RegistrationSuccessScreen(
          onContinue: widget.onFinished ?? () {},
          onCompleteProfile: widget.onFinished ?? () {},
          onEnableSecurity: widget.onFinished ?? () {},
        );

      case AuthStep.signIn:
        return SignInScreen(
          onBack: _controller.back,
          onSignedIn: widget.onFinished ?? () {},
          onForgotPassword: () => _controller.goTo(AuthStep.forgotPassword),
          onPasswordless: () => _controller.goTo(AuthStep.passwordlessRequest),
          onCreateAccount: () => _controller.goTo(AuthStep.createAccount),
          onAccountRestricted: () {
            _controller.restrictedReason = RestrictedReason.suspended;
            _controller.goTo(AuthStep.accountRestricted);
          },
        );

      case AuthStep.passwordlessRequest:
        return PasswordlessRequestScreen(
          onBack: _controller.back,
          onBackToPassword: () => _controller.goTo(AuthStep.signIn),
          onCodeSent: (destination) {
            _pendingDestination = destination;
            _controller.goTo(AuthStep.verifyLoginOtp);
          },
        );

      case AuthStep.verifyLoginOtp:
        return VerifyLoginOtpScreen(
          destination: _mask(_pendingDestination),
          onBack: _controller.back,
          onVerified: widget.onFinished ?? () {},
          onNeedsMfa: () => _controller.goTo(AuthStep.mfaVerification),
          onChangeAccount: () => _controller.goTo(AuthStep.signIn),
        );

      case AuthStep.mfaVerification:
        return MfaVerificationScreen(
          onBack: _controller.back,
          onVerified: widget.onFinished ?? () {},
          onUseBackupCode: widget.onFinished ?? () {},
        );

      case AuthStep.forgotPassword:
        return ForgotPasswordScreen(
          onBack: _controller.back,
          onBackToSignIn: () => _controller.goTo(AuthStep.signIn),
        );

      case AuthStep.resetPassword:
        return ResetPasswordScreen(
          onBack: _controller.back,
          onReset: () => _controller.reset(AuthStep.signIn),
        );

      case AuthStep.sessionExpired:
        return SessionExpiredScreen(
          onSignInAgain: () => _controller.reset(AuthStep.signIn),
        );

      case AuthStep.accountRestricted:
        return AccountRestrictedScreen(
          reason: _controller.restrictedReason,
          onContactSupport: () {},
          onReactivate: widget.onFinished ?? () {},
          onChangeReasonDemo: (r) =>
              setState(() => _controller.restrictedReason = r),
        );
    }
  }
}
