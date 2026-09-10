import 'package:flutter/foundation.dart';
import '../../../core/animation/spring_page_switcher.dart';

enum AuthStep {
  createAccount,
  verifyRegistrationOtp,
  registrationSuccess,
  signIn,
  passwordlessRequest,
  verifyLoginOtp,
  mfaVerification,
  forgotPassword,
  resetPassword,
  sessionExpired,
  accountRestricted,
}

enum RestrictedReason { suspended, deactivated, pendingReview }

/// Owns the auth screen stack (registration, sign-in, password-recovery,
/// and the various error/edge states) the same way OnboardingController
/// owns onboarding — a simple history list plus a slide direction, so the
/// UI layer never has to think about routing.
class AuthController extends ChangeNotifier {
  AuthController({AuthStep start = AuthStep.createAccount})
    : _history = [start];

  final List<AuthStep> _history;
  SlideDirection _direction = SlideDirection.forward;

  /// Demo-only piece of state so AccountRestrictedScreen can show all
  /// three copy variants without wiring a real backend yet.
  RestrictedReason restrictedReason = RestrictedReason.suspended;

  AuthStep get current => _history.last;
  SlideDirection get direction => _direction;
  bool get canGoBack => _history.length > 1;

  void goTo(AuthStep step) {
    _direction = SlideDirection.forward;
    _history.add(step);
    notifyListeners();
  }

  void back() {
    if (!canGoBack) return;
    _direction = SlideDirection.backward;
    _history.removeLast();
    notifyListeners();
  }

  /// Jumps back to the very first screen in the stack (used by "Back to
  /// Sign In" / "Sign in again" style actions that shouldn't just pop one).
  void reset(AuthStep step) {
    _direction = SlideDirection.backward;
    _history
      ..clear()
      ..add(step);
    notifyListeners();
  }
}
