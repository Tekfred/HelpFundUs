import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/features/fundraiser/data/fundraiser_campaign_catalog.dart';
import 'package:helpfundus/features/fundraiser/domain/entities/fundraiser_campaign.dart';
import 'package:helpfundus/features/fundraiser/presentation/campaign_management/campaign_management_screen.dart';
import 'package:helpfundus/features/fundraiser/presentation/campaign_management/in_review_campaign_details_screen.dart';
import 'package:helpfundus/features/fundraiser/presentation/campaign_management/suspended_campaign_details_screen.dart';
import 'package:helpfundus/features/fundraiser/presentation/campaigns/widgets/fundraiser_campaign_card.dart';
import 'package:helpfundus/features/fundraiser/presentation/home/widgets/fundraiser_header.dart';
import 'package:helpfundus/features/fundraiser/presentation/home/widgets/fundraiser_quick_actions.dart';
import 'package:helpfundus/features/fundraiser/presentation/home/widgets/fundraiser_stats_section.dart';
import 'package:helpfundus/features/fundraiser/presentation/home/widgets/fundraiser_status_card.dart';
import 'package:helpfundus/features/fundraiser/presentation/home/widgets/payout_card.dart';
import 'package:helpfundus/features/fundraiser/presentation/home/widgets/pending_campaign_card.dart';
import 'package:helpfundus/features/fundraiser/presentation/home/widgets/recent_donations_section.dart';
import 'package:helpfundus/features/fundraiser/presentation/home/widgets/verification_badge.dart';
import 'package:helpfundus/features/fundraiser/presentation/performance/performance_screen.dart';

class FundraiserHomeScreen extends StatelessWidget {
  const FundraiserHomeScreen({super.key});

  List<FundraiserCampaign> get _campaigns =>
      FundraiserCampaignCatalog.campaigns;

  FundraiserCampaign get _active => _campaigns.firstWhere(
    (campaign) => campaign.status == FundraiserCampaignStatus.active,
  );

  FundraiserCampaign get _suspended => _campaigns.firstWhere(
    (campaign) => campaign.status == FundraiserCampaignStatus.suspended,
  );

  void _openCampaigns(BuildContext context) => _manage(context, _active);

  void _manage(BuildContext context, FundraiserCampaign campaign) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CampaignManagementScreen(campaign: campaign),
      ),
    );
  }

  void _openPerformance(BuildContext context, FundraiserCampaign campaign) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PerformanceScreen(campaign: campaign),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reviewCampaigns = _campaigns
        .where(
          (campaign) => campaign.status == FundraiserCampaignStatus.inReview,
        )
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 112),
      children: [
        const FundraiserHeader(),
        const SizedBox(height: 14),
        FundraiserStatusCard(
          icon: Icons.shield_outlined,
          leadingText: '2 campaigns',
          message: 'under review — our team will respond within 24 hours.',
          backgroundColor: Color(0xFFEAF2FF),
          accentColor: Color(0xFF2563EB),
        ),
        const SizedBox(height: 12),
        FundraiserStatusCard(
          icon: Icons.error_outline_rounded,
          leadingText: '1 campaign suspended',
          message: '— action required.',
          backgroundColor: Color(0xFFFFF2F2),
          accentColor: AppColors.danger,
          action: 'View',
          onAction: () => _openSuspendedCampaign(context),
        ),
        const SizedBox(height: 10),
        const VerificationBadge(),
        const SizedBox(height: 12),
        const FundraiserStatsSection(),
        const SizedBox(height: 14),
        FundraiserCampaignCard(
          campaign: _active,
          dashboardVariant: true,
          onManage: () => _manage(context, _active),
          onPerformance: () => _openPerformance(context, _active),
        ),
        const SizedBox(height: 14),
        const PayoutCard(),
        const SizedBox(height: 14),
        FundraiserQuickActions(
          onNewCampaign: () {},
          onAllCampaigns: () => _openCampaigns(context),
        ),
        const SizedBox(height: 22),
        Text('Pending review', style: AppTextStyles.h3.copyWith(fontSize: 18)),
        for (final campaign in reviewCampaigns)
          PendingCampaignCard(
            campaign: campaign,
            onTap: () => _openInReviewCampaign(context, campaign),
          ),
        const SizedBox(height: 18),
        const RecentDonationsSection(),
      ],
    );
  }

  void _openSuspendedCampaign(BuildContext context) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => SuspendedCampaignDetailsScreen(campaign: _suspended),
        ),
      );

  void _openInReviewCampaign(
    BuildContext context,
    FundraiserCampaign campaign,
  ) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => InReviewCampaignDetailsScreen(campaign: campaign),
    ),
  );
}
