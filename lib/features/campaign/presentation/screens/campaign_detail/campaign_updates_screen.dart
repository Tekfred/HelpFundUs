import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/features/campaign/data/campaign_catalog.dart';
import 'package:helpfundus/features/campaign/presentation/screens/campaign_detail/widgets/campaign_update_card.dart';

class CampaignUpdatesScreen extends StatelessWidget {
  const CampaignUpdatesScreen({super.key, required this.campaign});
  final CampaignData campaign;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.appBackground,
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
        children: [
          Row(
            children: [
              Material(
                color: context.appSurface,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  customBorder: const CircleBorder(),
                  child: const SizedBox(
                    width: 52,
                    height: 52,
                    child: Icon(Icons.arrow_back_ios_new_rounded, size: 22),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Campaign Updates',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h2.copyWith(
                    fontSize: 22,
                    color: context.appTextPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 52),
            ],
          ),
          const SizedBox(height: 12),
          ...campaign.updates.map(
            (update) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CampaignUpdateCard(
                update: update,
                fundraiser: campaign.fundraiser,
                gradient: campaign.gradient,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
