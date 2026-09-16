import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/features/campaign/data/campaign_catalog.dart';

class CampaignUpdateCard extends StatelessWidget {
  const CampaignUpdateCard({
    super.key,
    required this.update,
    required this.fundraiser,
    required this.gradient,
  });

  final CampaignUpdate update;
  final String fundraiser;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: context.appSurface,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text(update.emoji, style: const TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    update.title,
                    style: AppTextStyles.h3.copyWith(
                      fontSize: 15,
                      color: context.appTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'by $fundraiser · ${update.when}',
                    style: AppTextStyles.bodyMd.copyWith(
                      fontSize: 12,
                      color: context.appTextMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          update.message,
          style: AppTextStyles.bodyLg.copyWith(
            fontSize: 14,
            color: context.appTextSecondary,
            height: 1.48,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 88,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                gradient.colors.first.withValues(alpha: .22),
                gradient.colors.last.withValues(alpha: .18),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.appBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.image_outlined, size: 20, color: context.appTextMuted),
              const SizedBox(width: 8),
              Text(
                '1 photo attached',
                style: AppTextStyles.bodyMd.copyWith(
                  fontSize: 12,
                  color: context.appTextMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
