import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/features/donation/domain/entities/donation_record.dart';

class DonationSummaryCard extends StatelessWidget {
  const DonationSummaryCard({super.key, required this.donations});

  final List<DonationRecord> donations;

  @override
  Widget build(BuildContext context) {
    final completed = donations
        .where((donation) => donation.status == DonationStatus.completed)
        .toList();
    final total = completed.fold<double>(
      0,
      (sum, donation) => sum + donation.amount,
    );
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF12A9D9)],
        ),
        borderRadius: BorderRadius.circular(27),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL DONATED',
            style: AppTextStyles.buttonMd.copyWith(
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: AppTextStyles.h1.copyWith(
                  fontSize: 34,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.favorite_border_rounded,
                size: 45,
                color: Color(0x88FFFFFF),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            '${completed.length} successful donations',
            style: AppTextStyles.bodyMd.copyWith(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
