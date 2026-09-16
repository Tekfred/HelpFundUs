import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/features/fundraiser/domain/entities/fundraiser_campaign.dart';

class FundraiserCampaignCard extends StatelessWidget {
  const FundraiserCampaignCard({
    super.key,
    required this.campaign,
    required this.onManage,
    this.dashboardVariant = false,
    this.onPerformance,
  });
  final FundraiserCampaign campaign;
  final VoidCallback onManage;
  final bool dashboardVariant;
  final VoidCallback? onPerformance;
  Color get color => switch (campaign.status) {
    FundraiserCampaignStatus.active => AppColors.primary,
    FundraiserCampaignStatus.inReview => const Color(0xFF2563EB),
    FundraiserCampaignStatus.suspended => AppColors.danger,
    _ => const Color(0xFF9AA4B5),
  };
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: context.appSurface,
      borderRadius: BorderRadius.circular(22),
      border: campaign.status == FundraiserCampaignStatus.suspended
          ? Border.all(color: AppColors.danger.withValues(alpha: .35), width: 2)
          : null,
    ),
    child: dashboardVariant
        ? _dashboardContent(context)
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _icon(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          campaign.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.h3.copyWith(
                            fontSize: 16,
                            color: context.appTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            _pill(),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                campaign.updatedAt,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.caption.copyWith(
                                  fontSize: 11,
                                  color: context.appTextMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: context.appInput,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF9AA4B5),
                    ),
                  ),
                ],
              ),
              if (campaign.reviewerNote != null) ...[
                const SizedBox(height: 12),
                _notice(
                  campaign.reviewerNote!,
                  const Color(0xFFEAF2FF),
                  const Color(0xFF2563EB),
                ),
              ],
              if (campaign.suspendedReason != null) ...[
                const SizedBox(height: 12),
                _notice(
                  campaign.suspendedReason!,
                  const Color(0xFFFFF0F0),
                  AppColors.danger,
                ),
              ],
              if (campaign.status == FundraiserCampaignStatus.active ||
                  campaign.status == FundraiserCampaignStatus.closed) ...[
                const SizedBox(height: 13),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: campaign.progress,
                    minHeight: 6,
                    color: AppColors.primary,
                    backgroundColor: context.isDarkTheme
                        ? AppColors.dividerDark
                        : const Color(0xFFE3E5EA),
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Text(
                      '\$${campaign.amountRaised.toStringAsFixed(0)} raised',
                      style: AppTextStyles.buttonMd.copyWith(
                        fontSize: 13,
                        color: AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${(campaign.progress * 100).round()}% · ${campaign.donorCount} donors',
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 12,
                        color: context.appTextMuted,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 13),
              _actions(context),
            ],
          ),
  );

  Widget _dashboardContent(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          _icon(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  campaign.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.h3.copyWith(
                    fontSize: 16,
                    color: context.appTextPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Live · ${campaign.daysRemaining} days remaining',
                  style: AppTextStyles.bodyMd.copyWith(
                    fontSize: 13,
                    color: context.appTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              'LIVE',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      ClipRRect(
        borderRadius: BorderRadius.circular(99),
        child: LinearProgressIndicator(
          value: campaign.progress,
          minHeight: 7,
          color: AppColors.primary,
          backgroundColor: context.isDarkTheme
              ? AppColors.dividerDark
              : const Color(0xFFE3E5EA),
        ),
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Text(
            '\$${campaign.amountRaised.toStringAsFixed(0)}',
            style: AppTextStyles.h2.copyWith(
              fontSize: 26,
              color: AppColors.primary,
            ),
          ),
          const Spacer(),
          Text(
            'of \$${campaign.goal.toStringAsFixed(0)} · ${(campaign.progress * 100).round()}%',
            style: AppTextStyles.bodyMd.copyWith(
              fontSize: 13,
              color: context.appTextSecondary,
            ),
          ),
        ],
      ),
      const SizedBox(height: 14),
      Row(
        children: [
          Expanded(
            flex: 11,
            child: SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: onManage,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  backgroundColor: AppColors.primary.withValues(alpha: .09),
                  side: BorderSide(
                    color: AppColors.primary.withValues(alpha: .20),
                  ),
                ),
                child: const Text('Manage'),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 13,
            child: SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: onPerformance,
                style: FilledButton.styleFrom(
                  backgroundColor: context.appInput,
                  foregroundColor: context.appTextPrimary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  textStyle: AppTextStyles.buttonMd.copyWith(fontSize: 13),
                ),
                icon: const Icon(Icons.bar_chart_rounded, size: 18),
                label: const Text(
                  'Performance',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 54,
            height: 48,
            child: FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: context.appInput,
                foregroundColor: context.appTextSecondary,
                elevation: 0,
                padding: EdgeInsets.zero,
              ),
              child: const Icon(Icons.share_outlined, size: 22),
            ),
          ),
        ],
      ),
    ],
  );
  Widget _icon() => Container(
    width: 58,
    height: 58,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: campaign.gradientColorValues.map(Color.new).toList(),
      ),
      borderRadius: BorderRadius.circular(17),
    ),
    child: Text(campaign.icon, style: const TextStyle(fontSize: 28)),
  );
  Widget _pill() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .11),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Text(
      campaign.status.label,
      style: AppTextStyles.caption.copyWith(
        color: color,
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
  Widget _notice(String text, Color bg, Color foreground) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Text(
      'ⓘ  $text',
      style: AppTextStyles.bodyMd.copyWith(
        fontSize: 13,
        height: 1.35,
        color: foreground,
      ),
    ),
  );
  Widget _actions(BuildContext context) {
    final label = switch (campaign.status) {
      FundraiserCampaignStatus.active => 'Manage',
      FundraiserCampaignStatus.draft => 'Edit',
      FundraiserCampaignStatus.inReview => 'Contact support',
      FundraiserCampaignStatus.closed => 'Request payout',
      FundraiserCampaignStatus.suspended => 'Appeal suspension',
    };
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: campaign.status == FundraiserCampaignStatus.closed
          ? FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF6441E8),
              ),
              child: Text(label),
            )
          : OutlinedButton(
              onPressed: campaign.status == FundraiserCampaignStatus.active
                  ? onManage
                  : () {},
              style: OutlinedButton.styleFrom(
                foregroundColor:
                    campaign.status == FundraiserCampaignStatus.suspended
                    ? AppColors.danger
                    : null,
              ),
              child: Text(label),
            ),
    );
  }
}
