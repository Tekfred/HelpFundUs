import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/features/donation/domain/entities/donation_record.dart';
import 'donation_status_chip.dart';

class DonationAmountHeader extends StatelessWidget {
  const DonationAmountHeader({super.key, required this.donation});

  final DonationRecord donation;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        'DONATION AMOUNT',
        style: AppTextStyles.label.copyWith(
          fontSize: 13,
          color: const Color(0xFF9AA4B5),
        ),
      ),
      const SizedBox(height: 12),
      Text(
        '\$${donation.amount.toStringAsFixed(2)}',
        style: AppTextStyles.h1.copyWith(
          fontSize: 42,
          color: AppColors.primary,
        ),
      ),
      const SizedBox(height: 2),
      Text('USD', style: AppTextStyles.bodyLg.copyWith(fontSize: 16)),
      const SizedBox(height: 14),
      DonationStatusChip(status: donation.status),
    ],
  );
}
