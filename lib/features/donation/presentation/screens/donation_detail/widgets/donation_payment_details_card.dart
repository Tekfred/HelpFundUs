import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/features/donation/domain/entities/donation_record.dart';

class DonationPaymentDetailsCard extends StatelessWidget {
  const DonationPaymentDetailsCard({super.key, required this.donation});

  final DonationRecord donation;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
    decoration: BoxDecoration(
      color: context.appSurface,
      borderRadius: BorderRadius.circular(22),
    ),
    child: Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Payment details',
            style: AppTextStyles.h3.copyWith(
              fontSize: 18,
              color: context.appTextPrimary,
            ),
          ),
        ),
        const SizedBox(height: 14),
        _PaymentRow(label: 'Reference', value: donation.reference),
        const _Divider(),
        _PaymentRow(label: 'Payment method', value: donation.paymentMethod),
        const _Divider(),
        _PaymentRow(label: 'Payment date', value: donation.paymentDate),
        const _Divider(),
        _PaymentRow(label: 'Donor', value: donation.donorName),
        if (donation.donorMessage != null) ...[
          const SizedBox(height: 14),
          const _Divider(),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Your message',
              style: AppTextStyles.label.copyWith(
                fontSize: 14,
                color: context.appTextMuted,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              donation.donorMessage!,
              style: AppTextStyles.bodyMd.copyWith(
                fontSize: 15,
                color: context.appTextSecondary,
              ),
            ),
          ),
        ],
      ],
    ),
  );
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyMd.copyWith(
              fontSize: 14,
              color: context.appTextSecondary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.buttonMd.copyWith(
              fontSize: 14,
              color: context.appTextPrimary,
            ),
          ),
        ),
      ],
    ),
  );
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) =>
      Divider(height: 1, thickness: 1, color: context.appDivider);
}
