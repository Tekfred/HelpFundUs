import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/features/fundraiser/domain/entities/fundraiser_campaign.dart';

class CampaignManagementHeader extends StatelessWidget {
  const CampaignManagementHeader({
    super.key,
    required this.campaign,
    required this.onBack,
  });

  final FundraiserCampaign campaign;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Container(
    height: 68,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: context.appDivider)),
    ),
    child: Row(
      children: [
        Material(
          color: context.appSurface,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onBack,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: 38,
              height: 38,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 17,
                color: context.appTextPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Campaign Management',
                style: AppTextStyles.buttonMd.copyWith(
                  fontSize: 15,
                  color: context.appTextPrimary,
                ),
              ),
              Text(
                campaign.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  fontSize: 11,
                  color: context.appTextMuted,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(99),
          ),
          child: Text(
            'Live',
            style: AppTextStyles.buttonMd.copyWith(
              fontSize: 11,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    ),
  );
}
