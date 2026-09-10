import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

/// Shared press-spring behaviour for every tappable CTA in the app.
/// Scales down to 0.96 on press and springs back on release, instead of
/// relying on Material's flat ripple alone — this is what gives buttons
/// the same "alive" feel as the reference motion spec.
class _SpringTap extends StatefulWidget {
  const _SpringTap({
    required this.onTap,
    required this.child,
    this.enabled = true,
  });
  final VoidCallback? onTap;
  final Widget child;
  final bool enabled;

  @override
  State<_SpringTap> createState() => _SpringTapState();
}

class _SpringTapState extends State<_SpringTap>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
    lowerBound: 0.0,
    upperBound: 1.0,
    value: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.enabled ? (_) => _controller.forward() : null,
      onTapUp: widget.enabled
          ? (_) {
              _controller.reverse();
              widget.onTap?.call();
            }
          : null,
      onTapCancel: widget.enabled ? () => _controller.reverse() : null,
      child: AnimatedBuilder(
        animation: scale,
        builder: (context, child) =>
            Transform.scale(scale: scale.value, child: child),
        child: widget.child,
      ),
    );
  }
}

/// Solid green pill CTA — 56px tall, 16px radius, per token `Button radius: lg`.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    return _SpringTap(
      enabled: enabled,
      onTap: onPressed,
      child: AnimatedContainer(
        duration: AppMotion.fast,
        curve: Curves.easeOut,
        height: 58,
        width: double.infinity,
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: AppColors.primaryDark.withValues(alpha: enabled ? 0.6 : 0.2),
          ),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: AppColors.surface,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label, style: AppTextStyles.buttonLg),
                  if (icon != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Icon(icon, size: 18, color: AppColors.surface),
                  ],
                ],
              ),
      ),
    );
  }
}

/// White pill secondary button — 14px radius, per token `Button radius: md`.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({super.key, required this.label, this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return _SpringTap(
      onTap: onPressed,
      child: Container(
        height: 58,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.borderStrong, width: 1.4),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.buttonLg.copyWith(color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

/// Plain text link CTA ("Explore Campaigns →", "Sign in").
class TextLinkButton extends StatelessWidget {
  const TextLinkButton({
    super.key,
    required this.label,
    this.onPressed,
    this.trailingArrow = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool trailingArrow;

  @override
  Widget build(BuildContext context) {
    return _SpringTap(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.buttonMd.copyWith(color: AppColors.primary),
            ),
            if (trailingArrow) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_forward,
                size: 16,
                color: AppColors.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
