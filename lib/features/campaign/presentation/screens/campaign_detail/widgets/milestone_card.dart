import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/features/campaign/data/campaign_catalog.dart';

class MilestoneCard extends StatelessWidget {
  const MilestoneCard({
    super.key,
    required this.milestone,
    required this.index,
  });

  final CampaignMilestone milestone;
  final int index;

  @override
  Widget build(BuildContext context) {
    final inProgress = !milestone.completed && index == 1;
    final color = milestone.completed
        ? AppColors.primary
        : inProgress
        ? AppColors.warning
        : const Color(0xFFCBD1DB);
    final status = milestone.completed
        ? 'COMPLETED'
        : inProgress
        ? 'IN PROGRESS'
        : 'UPCOMING';
    final parts = milestone.dateAmount.split(' · ');
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: milestone.completed || inProgress
                ? color
                : Colors.white,
            child: Icon(
              milestone.completed ? Icons.check : Icons.circle_outlined,
              color: milestone.completed || inProgress
                  ? Colors.white
                  : const Color(0xFF9AA4B5),
              size: 19,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        milestone.title,
                        style: AppTextStyles.h3.copyWith(fontSize: 15),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: .15),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        status,
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 11,
                          color: color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Target: ${parts.last}',
                  style: AppTextStyles.bodyMd.copyWith(
                    fontSize: 12,
                    color: const Color(0xFF9AA4B5),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  parts.first,
                  style: AppTextStyles.bodyMd.copyWith(
                    fontSize: 12,
                    color: const Color(0xFF9AA4B5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
