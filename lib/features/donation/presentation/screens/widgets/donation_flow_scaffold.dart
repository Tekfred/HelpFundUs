import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';

class DonationFlowScaffold extends StatelessWidget {
  const DonationFlowScaffold({
    super.key,
    required this.title,
    required this.child,
    this.bottomAction,
    this.bottomSecondaryAction,
    this.bottomHorizontalPadding = 20,
  });

  final String title;
  final Widget child;
  final Widget? bottomAction;
  final Widget? bottomSecondaryAction;
  final double bottomHorizontalPadding;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.appBackground,
    body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 6),
            child: SizedBox(
              height: 48,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Material(
                      color: context.appSurface,
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        customBorder: const CircleBorder(),
                        child: const SizedBox(
                          width: 44,
                          height: 44,
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 19,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(title, style: AppTextStyles.h2.copyWith(fontSize: 23)),
                ],
              ),
            ),
          ),
          Expanded(child: child),
          if (bottomAction != null)
            SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  bottomHorizontalPadding,
                  6,
                  bottomHorizontalPadding,
                  14,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: bottomAction,
                    ),
                    if (bottomSecondaryAction != null) ...[
                      const SizedBox(height: 4),
                      SizedBox(
                        width: double.infinity,
                        height: 42,
                        child: bottomSecondaryAction,
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

class DonationPrimaryButton extends StatelessWidget {
  const DonationPrimaryButton({
    super.key,
    required this.label,
    required this.enabled,
    required this.onPressed,
  });

  final String label;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: enabled ? onPressed : null,
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.primary,
      disabledBackgroundColor: AppColors.primary.withValues(alpha: .25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        label,
        maxLines: 1,
        style: AppTextStyles.buttonLg.copyWith(fontSize: 16),
      ),
    ),
  );
}
