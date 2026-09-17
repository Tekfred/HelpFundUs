import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/core/widgets/animated_progress_bar.dart';
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
    margin: EdgeInsets.only(bottom: dashboardVariant ? 10 : 10),
    padding: EdgeInsets.all(dashboardVariant ? 12 : 12),
    decoration: BoxDecoration(
      color: context.appSurface,
      borderRadius: BorderRadius.circular(dashboardVariant ? 20 : 20),
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
                  _icon(size: 52),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          campaign.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.h3.copyWith(
                            fontSize: 15,
                            color: context.appTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
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
                                  fontSize: 10,
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
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: context.appInput,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF9AA4B5),
                    ),
                  ),
                ],
              ),
              if (campaign.reviewerNote != null) ...[
                const SizedBox(height: 10),
                _notice(
                  campaign.reviewerNote!,
                  const Color(0xFFEAF2FF),
                  const Color(0xFF2563EB),
                ),
              ],
              if (campaign.suspendedReason != null) ...[
                const SizedBox(height: 10),
                _notice(
                  campaign.suspendedReason!,
                  const Color(0xFFFFF0F0),
                  AppColors.danger,
                ),
              ],
              if (campaign.status == FundraiserCampaignStatus.active ||
                  campaign.status == FundraiserCampaignStatus.closed) ...[
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: AnimatedProgressBar(
                    value: campaign.progress,
                    minHeight: 6,
                    color: AppColors.primary,
                    backgroundColor: context.isDarkTheme
                        ? AppColors.dividerDark
                        : const Color(0xFFE3E5EA),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '\$${campaign.amountRaised.toStringAsFixed(0)} raised',
                      style: AppTextStyles.buttonMd.copyWith(
                        fontSize: 12,
                        color: AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${(campaign.progress * 100).round()}% · ${campaign.donorCount} donors',
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 11,
                        color: context.appTextMuted,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 10),
              _actions(context),
            ],
          ),
  );

  Widget _dashboardContent(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          _icon(size: 54),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  campaign.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.h3.copyWith(
                    fontSize: 15,
                    color: context.appTextPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Live · ${campaign.daysRemaining} days remaining',
                  style: AppTextStyles.bodyMd.copyWith(
                    fontSize: 12,
                    color: context.appTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
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
      const SizedBox(height: 12),
      ClipRRect(
        borderRadius: BorderRadius.circular(99),
        child: AnimatedProgressBar(
          value: campaign.progress,
          minHeight: 6,
          color: AppColors.primary,
          backgroundColor: context.isDarkTheme
              ? AppColors.dividerDark
              : const Color(0xFFE3E5EA),
        ),
      ),
      const SizedBox(height: 9),
      Row(
        children: [
          Text(
            '\$${campaign.amountRaised.toStringAsFixed(0)}',
            style: AppTextStyles.h2.copyWith(
              fontSize: 24,
              color: AppColors.primary,
            ),
          ),
          const Spacer(),
          Text(
            'of \$${campaign.goal.toStringAsFixed(0)} · ${(campaign.progress * 100).round()}%',
            style: AppTextStyles.bodyMd.copyWith(
              fontSize: 12,
              color: context.appTextSecondary,
            ),
          ),
        ],
      ),
      const SizedBox(height: 11),
      Row(
        children: [
          Expanded(
            flex: 11,
            child: SizedBox(
              height: 44,
              child: OutlinedButton(
                onPressed: onManage,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  backgroundColor: AppColors.primary.withValues(alpha: .09),
                  side: BorderSide(
                    color: AppColors.primary.withValues(alpha: .20),
                  ),
                ),
                child: Text(
                  'Manage',
                  style: AppTextStyles.buttonMd.copyWith(fontSize: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 13,
            child: SizedBox(
              height: 44,
              child: FilledButton.icon(
                onPressed: onPerformance,
                style: FilledButton.styleFrom(
                  backgroundColor: context.isDarkTheme
                      ? context.appInput
                      : const Color(0xFFF2F3F6),
                  foregroundColor: context.appTextPrimary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  textStyle: AppTextStyles.buttonMd.copyWith(fontSize: 12),
                ),
                icon: const Icon(Icons.bar_chart_rounded, size: 17),
                label: const Text(
                  'Performance',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 48,
            height: 44,
            child: FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: context.appInput,
                foregroundColor: context.appTextSecondary,
                elevation: 0,
                padding: EdgeInsets.zero,
              ),
              child: const Icon(Icons.share_outlined, size: 20),
            ),
          ),
        ],
      ),
    ],
  );
  Widget _icon({double size = 58}) => Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: campaign.gradientColorValues.map(Color.new).toList(),
      ),
      borderRadius: BorderRadius.circular(size == 58 ? 17 : 16),
    ),
    child: Text(
      campaign.icon,
      style: TextStyle(fontSize: size == 58 ? 28 : 26),
    ),
  );
  Widget _pill() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .11),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Text(
      campaign.status.label,
      style: AppTextStyles.caption.copyWith(
        color: color,
        fontSize: 10,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
  Widget _notice(String text, Color bg, Color foreground) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(13),
    ),
    child: Text(
      'ⓘ  $text',
      style: AppTextStyles.bodyMd.copyWith(
        fontSize: 12,
        height: 1.35,
        color: foreground,
      ),
    ),
  );
  Widget _actions(BuildContext context) {
    final isInReview = campaign.status == FundraiserCampaignStatus.inReview;
    final label = switch (campaign.status) {
      FundraiserCampaignStatus.active => 'Manage',
      FundraiserCampaignStatus.draft => 'Edit',
      FundraiserCampaignStatus.inReview => 'Contact support',
      FundraiserCampaignStatus.closed => 'Request payout',
      FundraiserCampaignStatus.suspended => 'Appeal suspension',
    };
    if (campaign.status == FundraiserCampaignStatus.draft) {
      return Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 44,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: context.appTextSecondary,
                  backgroundColor: context.isDarkTheme
                      ? context.appInput
                      : const Color(0xFFF2F3F6),
                  side: BorderSide(color: context.appBorderStrong),
                  textStyle: AppTextStyles.buttonMd.copyWith(fontSize: 13),
                ),
                child: const Text('Edit'),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 44,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  backgroundColor: AppColors.primary.withValues(alpha: .09),
                  side: BorderSide(
                    color: AppColors.primary.withValues(alpha: .20),
                  ),
                  textStyle: AppTextStyles.buttonMd.copyWith(fontSize: 13),
                ),
                child: const Text('Submit for review'),
              ),
            ),
          ),
        ],
      );
    }
    if (campaign.status == FundraiserCampaignStatus.active) {
      return Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 44,
              child: OutlinedButton(
                onPressed: onManage,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  backgroundColor: AppColors.primary.withValues(alpha: .09),
                  side: BorderSide(
                    color: AppColors.primary.withValues(alpha: .20),
                  ),
                  textStyle: AppTextStyles.buttonMd.copyWith(fontSize: 13),
                ),
                child: const Text('Manage'),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 44,
              child: FilledButton.icon(
                onPressed: onPerformance,
                style: FilledButton.styleFrom(
                  backgroundColor: context.isDarkTheme
                      ? context.appInput
                      : const Color(0xFFF2F3F6),
                  foregroundColor: context.appTextPrimary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  textStyle: AppTextStyles.buttonMd.copyWith(fontSize: 13),
                ),
                icon: const Icon(Icons.bar_chart_rounded, size: 17),
                label: const Text(
                  'Performance',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      );
    }
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: campaign.status == FundraiserCampaignStatus.closed
          ? FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF6441E8),
                textStyle: AppTextStyles.buttonMd.copyWith(fontSize: 13),
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
                    : isInReview
                    ? (context.isDarkTheme
                          ? context.appTextSecondary
                          : const Color(0xFF697487))
                    : null,
                backgroundColor: isInReview
                    ? (context.isDarkTheme
                          ? context.appInput
                          : const Color(0xFFF2F3F6))
                    : null,
                side: isInReview ? BorderSide.none : null,
                textStyle: AppTextStyles.buttonMd.copyWith(fontSize: 13),
              ),
              child: Text(label),
            ),
    );
  }
}
