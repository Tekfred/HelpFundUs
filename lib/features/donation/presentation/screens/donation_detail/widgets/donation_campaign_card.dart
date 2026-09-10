import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/features/donation/domain/entities/donation_record.dart';

class DonationCampaignCard extends StatelessWidget {
  const DonationCampaignCard({super.key, required this.donation});

  final DonationRecord donation;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
    ),
    child: Row(
      children: [
        Container(
          width: 60,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: donation.gradientColorValues.map(Color.new).toList(),
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            donation.campaignEmoji,
            style: const TextStyle(fontSize: 30),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                donation.campaignTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.h3.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 9),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                        value: donation.campaignProgress,
                        minHeight: 6,
                        color: AppColors.primary,
                        backgroundColor: const Color(0xFFE3E5EA),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${(donation.campaignProgress * 100).round()}%',
                    style: AppTextStyles.label.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 34,
          height: 25,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: .10),
            border: Border.all(color: AppColors.primary.withValues(alpha: .5)),
            borderRadius: BorderRadius.circular(99),
          ),
          child: const Icon(
            Icons.verified_rounded,
            size: 14,
            color: AppColors.primary,
          ),
        ),
      ],
    ),
  );
}
