import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/features/fundraiser/domain/entities/fundraiser_campaign.dart';

class PerformanceChartCard extends StatelessWidget {
  const PerformanceChartCard({super.key, required this.campaign});

  final FundraiserCampaign campaign;

  @override
  Widget build(BuildContext context) {
    const values = [
      12.0,
      24.0,
      17.0,
      30.0,
      11.0,
      26.0,
      21.0,
      33.0,
      28.0,
      46.0,
      39.0,
      88.0,
    ];
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 48,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var index = 0; index < values.length; index++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: values[index] / 2,
                          decoration: BoxDecoration(
                            color: index == values.length - 1
                                ? AppColors.primary
                                : AppColors.primary.withValues(alpha: .28),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '14 days ago',
                style: AppTextStyles.caption.copyWith(
                  color: context.appTextMuted,
                ),
              ),
              Text(
                'Today',
                style: AppTextStyles.caption.copyWith(
                  color: context.appTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(height: 1, color: context.appDivider),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.trending_up_rounded,
                size: 17,
                color: AppColors.primary,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: AppTextStyles.bodySm.copyWith(
                      fontSize: 12,
                      color: context.appTextSecondary,
                    ),
                    children: [
                      const TextSpan(text: 'Campaign is performing '),
                      TextSpan(
                        text: 'above average',
                        style: AppTextStyles.bodySm.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      const TextSpan(text: ' for its category.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
