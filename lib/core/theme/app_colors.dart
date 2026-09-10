import 'package:flutter/material.dart';

/// Design-system color tokens for HelpFundUs.
/// Keep every raw hex value in this one place — screens and widgets
/// should only ever reference [AppColors], never a literal Color(0x..).
abstract class AppColors {
  AppColors._();

  /// Primary — vivid green. CTAs, active states, progress fills.
  static const Color primary = Color(0xFF1DB954);
  static const Color primaryDark = Color(0xFF17A34A);
  static const Color primaryLight = Color(0xFF6FE39A);

  /// Background — soft mint. Screen backgrounds.
  static const Color background = Color(0xFFEAF7F0);

  /// Surface — pure white. Cards, sheets, inputs.
  static const Color surface = Color(0xFFFFFFFF);

  /// Text
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0x991A1A2E); // ~60% opacity
  static const Color textMuted = Color(0x661A1A2E); // ~40% opacity

  /// Utility
  static const Color border = Color(0x141A1A2E); // ~8% opacity
  static const Color borderStrong = Color(
    0x261A1A2E,
  ); // ~15% opacity, for visible card/button outlines
  static const Color shadow = Color(0x1A1DB954); // soft green shadow
  static const Color danger = Color(0xFFE5484D);
  static const Color warning = Color(0xFFF5A524);

  /// Accent chips used in campaign card / celebration moments
  static const Color coral = Color(0xFFFF6B6B);
  static const Color teal = Color(0xFF4ECDC4);
  static const Color gold = Color(0xFFFFC857);

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [teal, Color(0xFF4F8EF7), Color(0xFF7B5CF0)],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary],
  );
}
