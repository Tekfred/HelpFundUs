/// Radius, spacing and motion-timing tokens.
abstract class AppRadius {
  AppRadius._();
  static const double lg = 16; // primary buttons, cards
  static const double md = 14; // secondary buttons, inputs
  static const double sm = 10; // chips, pills
  static const double pill = 999;
}

abstract class AppSpacing {
  AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

/// Shared durations/curves so every spring feels the same across the app.
abstract class AppMotion {
  AppMotion._();
  static const Duration fast = Duration(milliseconds: 220);
  static const Duration normal = Duration(milliseconds: 420);
  static const Duration slow = Duration(milliseconds: 650);
  static const Duration splashHold = Duration(milliseconds: 2900);
}
