import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/core/widgets/animated_progress_bar.dart';
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
            _CampaignPerformanceOverview(campaign: campaign),
            const SizedBox(height: 16),
            _PerformanceMetrics(campaign: campaign),
            const SizedBox(height: 22),
            Text(
              '14-day donation trend',
              style: AppTextStyles.buttonMd.copyWith(
                fontSize: 16,
                color: context.appTextPrimary,
              ),
            ),
            const SizedBox(height: 10),
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

class _CampaignPerformanceOverview extends StatelessWidget {
  const _CampaignPerformanceOverview({required this.campaign});

  final FundraiserCampaign campaign;

  @override
  Widget build(BuildContext context) {
    final raised = _formatAmount(campaign.amountRaised);
    final goal = _formatAmount(campaign.goal);
    final progress = (campaign.progress * 100).round();

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF18BA62), Color(0xFF13A7E8)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL RAISED',
            style: AppTextStyles.buttonMd.copyWith(
              fontSize: 13,
              letterSpacing: .5,
              color: Colors.white.withValues(alpha: .78),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${String.fromCharCode(36)}$raised',
            style: AppTextStyles.h1.copyWith(
              fontSize: 42,
              height: 1,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 26),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: AnimatedProgressBar(
              value: campaign.progress,
              minHeight: 12,
              color: Colors.white,
              backgroundColor: Colors.white.withValues(alpha: .35),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$progress% of ${String.fromCharCode(36)}$goal goal',
                style: AppTextStyles.bodySm.copyWith(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: .86),
                ),
              ),
              Text(
                '${campaign.daysRemaining} days left',
                style: AppTextStyles.bodySm.copyWith(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: .86),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PerformanceMetrics extends StatelessWidget {
  const _PerformanceMetrics({required this.campaign});

  final FundraiserCampaign campaign;

  @override
  Widget build(BuildContext context) {
    final averageGift = campaign.donorCount == 0
        ? 0.0
        : campaign.amountRaised / campaign.donorCount;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.34,
      children: [
        _MetricCard(
          icon: Icons.group_outlined,
          iconColor: const Color(0xFF875BFF),
          iconBackground: const Color(0xFFF2EDFF),
          value: '${campaign.donorCount}',
          label: 'Total donors',
        ),
        _MetricCard(
          icon: Icons.favorite_border_rounded,
          iconColor: AppColors.primary,
          iconBackground: const Color(0xFFE9F8EE),
          value: '${String.fromCharCode(36)}${averageGift.toStringAsFixed(2)}',
          label: 'Average gift',
        ),
        const _MetricCard(
          icon: Icons.calendar_month_outlined,
          iconColor: Color(0xFF2B6CF6),
          iconBackground: Color(0xFFECF2FF),
          value: 'Aug 1, 2026',
          label: 'Campaign start',
        ),
        _MetricCard(
          icon: Icons.account_balance_wallet_outlined,
          iconColor: Color(0xFF875BFF),
          iconBackground: Color(0xFFF2EDFF),
          value: '${String.fromCharCode(36)}0',
          label: 'Total paid out',
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: context.isDarkTheme ? .1 : .04,
            ),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 23, color: iconColor),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.h3.copyWith(
                  fontSize: 22,
                  color: context.appTextPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: AppTextStyles.bodySm.copyWith(
                  fontSize: 13,
                  color: context.appTextMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _formatAmount(double amount) {
  final whole = amount.round().toString();
  return whole.replaceAllMapped(RegExp(r'(?=(\d{3})+(?!\d))'), (_) => ',');
}
