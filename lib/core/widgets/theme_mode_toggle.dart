import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_theme_colors.dart';
import '../theme/theme_provider.dart';

/// Compact appearance controls for entry screens.
///
/// The primary circle immediately switches between light and dark. The
/// secondary auto-brightness circle opts back into the device's system theme
/// and its automatic morning/evening schedule.
class ThemeModeToggle extends StatelessWidget {
  const ThemeModeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThemeProvider>();
    final isSystem = provider.followsSystem;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _RoundThemeButton(
          semanticLabel: isDark
              ? 'Switch to light mode'
              : 'Switch to dark mode',
          icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          iconColor: isDark ? AppColors.gold : context.appTextPrimary,
          onTap: () =>
              provider.setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark),
        ),
        const SizedBox(height: AppSpacing.xs),
        _RoundThemeButton(
          semanticLabel: isSystem
              ? 'System theme is active'
              : 'Use system theme schedule',
          icon: Icons.brightness_auto_rounded,
          iconColor: isSystem ? AppColors.primary : context.appTextSecondary,
          active: isSystem,
          onTap: () => provider.setThemeMode(ThemeMode.system),
        ),
      ],
    );
  }
}

class _RoundThemeButton extends StatelessWidget {
  const _RoundThemeButton({
    required this.semanticLabel,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.active = false,
  });

  final String semanticLabel;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      selected: active,
      child: Tooltip(
        message: semanticLabel,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: AnimatedContainer(
              duration: AppMotion.fast,
              curve: Curves.easeOutCubic,
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: active
                    ? AppColors.primary.withValues(alpha: .14)
                    : context.appSurface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: active ? AppColors.primary : context.appBorder,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: context.isDarkTheme ? .18 : .06,
                    ),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: AppMotion.fast,
                  switchInCurve: Curves.easeOutBack,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) => ScaleTransition(
                    scale: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  ),
                  child: Icon(
                    icon,
                    key: ValueKey(icon),
                    color: iconColor,
                    size: 21,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
