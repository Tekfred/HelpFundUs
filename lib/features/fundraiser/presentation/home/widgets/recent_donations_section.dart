import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';

class RecentDonationsSection extends StatelessWidget {
  const RecentDonationsSection({super.key, this.onSeeAll});

  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    const donations = [
      _Donation(
        'MT',
        'Marcus T.',
        '"Keep going! 💪"',
        '\$50',
        '2 min ago',
        Color(0xFF8255F3),
      ),
      _Donation('PS', 'Priya S.', '', '\$25', '18 min ago', Color(0xFF397FF0)),
      _Donation(
        'A',
        'Anonymous',
        '"Amazing work! ✨"',
        '\$100',
        '1 hr ago',
        Color(0xFF6D7587),
      ),
    ];
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Recent donations',
              style: AppTextStyles.h3.copyWith(fontSize: 20),
            ),
            const Spacer(),
            TextButton(
              onPressed: onSeeAll,
              child: Text(
                'See all',
                style: AppTextStyles.buttonMd.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        for (final donation in donations) _row(donation),
      ],
    );
  }

  Widget _row(_Donation donation) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderStrong)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: donation.color,
            child: Text(
              donation.initials,
              style: AppTextStyles.buttonMd.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  donation.name,
                  style: AppTextStyles.buttonMd.copyWith(fontSize: 16),
                ),
                if (donation.message.isNotEmpty)
                  Text(
                    donation.message,
                    style: AppTextStyles.bodyMd.copyWith(fontSize: 13),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                donation.amount,
                style: AppTextStyles.buttonMd.copyWith(
                  color: AppColors.primary,
                  fontSize: 16,
                ),
              ),
              Text(donation.time, style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}

class _Donation {
  const _Donation(
    this.initials,
    this.name,
    this.message,
    this.amount,
    this.time,
    this.color,
  );
  final String initials;
  final String name;
  final String message;
  final String amount;
  final String time;
  final Color color;
}
