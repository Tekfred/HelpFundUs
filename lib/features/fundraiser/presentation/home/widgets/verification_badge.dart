import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';

class VerificationBadge extends StatelessWidget {
  const VerificationBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: .05),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: AppColors.primary,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              'Identity verified',
              style: AppTextStyles.buttonMd.copyWith(
                fontSize: 13,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
