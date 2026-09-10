import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';

class FeeSummary extends StatelessWidget {
  const FeeSummary({super.key, required this.fee});

  final double fee;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.borderStrong),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _row('Your donation', '\$${(fee / .029).toStringAsFixed(2)}'),
        const SizedBox(height: 8),
        _row(
          'Platform fee (2.9% — optional tip)',
          '\$${fee.toStringAsFixed(2)}',
          muted: true,
        ),
        const Divider(height: 24),
        _row(
          'Campaign receives',
          '\$${(fee / .029).toStringAsFixed(2)}',
          strong: true,
        ),
        const SizedBox(height: 10),
        Text(
          'The platform fee is an optional contribution to keep HelpFundUs running. 100% of your donation amount reaches the campaign.',
          style: AppTextStyles.bodySm.copyWith(height: 1.4),
        ),
      ],
    ),
  );

  Widget _row(
    String label,
    String value, {
    bool muted = false,
    bool strong = false,
  }) => Row(
    children: [
      Expanded(
        child: Text(
          label,
          style: (strong ? AppTextStyles.h3 : AppTextStyles.bodyMd).copyWith(
            fontSize: strong ? 16 : 14,
          ),
        ),
      ),
      Text(
        value,
        style: TextStyle(
          color: strong ? AppColors.primary : AppColors.textPrimary,
          fontSize: strong ? 16 : 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}
