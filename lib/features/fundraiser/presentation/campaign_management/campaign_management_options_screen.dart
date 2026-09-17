import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';
import 'package:helpfundus/features/fundraiser/domain/entities/fundraiser_campaign.dart';
import 'package:helpfundus/features/fundraiser/presentation/campaign_management/widgets/campaign_management_header.dart';
import 'package:helpfundus/features/fundraiser/presentation/campaign_management/widgets/campaign_operations_section.dart';
import 'package:helpfundus/features/fundraiser/presentation/campaign_management/widgets/campaign_overview_return_button.dart';
import 'package:helpfundus/features/fundraiser/presentation/performance/performance_screen.dart';

/// Coordinates navigation and future API state for campaign-management tools.
/// Visual sections live in focused widgets so API failures can be handled here
/// without making the screen difficult to inspect.
class CampaignManagementOptionsScreen extends StatelessWidget {
  const CampaignManagementOptionsScreen({super.key, required this.campaign});

  final FundraiserCampaign campaign;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.appBackground,
    body: SafeArea(
      child: Column(
        children: [
          CampaignManagementHeader(
            campaign: campaign,
            onBack: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 30, 16, 20),
              children: [
                CampaignOperationsSection(
                  onPerformance: () => _openPerformance(context),
                  onDocuments: () => _showUnavailable(
                    context,
                    'Document management is coming soon.',
                  ),
                  onRequestPayout: () => _showUnavailable(
                    context,
                    'There is no available payout yet.',
                  ),
                ),
              ],
            ),
          ),
          CampaignOverviewReturnButton(
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    ),
  );

  void _openPerformance(BuildContext context) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => PerformanceScreen(campaign: campaign),
    ),
  );

  void _showUnavailable(BuildContext context, String message) =>
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
}
