import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/features/fundraiser/domain/entities/fundraiser_campaign.dart';
import 'package:helpfundus/features/fundraiser/presentation/performance/widgets/performance_chart_card.dart';
import 'package:helpfundus/features/fundraiser/presentation/performance/widgets/payout_summary_card.dart';
import 'package:helpfundus/features/fundraiser/presentation/performance/widgets/performance_recent_donations.dart';

class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({super.key, required this.campaign});

  final FundraiserCampaign campaign;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: [
            _header(context),
            const SizedBox(height: 16),
            PerformanceChartCard(campaign: campaign),
            const SizedBox(height: 18),
            Text(
              'Payout summary',
              style: AppTextStyles.buttonMd.copyWith(
                fontSize: 15,
                color: context.appTextPrimary,
              ),
            ),
            const SizedBox(height: 10),
            PayoutSummaryCard(totalRaised: campaign.amountRaised),
            const SizedBox(height: 18),
            Text(
              'Recent donations',
              style: AppTextStyles.buttonMd.copyWith(
                fontSize: 15,
                color: context.appTextPrimary,
              ),
            ),
            const SizedBox(height: 10),
            const PerformanceRecentDonations(),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Material(
              color: context.appSurface,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                customBorder: const CircleBorder(),
                child: const SizedBox(
                  width: 42,
                  height: 42,
                  child: Icon(Icons.arrow_back_ios_new_rounded, size: 19),
                ),
              ),
            ),
          ),
          Text(
            'Performance',
            style: AppTextStyles.h3.copyWith(
              fontSize: 18,
              color: context.appTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
