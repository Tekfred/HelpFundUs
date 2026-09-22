import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../state/auth_controller.dart';

class _RestrictedCopy {
  const _RestrictedCopy(
    this.icon,
    this.color,
    this.title,
    this.body,
    this.primaryLabel, {
    this.showReactivate = false,
  });
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final String primaryLabel;
  final bool showReactivate;
}

const _copy = {
  RestrictedReason.suspended: _RestrictedCopy(
    Icons.block_rounded,
    AppColors.danger,
    'Account suspended',
    'Your account has been suspended for violating our community guidelines. '
        "If you believe this is a mistake, reach out to our support team and we'll take a look.",
    'Contact Support',
  ),
  RestrictedReason.deactivated: _RestrictedCopy(
    Icons.pause_circle_outline_rounded,
    AppColors.textSecondary,
    'Account deactivated',
    "You've deactivated this account. You can reactivate it any time to pick up right where you left off.",
    'Reactivate Account',
    showReactivate: true,
  ),
  RestrictedReason.pendingReview: _RestrictedCopy(
    Icons.hourglass_top_rounded,
    AppColors.warning,
    'Account under review',
    "We're reviewing some recent activity on your account. This usually takes less than 24 hours — "
        "we'll email you as soon as it's done.",
    'Contact Support',
  ),
};

class AccountRestrictedScreen extends StatefulWidget {
  const AccountRestrictedScreen({
    super.key,
    required this.reason,
    required this.onContactSupport,
    required this.onReactivate,
    this.onChangeReasonDemo,
  });

  final RestrictedReason reason;
  final VoidCallback onContactSupport;
  final VoidCallback onReactivate;

  /// Demo-only affordance to cycle through the three states.
  final ValueChanged<RestrictedReason>? onChangeReasonDemo;

  @override
  State<AccountRestrictedScreen> createState() =>
      _AccountRestrictedScreenState();
}

class _AccountRestrictedScreenState extends State<AccountRestrictedScreen> {
  @override
  Widget build(BuildContext context) {
    final copy = _copy[widget.reason]!;
    return Scaffold(
      backgroundColor: context.appBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const Spacer(),
              TweenAnimationBuilder<double>(
                key: ValueKey(widget.reason),
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutBack,
                builder: (context, v, child) =>
                    Transform.scale(scale: v, child: child),
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: copy.color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(copy.icon, color: copy.color, size: 44),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                copy.title,
                style: AppTextStyles.h1.copyWith(color: context.appTextPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                copy.body,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMd.copyWith(
                  color: context.appTextSecondary,
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: copy.showReactivate
                    ? copy.primaryLabel
                    : copy.primaryLabel,
                onPressed: copy.showReactivate
                    ? widget.onReactivate
                    : widget.onContactSupport,
              ),
              if (copy.showReactivate) ...[
                const SizedBox(height: AppSpacing.sm),
                SecondaryButton(
                  label: 'Contact Support',
                  onPressed: widget.onContactSupport,
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              if (widget.onChangeReasonDemo != null)
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: AppSpacing.xs,
                  children: RestrictedReason.values.map((r) {
                    final selected = r == widget.reason;
                    return GestureDetector(
                      onTap: () => widget.onChangeReasonDemo!(r),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primary.withValues(alpha: 0.12)
                              : context.appSurface,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          border: Border.all(
                            color: selected
                                ? AppColors.primary
                                : context.appBorder,
                          ),
                        ),
                        child: Text(
                          switch (r) {
                            RestrictedReason.suspended => 'Suspended',
                            RestrictedReason.deactivated => 'Deactivated',
                            RestrictedReason.pendingReview => 'Pending review',
                          },
                          style: AppTextStyles.bodySm.copyWith(
                            color: selected
                                ? AppColors.primary
                                : context.appTextSecondary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
