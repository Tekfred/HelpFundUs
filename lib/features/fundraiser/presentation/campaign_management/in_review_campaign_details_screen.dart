import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/core/widgets/animated_progress_bar.dart';
import 'package:helpfundus/core/widgets/app_share_sheet.dart';
import 'package:helpfundus/features/fundraiser/domain/entities/fundraiser_campaign.dart';
import 'package:helpfundus/features/fundraiser/presentation/campaign_management/campaign_management_options_screen.dart';
import 'package:helpfundus/features/fundraiser/presentation/performance/performance_screen.dart';

/// Read-only detail page for campaigns awaiting review.
class InReviewCampaignDetailsScreen extends StatelessWidget {
  const InReviewCampaignDetailsScreen({super.key, required this.campaign});

  final FundraiserCampaign campaign;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.appBackground,
    body: Column(
      children: [
        SizedBox(
          height: 320,
          child: Stack(
            children: [
              _hero(context),
              Positioned(
                top: MediaQuery.paddingOf(context).top + 14,
                left: 16,
                right: 16,
                child: _actions(context),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 36),
            children: [
              Text(
                campaign.title,
                style: AppTextStyles.h2.copyWith(
                  fontSize: 20,
                  color: context.appTextPrimary,
                ),
              ),
              if (campaign.reviewerNote != null) ...[
                const SizedBox(height: 16),
                _reviewerNote(context),
              ],
              const SizedBox(height: 20),
              _summary(context),
              const SizedBox(height: 22),
              Text(
                'Launch Checklist',
                style: AppTextStyles.buttonMd.copyWith(
                  fontSize: 16,
                  color: context.appTextPrimary,
                ),
              ),
              const SizedBox(height: 10),
              _launchChecklistCard(context),
              const SizedBox(height: 22),
              _managementHeading(context),
              const SizedBox(height: 10),
              _managementTools(context),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _hero(BuildContext context) => Container(
    height: 320,
    padding: EdgeInsets.fromLTRB(
      16,
      MediaQuery.paddingOf(context).top + 14,
      16,
      18,
    ),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: campaign.gradientColorValues.map(Color.new).toList(),
      ),
    ),
    child: Column(
      children: [
        const SizedBox(height: 46),
        const Spacer(),
        Text(campaign.icon, style: const TextStyle(fontSize: 72)),
        const Spacer(),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .94),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              'In review',
              style: AppTextStyles.buttonMd.copyWith(
                fontSize: 14,
                color: const Color(0xFF2563EB),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _actions(BuildContext context) => Row(
    children: [
      _action(
        Icons.arrow_back_ios_new_rounded,
        () => Navigator.of(context).pop(),
      ),
      const Spacer(),
      _action(Icons.share_outlined, () => _share(context)),
      const SizedBox(width: 8),
      _action(
        Icons.open_in_new_rounded,
        () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This campaign will be available after approval.'),
          ),
        ),
      ),
    ],
  );

  Widget _action(IconData icon, VoidCallback onTap) => Material(
    color: Colors.white.withValues(alpha: .25),
    shape: const CircleBorder(),
    child: InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: SizedBox(
        width: 46,
        height: 46,
        child: Icon(icon, size: 20, color: Colors.white),
      ),
    ),
  );

  Widget _reviewerNote(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(
        0xFF2563EB,
      ).withValues(alpha: context.isDarkTheme ? .14 : .08),
      border: Border.all(color: const Color(0xFF2563EB).withValues(alpha: .28)),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.error_outline_rounded,
          size: 23,
          color: Color(0xFF2563EB),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reviewer note',
                style: AppTextStyles.buttonMd.copyWith(
                  fontSize: 16,
                  color: const Color(0xFF2563EB),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                campaign.reviewerNote!,
                style: AppTextStyles.bodyMd.copyWith(
                  fontSize: 13,
                  height: 1.4,
                  color: context.appTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _summary(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: context.appSurface,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: context.appBorder),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Text(
              '${String.fromCharCode(36)}${campaign.amountRaised.toStringAsFixed(0)}',
              style: AppTextStyles.h2.copyWith(
                fontSize: 26,
                color: AppColors.primary,
              ),
            ),
            const Spacer(),
            Text(
              'of ${String.fromCharCode(36)}${campaign.goal.toStringAsFixed(0)} goal',
              style: AppTextStyles.bodyMd.copyWith(
                fontSize: 13,
                color: context.appTextSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: AnimatedProgressBar(
            value: campaign.progress,
            minHeight: 7,
            color: AppColors.primary,
            backgroundColor: context.isDarkTheme
                ? AppColors.dividerDark
                : const Color(0xFFE3E5EA),
          ),
        ),
        const SizedBox(height: 14),
        Divider(height: 1, color: context.appDivider),
        const SizedBox(height: 14),
        Row(
          children: [
            _metric(context, '${campaign.donorCount}', 'Donors'),
            _metric(
              context,
              '${(campaign.progress * 100).round()}%',
              'Progress',
            ),
            _metric(context, 'Ended', 'Days left'),
          ],
        ),
      ],
    ),
  );

  Widget _metric(BuildContext context, String value, String label) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTextStyles.h3.copyWith(
            fontSize: 18,
            color: context.appTextPrimary,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: AppTextStyles.bodySm.copyWith(
            fontSize: 12,
            color: context.appTextMuted,
          ),
        ),
      ],
    ),
  );

  Widget _launchChecklistCard(BuildContext context) => _card(
    context,
    child: _tool(
      context,
      icon: Icons.check_circle_outline_rounded,
      iconColor: AppColors.primary,
      title: 'Campaign checklist',
      subtitle: 'Tap to view and manage setup tasks',
      trailing: _pill('3/5'),
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Campaign checklist is ready to review.')),
      ),
    ),
  );

  Widget _managementHeading(BuildContext context) => Row(
    children: [
      Text(
        'Campaign management',
        style: AppTextStyles.buttonMd.copyWith(
          fontSize: 16,
          color: context.appTextPrimary,
        ),
      ),
      const Spacer(),
      TextButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => CampaignManagementOptionsScreen(campaign: campaign),
          ),
        ),
        child: Text(
          'More tools  ›',
          style: AppTextStyles.buttonMd.copyWith(
            fontSize: 14,
            color: AppColors.primary,
          ),
        ),
      ),
    ],
  );

  Widget _managementTools(BuildContext context) => _card(
    context,
    child: Column(
      children: [
        _tool(
          context,
          icon: Icons.trending_up_rounded,
          iconColor: AppColors.primary,
          title: 'Performance analytics',
          subtitle: 'Donations, trends, reach',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => PerformanceScreen(campaign: campaign),
            ),
          ),
        ),
        Divider(height: 1, color: context.appDivider),
        _tool(
          context,
          icon: Icons.description_outlined,
          iconColor: context.appTextSecondary,
          title: 'Documents',
          subtitle: 'Upload supporting documents',
          onTap: () => _unavailable(context, 'Document management'),
        ),
        Divider(height: 1, color: context.appDivider),
        _tool(
          context,
          icon: Icons.account_balance_wallet_outlined,
          iconColor: context.appTextSecondary,
          title: 'Request payout',
          subtitle: 'No balance available',
          onTap: () => _unavailable(context, 'Payout requests'),
        ),
      ],
    ),
  );

  Widget _card(BuildContext context, {required Widget child}) => Container(
    decoration: BoxDecoration(
      color: context.appSurface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: context.appBorder),
    ),
    child: ClipRRect(borderRadius: BorderRadius.circular(20), child: child),
  );

  Widget _tool(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.buttonMd.copyWith(
                    fontSize: 15,
                    color: context.appTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySm.copyWith(
                    fontSize: 12,
                    color: context.appTextMuted,
                  ),
                ),
              ],
            ),
          ),
          if (trailing case final Widget widget) widget,
          const SizedBox(width: 8),
          Icon(Icons.chevron_right_rounded, color: context.appTextMuted),
        ],
      ),
    ),
  );

  Widget _pill(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: AppColors.primary.withValues(alpha: .1),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Text(
      label,
      style: AppTextStyles.buttonMd.copyWith(
        fontSize: 13,
        color: AppColors.primary,
      ),
    ),
  );

  void _unavailable(BuildContext context, String label) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$label will be available after approval.')),
      );

  void _share(BuildContext context) => showAppShareSheet(
    context,
    ShareSheetData(
      title: campaign.title,
      subtitle: 'Campaign is currently under review',
      emoji: campaign.icon,
      link: 'https://helpfundus.app/c/${campaign.id}',
      iconGradient: LinearGradient(
        colors: campaign.gradientColorValues.map(Color.new).toList(),
      ),
    ),
  );
}
