import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';

class DonationDetailActions extends StatelessWidget {
  const DonationDetailActions({
    super.key,
    required this.onContactSupport,
    this.onViewReceipt,
  });

  final VoidCallback onContactSupport;
  final VoidCallback? onViewReceipt;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      if (onViewReceipt != null) ...[
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            onPressed: onViewReceipt,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.primary.withValues(alpha: .22)),
              backgroundColor: AppColors.primary.withValues(alpha: .04),
            ),
            icon: const Icon(Icons.receipt_long_outlined, size: 21),
            label: Text(
              'View receipt',
              style: AppTextStyles.buttonMd.copyWith(fontSize: 16),
            ),
          ),
        ),
      ],
      const SizedBox(height: 14),
      SizedBox(
        width: double.infinity,
        height: 56,
        child: OutlinedButton.icon(
          onPressed: onContactSupport,
          icon: const Icon(Icons.help_outline_rounded, size: 21),
          label: Text(
            'Contact support',
            style: AppTextStyles.buttonMd.copyWith(fontSize: 16),
          ),
        ),
      ),
    ],
  );
}
