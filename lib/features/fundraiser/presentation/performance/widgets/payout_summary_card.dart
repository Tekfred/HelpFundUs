import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';

class PayoutSummaryCard extends StatelessWidget {
  const PayoutSummaryCard({super.key, required this.totalRaised});

  final double totalRaised;

  @override
  Widget build(BuildContext context) {
    final fee = totalRaised * .029;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _row(context, 'Total raised', '\$${totalRaised.toStringAsFixed(0)}'),
          _divider(context),
          _row(context, 'Platform fee (2.9%)', '−\$${fee.toStringAsFixed(2)}'),
          _divider(context),
          _row(context, 'Total paid out', '−\$0'),
          _divider(context),
          _row(
            context,
            'Available balance',
            '\$0',
            valueColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _row(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return SizedBox(
      height: 36,
      child: Row(
        children: [
          Text(
            label,
            style: AppTextStyles.bodySm.copyWith(
              fontSize: 12,
              color: context.appTextSecondary,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.buttonMd.copyWith(
              fontSize: 12,
              color: valueColor ?? context.appTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) =>
      Divider(height: 1, color: context.appDivider);
}
