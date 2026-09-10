import 'package:flutter/foundation.dart';
import '../../../core/animation/spring_page_switcher.dart';

enum OnboardingStep { splash, welcome, discover, donate, fundraiser, journey }

/// Owns the onboarding screen stack. Every push/pop records which
/// direction the spring transition should travel, so the UI layer just
/// listens and renders — it never has to think about left vs. right.
class OnboardingController extends ChangeNotifier {
  final List<OnboardingStep> _history = [OnboardingStep.splash];
  SlideDirection _direction = SlideDirection.forward;

  OnboardingStep get current => _history.last;
  SlideDirection get direction => _direction;
  bool get canGoBack => _history.length > 1;

  /// Index used for the "n of 3" dot indicator — null when the current
  /// screen (Splash, Welcome, Journey) doesn't show one.
  int? get dotIndex => switch (current) {
    OnboardingStep.discover => 0,
    OnboardingStep.donate => 1,
    OnboardingStep.fundraiser => 2,
    _ => null,
  };

  void goTo(OnboardingStep step) {
    _direction = SlideDirection.forward;
    _history.add(step);
    notifyListeners();
  }

  void next() {
    final order = [
      OnboardingStep.splash,
      OnboardingStep.welcome,
      OnboardingStep.discover,
      OnboardingStep.donate,
      OnboardingStep.fundraiser,
      OnboardingStep.journey,
    ];
    final i = order.indexOf(current);
    if (i < order.length - 1) goTo(order[i + 1]);
  }

  /// "Skip" on any of the three progress slides jumps straight to Journey.
  void skipToJourney() => goTo(OnboardingStep.journey);

  void back() {
    if (!canGoBack) return;
    _direction = SlideDirection.backward;
    _history.removeLast();
    notifyListeners();
  }
}
