import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/features/campaign/data/campaign_catalog.dart';
import 'package:helpfundus/features/campaign/presentation/screens/campaign_detail/widgets/milestone_card.dart';

class CampaignMilestonesScreen extends StatelessWidget {
  const CampaignMilestonesScreen({super.key, required this.campaign});
  final CampaignData campaign;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.appBackground,
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
        children: [
          _header(context),
          const SizedBox(height: 14),
          _summary(context),
          const SizedBox(height: 20),
          ...List.generate(
            campaign.milestones.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: MilestoneCard(
                milestone: campaign.milestones[index],
                index: index,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _header(BuildContext context) => Row(
    children: [
      Material(
        color: context.appSurface,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: () => Navigator.of(context).pop(),
          customBorder: const CircleBorder(),
          child: const SizedBox(
            width: 52,
            height: 52,
            child: Icon(Icons.arrow_back_ios_new_rounded, size: 22),
          ),
        ),
      ),
      Expanded(
        child: Text(
          'Milestones',
          textAlign: TextAlign.center,
          style: AppTextStyles.h2.copyWith(
            fontSize: 22,
            color: context.appTextPrimary,
          ),
        ),
      ),
      const SizedBox(width: 52),
    ],
  );

  Widget _summary(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: context.appSurface,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              campaign.amount,
              style: AppTextStyles.h2.copyWith(
                fontSize: 24,
                color: AppColors.primary,
              ),
            ),
            const Spacer(),
            Text(
              'of ${campaign.goal} goal',
              style: AppTextStyles.bodyMd.copyWith(
                fontSize: 14,
                color: context.appTextMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: campaign.progress,
            minHeight: 7,
            color: AppColors.primary,
            backgroundColor: context.isDarkTheme
                ? AppColors.dividerDark
                : const Color(0xFFE1E4E9),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${(campaign.progress * 100).round()}% funded · ${campaign.donors} donors',
          style: AppTextStyles.bodyMd.copyWith(
            fontSize: 14,
            color: context.appTextSecondary,
          ),
        ),
      ],
    ),
  );
}
