import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Semantic colors that preserve the existing light palette and resolve to the
/// HelpFundUs dark palette when the global theme is dark.
extension AppThemeColors on BuildContext {
  bool get isDarkTheme => Theme.of(this).brightness == Brightness.dark;

  Color get appBackground =>
      isDarkTheme ? AppColors.backgroundDark : AppColors.background;
  Color get appSurface =>
      isDarkTheme ? AppColors.surfaceDark : AppColors.surface;
  Color get appSurfaceElevated =>
      isDarkTheme ? AppColors.surfaceElevatedDark : AppColors.surface;
  Color get appInput => isDarkTheme ? AppColors.inputDark : AppColors.surface;
  Color get appTextPrimary =>
      isDarkTheme ? AppColors.textPrimaryDark : AppColors.textPrimary;
  Color get appTextSecondary =>
      isDarkTheme ? AppColors.textSecondaryDark : AppColors.textSecondary;
  Color get appTextMuted =>
      isDarkTheme ? AppColors.textMutedDark : AppColors.textMuted;
  Color get appBorder => isDarkTheme ? AppColors.borderDark : AppColors.border;
  Color get appBorderStrong =>
      isDarkTheme ? AppColors.borderDark : AppColors.borderStrong;
  Color get appDivider =>
      isDarkTheme ? AppColors.dividerDark : AppColors.border;
  Color get appNavigation =>
      isDarkTheme ? AppColors.navDark : AppColors.surface;
}
