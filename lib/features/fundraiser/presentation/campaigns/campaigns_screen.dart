import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/features/fundraiser/data/fundraiser_campaign_catalog.dart';
import 'package:helpfundus/features/fundraiser/domain/entities/fundraiser_campaign.dart';
import 'package:helpfundus/features/fundraiser/presentation/campaign_management/campaign_management_screen.dart';
import 'package:helpfundus/features/fundraiser/presentation/campaigns/widgets/campaign_filter_chips.dart';
import 'package:helpfundus/features/fundraiser/presentation/campaigns/widgets/campaign_search_field.dart';
import 'package:helpfundus/features/fundraiser/presentation/campaigns/widgets/campaigns_header.dart';
import 'package:helpfundus/features/fundraiser/presentation/campaigns/widgets/fundraiser_campaign_card.dart';

class CampaignsScreen extends StatefulWidget {
  const CampaignsScreen({super.key});
  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen> {
  String _filter = 'All', _query = '';
  Map<String, int> get _counts => {
    'All': FundraiserCampaignCatalog.campaigns.length,
    'Active': 1,
    'Draft': 1,
    'In review': 2,
    'Suspended': 1,
    'Closed': 2,
  };
  List<FundraiserCampaign> get _visible => FundraiserCampaignCatalog.campaigns
      .where(
        (c) =>
            (_filter == 'All' || c.status.label == _filter) &&
            c.title.toLowerCase().contains(_query.toLowerCase()),
      )
      .toList();
  void _manage(FundraiserCampaign campaign) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => CampaignManagementScreen(campaign: campaign),
    ),
  );
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 26, 20, 112),
        children: [
          CampaignsHeader(onCreate: () {}),
          const SizedBox(height: 18),
          CampaignSearchField(onChanged: (q) => setState(() => _query = q)),
          const SizedBox(height: 14),
          CampaignFilterChips(
            selected: _filter,
            counts: _counts,
            onSelected: (v) => setState(() => _filter = v),
          ),
          const SizedBox(height: 18),
          ..._visible.map(
            (c) =>
                FundraiserCampaignCard(campaign: c, onManage: () => _manage(c)),
          ),
        ],
      ),
    ),
  );
}
