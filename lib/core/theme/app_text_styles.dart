import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Inter 400/500/600/700 — every text style the design system defines.
abstract class AppTextStyles {
  AppTextStyles._();

  static TextStyle _base({
    required double size,
    required FontWeight weight,
    Color color = AppColors.textPrimary,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  // Display / headline
  static TextStyle h1 = _base(size: 32, weight: FontWeight.w700, height: 1.18);
  static TextStyle h2 = _base(size: 27, weight: FontWeight.w700, height: 1.22);
  static TextStyle h3 = _base(size: 22, weight: FontWeight.w600, height: 1.28);

  // Body
  static TextStyle bodyLg = _base(
    size: 17,
    weight: FontWeight.w400,
    height: 1.5,
  );
  static TextStyle bodyMd = _base(
    size: 15,
    weight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textSecondary,
  );
  static TextStyle bodySm = _base(
    size: 13,
    weight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textMuted,
  );

  // Labels / buttons
  static TextStyle buttonLg = _base(
    size: 17,
    weight: FontWeight.w600,
    color: AppColors.surface,
  );
  static TextStyle buttonMd = _base(size: 15, weight: FontWeight.w600);
  static TextStyle label = _base(
    size: 14,
    weight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
  static TextStyle caption = _base(
    size: 12,
    weight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  static TextStyle brand = _base(size: 30, weight: FontWeight.w700);
  static TextStyle tagline = _base(
    size: 15,
    weight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
}
