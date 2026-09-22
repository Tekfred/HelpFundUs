import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/widgets/app_button.dart';

class SessionExpiredScreen extends StatefulWidget {
  const SessionExpiredScreen({
    super.key,
    required this.onSignInAgain,
    this.showBiometric = true,
    this.hadUnsavedProgress = false,
  });

  final VoidCallback onSignInAgain;
  final bool showBiometric;

  /// When true, shows a small reassurance that a draft was preserved —
  /// e.g. an in-progress campaign form.
  final bool hadUnsavedProgress;

  @override
  State<SessionExpiredScreen> createState() => _SessionExpiredScreenState();
}

class _SessionExpiredScreenState extends State<SessionExpiredScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const Spacer(),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  // Gentle back-and-forth tick, like a clock hand nudging.
                  return Transform.rotate(
                    angle: 0.05 * sin(_controller.value * 2 * pi),
                    child: child,
                  );
                },
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.access_time_filled_rounded,
                    color: AppColors.warning,
                    size: 44,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Your session has expired',
                style: AppTextStyles.h1.copyWith(color: context.appTextPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                "For your security, you've been signed out after a period of inactivity. "
                'Sign in again to pick up where you left off.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMd.copyWith(
                  color: context.appTextSecondary,
                ),
              ),
              if (widget.hadUnsavedProgress) ...[
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: context.appSurface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.save_outlined,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Your unsaved changes were kept as a draft.',
                          style: AppTextStyles.bodySm.copyWith(
                            color: context.appTextMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const Spacer(),
              PrimaryButton(
                label: 'Sign In Again',
                onPressed: widget.onSignInAgain,
              ),
              if (widget.showBiometric) ...[
                const SizedBox(height: AppSpacing.sm),
                SecondaryButton(
                  label: 'Unlock with Face ID',
                  onPressed: widget.onSignInAgain,
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
