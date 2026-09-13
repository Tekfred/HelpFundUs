import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _row('Total raised', '\$${totalRaised.toStringAsFixed(0)}'),
          _divider(),
          _row('Platform fee (2.9%)', '−\$${fee.toStringAsFixed(2)}'),
          _divider(),
          _row('Total paid out', '−\$0'),
          _divider(),
          _row('Available balance', '\$0', valueColor: AppColors.primary),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {Color? valueColor}) {
    return SizedBox(
      height: 36,
      child: Row(
        children: [
          Text(label, style: AppTextStyles.bodySm.copyWith(fontSize: 12)),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.buttonMd.copyWith(
              fontSize: 12,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(height: 1, color: AppColors.borderStrong);
}
