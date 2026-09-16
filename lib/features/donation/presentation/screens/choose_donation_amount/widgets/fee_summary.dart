import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';

class FeeSummary extends StatelessWidget {
  const FeeSummary({super.key, required this.fee});

  final double fee;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: context.appSurface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: context.appBorderStrong),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _row(context, 'Your donation', '\$${(fee / .029).toStringAsFixed(2)}'),
        const SizedBox(height: 8),
        _row(
          context,
          'Platform fee (2.9% — optional tip)',
          '\$${fee.toStringAsFixed(2)}',
          muted: true,
        ),
        const Divider(height: 24),
        _row(
          context,
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
    BuildContext context,
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
          color: strong ? AppColors.primary : context.appTextPrimary,
          fontSize: strong ? 16 : 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}
