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
import '../../account/data/models/user_profile.dart';

/// Coordinates every registration / sign-in / recovery screen (2.1–2.11).
/// Mirrors OnboardingFlow's shape: an [AuthController] owns the history +
/// direction, this widget just renders whatever step is current through
/// the shared [SpringPageSwitcher].
class AuthFlow extends StatefulWidget {
  const AuthFlow({
    super.key,
    required this.controller,
    this.onFinished,
    this.onSignedIn,
    this.onExit,
  });

  final AuthController controller;

  /// Called once the person completes the whole flow (e.g. after
  /// Registration Successful's "Continue", or a normal sign-in) — wire
  /// this to hand off into the real app shell once it exists.
  final VoidCallback? onFinished;
  final ValueChanged<UserProfile>? onSignedIn;

  /// Leaves authentication when the current screen has no earlier auth
  /// screen to return to.
  final VoidCallback? onExit;

  @override
  State<AuthFlow> createState() => _AuthFlowState();
}

class _AuthFlowState extends State<AuthFlow> {
  AuthController get _controller => widget.controller;
  String _pendingDestination = 'jane@example.com';
  String _pendingPhone = '';
  String? _pendingVerificationId;
  String? _pendingLoginVerificationId;
  bool _allowImmediateOtpResend = false;

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

  void _goBack() {
    if (_controller.canGoBack) {
      _controller.back();
    } else {
      widget.onExit?.call();
    }
  }

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
          onBack: _goBack,
          onSignIn: () => _controller.goTo(AuthStep.signIn),
          onCreated: (email, phone, verificationId) {
            _pendingDestination = email;
            _pendingPhone = phone;
            _pendingVerificationId = verificationId;
            _allowImmediateOtpResend = false;
            _controller.goTo(AuthStep.verifyRegistrationOtp);
          },
        );

      case AuthStep.verifyRegistrationOtp:
        return VerifyRegistrationOtpScreen(
          destination: _pendingDestination,
          phone: _pendingPhone,
          verificationId: _pendingVerificationId,
          allowImmediateResend: _allowImmediateOtpResend,
          onBack: _goBack,
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
          onBack: _goBack,
          onSignedIn: (profile) {
            if (widget.onSignedIn != null) {
              widget.onSignedIn!(profile);
            } else {
              widget.onFinished?.call();
            }
          },
          onForgotPassword: () => _controller.goTo(AuthStep.forgotPassword),
          onPasswordless: () => _controller.goTo(AuthStep.passwordlessRequest),
          onCreateAccount: () => _controller.goTo(AuthStep.createAccount),
          onAccountRestricted: () {
            _controller.restrictedReason = RestrictedReason.suspended;
            _controller.goTo(AuthStep.accountRestricted);
          },
          onVerifyAccount: (identifier) {
            _pendingDestination = identifier;
            _pendingPhone = identifier.contains('@') ? '' : identifier;
            _pendingVerificationId = null;
            _allowImmediateOtpResend = true;
            _controller.goTo(AuthStep.verifyRegistrationOtp);
          },
        );

      case AuthStep.passwordlessRequest:
        return PasswordlessRequestScreen(
          onBack: _goBack,
          onBackToPassword: () => _controller.goTo(AuthStep.signIn),
          onCodeSent: (destination, verificationId) {
            _pendingDestination = destination;
            _pendingLoginVerificationId = verificationId;
            _controller.goTo(AuthStep.verifyLoginOtp);
          },
        );

      case AuthStep.verifyLoginOtp:
        return VerifyLoginOtpScreen(
          destination: _mask(_pendingDestination),
          verificationId: _pendingLoginVerificationId,
          onBack: _goBack,
          onVerified: widget.onFinished ?? () {},
          onNeedsMfa: () => _controller.goTo(AuthStep.mfaVerification),
          onChangeAccount: () => _controller.goTo(AuthStep.signIn),
        );

      case AuthStep.mfaVerification:
        return MfaVerificationScreen(onBack: _goBack);

      case AuthStep.forgotPassword:
        return ForgotPasswordScreen(
          onBack: _goBack,
          onBackToSignIn: () => _controller.goTo(AuthStep.signIn),
        );

      case AuthStep.resetPassword:
        return ResetPasswordScreen(
          onBack: _goBack,
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
