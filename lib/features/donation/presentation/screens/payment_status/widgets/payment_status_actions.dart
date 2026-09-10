import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';

class PaymentStatusActions extends StatelessWidget {
  const PaymentStatusActions({
    super.key,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.tertiaryLabel,
    this.onTertiary,
  });

  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final String? tertiaryLabel;
  final VoidCallback? onTertiary;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      SizedBox(
        width: double.infinity,
        height: 58,
        child: FilledButton(
          onPressed: onPrimary,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(primaryLabel, style: AppTextStyles.buttonLg),
        ),
      ),
      if (secondaryLabel != null) ...[
        const SizedBox(height: 6),
        TextButton(
          onPressed: onSecondary,
          child: Text(
            secondaryLabel!,
            style: AppTextStyles.buttonMd.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
      if (tertiaryLabel != null)
        TextButton(
          onPressed: onTertiary,
          child: Text(
            tertiaryLabel!,
            style: AppTextStyles.buttonMd.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
    ],
  );
}
