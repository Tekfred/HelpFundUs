import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/features/donation/presentation/screens/choose_donation_amount/widgets/campaign_summary.dart';

class PaymentSummaryCard extends StatelessWidget {
  const PaymentSummaryCard({
    super.key,
    required this.amount,
    required this.fee,
    required this.total,
    required this.method,
    required this.reference,
  });

  final double amount;
  final double fee;
  final double total;
  final String method;
  final String reference;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
    decoration: BoxDecoration(
      color: context.appSurface,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Column(
      children: [
        const CampaignSummary(
          title: 'Help rebuild our community centre',
          emoji: '🏘️',
        ),
        const SizedBox(height: 12),
        _row(context, 'Amount', '\$${amount.toStringAsFixed(2)} USD'),
        const _SummaryDivider(),
        _row(context, 'Processing fee', '\$${fee.toStringAsFixed(2)}'),
        const _SummaryDivider(),
        _row(
          context,
          'Total charged',
          '\$${total.toStringAsFixed(2)} USD',
          total: true,
        ),
        const _SummaryDivider(),
        _row(context, 'Method', method),
        const _SummaryDivider(),
        _row(context, 'Transaction ref', reference),
      ],
    ),
  );

  Widget _row(
    BuildContext context,
    String label,
    String value, {
    bool total = false,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyMd.copyWith(
              fontSize: 15,
              color: context.appTextSecondary,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: AppTextStyles.buttonMd.copyWith(
                fontSize: 15,
                color: total ? AppColors.primary : context.appTextPrimary,
              ),
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
      Divider(height: 1, thickness: 1, color: context.appDivider);
}
