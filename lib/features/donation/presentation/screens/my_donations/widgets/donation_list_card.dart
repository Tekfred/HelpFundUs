import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/features/donation/domain/entities/donation_record.dart';

class DonationListCard extends StatelessWidget {
  const DonationListCard({
    super.key,
    required this.donation,
    required this.onTap,
  });

  final DonationRecord donation;
  final VoidCallback onTap;

  Color get _statusColor => switch (donation.status) {
    DonationStatus.completed => AppColors.primary,
    DonationStatus.pending => const Color(0xFFE17A00),
    DonationStatus.failed => AppColors.danger,
  };

  IconData get _statusIcon => switch (donation.status) {
    DonationStatus.completed => Icons.check_circle_outline_rounded,
    DonationStatus.pending => Icons.schedule_rounded,
    DonationStatus.failed => Icons.cancel_outlined,
  };

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(22),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(22)),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: donation.gradientColorValues.map(Color.new).toList(),
                ),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Text(
                donation.campaignEmoji,
                style: const TextStyle(fontSize: 28),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    donation.campaignTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.buttonMd.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    donation.paymentDate,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 11,
                      color: const Color(0xFF9AA4B5),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_statusIcon, size: 15, color: _statusColor),
                        const SizedBox(width: 4),
                        Text(
                          donation.status.label,
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 11,
                            color: _statusColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${donation.amount.toStringAsFixed(2)}',
                  style: AppTextStyles.buttonMd.copyWith(
                    fontSize: 15,
                    color: AppColors.primary,
                  ),
                ),
                if (donation.receipt != null) ...[
                  const SizedBox(height: 13),
                  Text(
                    '▣  Receipt',
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 11,
                      color: const Color(0xFF697487),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
