import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/features/donation/presentation/screens/choose_donation_amount/widgets/campaign_summary.dart';

class PaymentTransactionSummary extends StatelessWidget {
  const PaymentTransactionSummary({
    super.key,
    required this.amount,
    required this.method,
    required this.reference,
    required this.status,
    required this.statusColor,
    this.fee,
    this.total,
  });

  final double amount;
  final double? fee;
  final double? total;
  final String method;
  final String reference;
  final String status;
  final Color statusColor;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      children: [
        const CampaignSummary(
          title: 'Help rebuild our community centre',
          emoji: '🏘️',
        ),
        const SizedBox(height: 12),
        _SummaryRow(
          label: 'Amount',
          value: '\$${amount.toStringAsFixed(2)} USD',
        ),
        if (fee != null) ...[
          const _SummaryDivider(),
          _SummaryRow(
            label: 'Processing fee',
            value: '\$${fee!.toStringAsFixed(2)}',
          ),
        ],
        if (total != null) ...[
          const _SummaryDivider(),
          _SummaryRow(
            label: 'Total charged',
            value: '\$${total!.toStringAsFixed(2)} USD',
            valueColor: AppColors.primary,
          ),
        ],
        const _SummaryDivider(),
        _SummaryRow(label: 'Method', value: method),
        const _SummaryDivider(),
        _SummaryRow(label: 'Reference', value: reference),
        const _SummaryDivider(),
        _SummaryRow(label: 'Status', value: status, valueColor: statusColor),
      ],
    ),
  );
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.textPrimary,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyMd.copyWith(fontSize: 15),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: AppTextStyles.buttonMd.copyWith(
              fontSize: 15,
              color: valueColor,
            ),
          ),
        ),
      ],
    ),
  );
}

class _SummaryDivider extends StatelessWidget {
  const _SummaryDivider();

  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, thickness: 1, color: AppColors.borderStrong);
}
