import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/core/widgets/animated_progress_bar.dart';
import 'package:helpfundus/core/widgets/app_share_sheet.dart';
import 'package:helpfundus/core/widgets/app_error_prompt.dart';
import 'package:helpfundus/features/campaign/data/campaign_catalog.dart';
import 'package:helpfundus/features/campaign/presentation/screens/campaign_detail/campaign_detail_screen.dart';
import 'package:helpfundus/features/fundraiser/domain/entities/fundraiser_campaign.dart';
import 'package:helpfundus/features/fundraiser/presentation/performance/performance_screen.dart';

class CampaignManagementScreen extends StatelessWidget {
  const CampaignManagementScreen({super.key, required this.campaign});
  final FundraiserCampaign campaign;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.appBackground,
    body: Column(
      children: [
        SizedBox(
          height: 332,
          child: Stack(
            children: [
              _hero(context),
              Positioned(
                top: MediaQuery.paddingOf(context).top + 14,
                left: 16,
                right: 16,
                child: _heroActions(context),
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
                  fontSize: 21,
                  color: context.appTextPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _summary(context),
              const SizedBox(height: 24),
              Text(
                'Launch Checklist',
                style: AppTextStyles.buttonMd.copyWith(
                  fontSize: 16,
                  color: context.appTextPrimary,
                ),
              ),
              const SizedBox(height: 10),
              _launchChecklistCard(context),
              const SizedBox(height: 24),
              _managementHeading(context),
              const SizedBox(height: 10),
              _managementTools(context),
            ],
          ),
        ),
      ],
    ),
  );
  Widget _hero(BuildContext c) => Container(
    height: 332,
    padding: EdgeInsets.fromLTRB(16, MediaQuery.paddingOf(c).top + 14, 16, 16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: campaign.gradientColorValues.map(Color.new).toList(),
      ),
    ),
    child: Column(
      children: [
        const SizedBox(height: 46),
        const Spacer(),
        Text(campaign.icon, style: const TextStyle(fontSize: 64)),
        const Spacer(),
        Align(
          alignment: Alignment.center,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  '●  Active',
                  style: AppTextStyles.buttonMd.copyWith(
                    fontSize: 13,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Urban Greening Initiative',
                style: AppTextStyles.bodySm.copyWith(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: .9),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _heroActions(BuildContext context) => Row(
    children: [
      _round(
        Icons.arrow_back_ios_new_rounded,
        () => Navigator.of(context).pop(),
      ),
      const Spacer(),
      _round(Icons.share_outlined, () => _showShareSheet(context)),
      const SizedBox(width: 8),
      _round(
        Icons.open_in_new_rounded,
        () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const CampaignDetailScreen(
              campaign: CampaignCatalog.urbanTrees,
            ),
          ),
        ),
      ),
    ],
  );
  Widget _round(IconData i, VoidCallback tap) => Material(
    color: Colors.white.withValues(alpha: .25),
    shape: const CircleBorder(),
    child: InkWell(
      onTap: tap,
      customBorder: const CircleBorder(),
      child: SizedBox(
        width: 46,
        height: 46,
        child: Icon(i, color: Colors.white, size: 20),
      ),
    ),
  );

  void _showShareSheet(BuildContext context) => showAppShareSheet(
    context,
    ShareSheetData(
      title: campaign.title,
      subtitle:
          '${String.fromCharCode(36)}${campaign.amountRaised.toStringAsFixed(0)} raised · ${campaign.donorCount} donors',
      emoji: campaign.icon,
      link: 'https://helpfundus.app/c/${campaign.id}',
      iconGradient: LinearGradient(
        colors: campaign.gradientColorValues.map(Color.new).toList(),
      ),
    ),
  );
  Widget _summary(BuildContext c) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: c.appSurface,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      children: [
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
              'of \$${campaign.goal.toStringAsFixed(0)} goal',
              style: AppTextStyles.bodyMd.copyWith(
                fontSize: 13,
                color: c.appTextSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: AnimatedProgressBar(
            value: campaign.progress,
            color: AppColors.primary,
            backgroundColor: c.isDarkTheme
                ? AppColors.dividerDark
                : const Color(0xFFE3E5EA),
            minHeight: 7,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _metric(c, '${campaign.donorCount}', 'Donors'),
            _metric(c, '${(campaign.progress * 100).round()}%', 'Progress'),
            _metric(c, '${campaign.daysRemaining}', 'Days left'),
          ],
        ),
      ],
    ),
  );
  Widget _metric(BuildContext c, String value, String label) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTextStyles.h3.copyWith(
            fontSize: 16,
            color: c.appTextPrimary,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            fontSize: 11,
            color: c.appTextMuted,
          ),
        ),
      ],
    ),
  );
  Widget _launchChecklistCard(BuildContext context) => _managementCard(
    context,
    child: _managementTile(
      context,
      icon: Icons.check_circle_outline_rounded,
      iconColor: AppColors.primary,
      title: 'Campaign checklist',
      subtitle: 'Tap to view and manage setup tasks',
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          '3/5',
          style: AppTextStyles.buttonMd.copyWith(
            fontSize: 14,
            color: AppColors.primary,
          ),
        ),
      ),
      onTap: () => _checklist(context),
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
    ],
  );

  Widget _managementTools(BuildContext context) => _managementCard(
    context,
    child: Column(
      children: [
        _managementTile(
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
        _managementTile(
          context,
          icon: Icons.description_outlined,
          iconColor: context.appTextSecondary,
          title: 'Documents',
          subtitle: 'Upload supporting documents',
          onTap: () => showAppErrorOverlay(
            context,
            message: 'Document management will be available soon.',
          ),
        ),
        Divider(height: 1, color: context.appDivider),
        _managementTile(
          context,
          icon: Icons.account_balance_wallet_outlined,
          iconColor: context.appTextSecondary,
          title: 'Request payout',
          subtitle: 'No balance available',
          onTap: () => _comingSoon(context, 'Payout requests'),
        ),
      ],
    ),
  );

  Widget _managementCard(BuildContext context, {required Widget child}) =>
      Container(
        decoration: BoxDecoration(
          color: context.appSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.appBorder),
        ),
        child: ClipRRect(borderRadius: BorderRadius.circular(20), child: child),
      );

  Widget _managementTile(
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 22, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.buttonMd.copyWith(
                    fontSize: 16,
                    color: context.appTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySm.copyWith(
                    fontSize: 13,
                    color: context.appTextMuted,
                  ),
                ),
              ],
            ),
          ),
          if (trailing case final Widget trailingWidget) trailingWidget,
          const SizedBox(width: 8),
          Icon(Icons.chevron_right_rounded, color: context.appTextMuted),
        ],
      ),
    ),
  );

  void _comingSoon(BuildContext context, String label) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text('$label will be available soon.')));
  void _checklist(BuildContext c) => showModalBottomSheet<void>(
    context: c,
    backgroundColor: c.appSurfaceElevated,
    showDragHandle: true,
    builder: (s) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Campaign checklist · 3/5',
              style: AppTextStyles.h3.copyWith(
                fontSize: 18,
                color: s.appTextPrimary,
              ),
            ),
            const SizedBox(height: 10),
            ...[
              'Campaign story written',
              'Cover image / media uploaded',
              'Identity verification (KYC)',
              'Bank account linked',
              'Milestones added',
            ].asMap().entries.map(
              (e) => ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                leading: Icon(
                  e.key < 3 ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: e.key < 3 ? AppColors.primary : s.appTextMuted,
                ),
                title: Text(
                  e.value,
                  style: AppTextStyles.buttonMd.copyWith(
                    fontSize: 14,
                    color: e.key < 3 ? s.appTextPrimary : s.appTextMuted,
                  ),
                ),
                trailing: e.key < 3
                    ? null
                    : Text(
                        'Fix →',
                        style: AppTextStyles.buttonMd.copyWith(
                          fontSize: 13,
                          color: AppColors.primary,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
