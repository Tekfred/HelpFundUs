import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../models/campaign_catalog.dart';

enum CampaignCardVariant { featured, feed }

class CampaignCard extends StatelessWidget {
  const CampaignCard({
    super.key,
    required this.title,
    required this.category,
    required this.amount,
    required this.progress,
    required this.location,
    this.icon = '🏘️',
    this.gradient = AppColors.cardGradient,
    this.variant = CampaignCardVariant.feed,
    this.donors = 248,
    this.onTap,
  });
  final String title, category, amount, location, icon;
  final double progress;
  final Gradient gradient;
  final CampaignCardVariant variant;
  final int donors;
  final VoidCallback? onTap;

  CampaignCard.fromCampaign({
    super.key,
    required CampaignData campaign,
    this.variant = CampaignCardVariant.feed,
    this.onTap,
  }) : title = campaign.title,
       category = campaign.category,
       amount = campaign.amount,
       progress = campaign.progress,
       location = campaign.location,
       icon = campaign.icon,
       gradient = campaign.gradient,
       donors = campaign.donors;
  @override
  Widget build(BuildContext context) {
    final featured = variant == CampaignCardVariant.featured;
    return SizedBox(
      // ListView gives its children unbounded vertical constraints. The fixed
      // card height makes the inner Expanded area valid for both feed and
      // horizontal featured presentations.
      height: featured ? 220 : 278,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Ink(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x120A6038),
                  blurRadius: 12,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: featured ? 108 : 150,
                  child: DecoratedBox(
                    decoration: BoxDecoration(gradient: gradient),
                    child: Stack(
                      children: [
                        const Positioned(
                          top: 10,
                          left: 12,
                          child: Icon(
                            Icons.verified_outlined,
                            color: AppColors.primary,
                            size: 19,
                          ),
                        ),
                        Center(
                          child: Text(
                            icon,
                            style: TextStyle(
                              fontSize: featured ? 42 : 54,
                              shadows: const [
                                Shadow(
                                  color: Color(0x420A1B3D),
                                  offset: Offset(0, 4),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xB9273C8F),
                              borderRadius: BorderRadius.circular(
                                AppRadius.pill,
                              ),
                            ),
                            child: Text(
                              category,
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      featured ? 14 : 16,
                      featured ? 11 : 12,
                      featured ? 14 : 16,
                      featured ? 12 : 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          // Trending/feed typography intentionally matches the
                          // compact Featured presentation to keep two-line titles
                          // inside the fixed card height at all phone widths.
                          style: AppTextStyles.buttonMd.copyWith(height: 1.18),
                        ),
                        if (!featured) _location(),
                        const Spacer(),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 7,
                            backgroundColor: const Color(0xFFE1E4E9),
                            valueColor: const AlwaysStoppedAnimation(
                              AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              amount,
                              style: AppTextStyles.buttonMd.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              featured
                                  ? '${(progress * 100).round()}%'
                                  : '${(progress * 100).round()}% · $donors donors',
                              style: AppTextStyles.caption.copyWith(
                                color: const Color(0xFF8E99AA),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _location() => Padding(
    padding: const EdgeInsets.only(top: 5),
    child: Row(
      children: [
        const Icon(
          Icons.location_on_outlined,
          color: Color(0xFF9AA4B5),
          size: 16,
        ),
        const SizedBox(width: 3),
        Expanded(
          child: Text(
            location,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: const Color(0xFF9AA4B5),
            ),
          ),
        ),
      ],
    ),
  );
}
