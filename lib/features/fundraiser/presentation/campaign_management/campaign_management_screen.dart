import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/features/fundraiser/domain/entities/fundraiser_campaign.dart';

class CampaignManagementScreen extends StatelessWidget {
  const CampaignManagementScreen({super.key, required this.campaign});

  final FundraiserCampaign campaign;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBackground,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _hero(context)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    campaign.title,
                    style: AppTextStyles.h2.copyWith(
                      fontSize: 24,
                      color: context.appTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _summary(context),
                  const SizedBox(height: 22),
                  _heading(context, 'Campaign checklist'),
                  const SizedBox(height: 12),
                  _group(context, const [
                    'Campaign story written',
                    'Cover image / media uploaded',
                    'Identity verification (KYC)',
                    'Bank account linked',
                    'Milestones added',
                  ], checks: true),
                  const SizedBox(height: 22),
                  _heading(context, 'Campaign management'),
                  const SizedBox(height: 12),
                  _group(context, const [
                    'Performance analytics|Donations, trends, reach',
                    'Edit campaign|Story, media, goal, dates',
                    'Milestones|2 milestones',
                    'Documents|Upload supporting documents',
                    'Request payout|No balance available',
                  ]),
                  const SizedBox(height: 22),
                  Text(
                    'DANGER ZONE',
                    style: AppTextStyles.label.copyWith(
                      fontSize: 15,
                      color: context.appTextMuted,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _group(context, const [
                    'Pause campaign',
                    'Close campaign permanently',
                  ], danger: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _hero(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top + 14,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: campaign.gradientColorValues
              .map((value) => Color(value))
              .toList(),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _round(
                Icons.arrow_back_ios_new_rounded,
                () => Navigator.of(context).pop(),
              ),
              const Spacer(),
              _round(Icons.share_outlined, () {}),
              const SizedBox(width: 10),
              _round(Icons.open_in_new_rounded, () {}),
            ],
          ),
          const Spacer(),
          Text(campaign.icon, style: const TextStyle(fontSize: 70)),
          const Spacer(),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                'Active',
                style: AppTextStyles.buttonMd.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _round(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white.withValues(alpha: .25),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 52,
          height: 52,
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }

  Widget _heading(BuildContext context, String label) => Text(
    label,
    style: AppTextStyles.h3.copyWith(
      fontSize: 20,
      color: context.appTextPrimary,
    ),
  );

  Widget _summary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '\$${campaign.amountRaised.toStringAsFixed(0)}',
                style: AppTextStyles.h2.copyWith(
                  fontSize: 28,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              Text(
                'of \$${campaign.goal.toStringAsFixed(0)} goal',
                style: AppTextStyles.bodyMd.copyWith(
                  color: context.appTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: campaign.progress,
              minHeight: 8,
              color: AppColors.primary,
              backgroundColor: context.isDarkTheme
                  ? AppColors.dividerDark
                  : const Color(0xFFE3E5EA),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _metric(context, '${campaign.donorCount}', 'Donors'),
              _metric(
                context,
                '${(campaign.progress * 100).round()}%',
                'Progress',
              ),
              _metric(context, '${campaign.daysRemaining}', 'Days left'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metric(BuildContext context, String value, String label) {
    return Expanded(
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
          Text(
            label,
            style: AppTextStyles.caption.copyWith(color: context.appTextMuted),
          ),
        ],
      ),
    );
  }

  Widget _group(
    BuildContext context,
    List<String> rows, {
    bool checks = false,
    bool danger = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: List.generate(rows.length, (index) {
          final parts = rows[index].split('|');
          final color = danger
              ? (index == 1 ? AppColors.danger : const Color(0xFFE17A00))
              : context.appTextPrimary;
          return Column(
            children: [
              ListTile(
                leading: checks
                    ? const CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Icon(Icons.check, color: Colors.white, size: 18),
                      )
                    : Icon(Icons.chevron_right_rounded, color: color),
                title: Text(
                  parts.first,
                  style: AppTextStyles.buttonMd.copyWith(
                    fontSize: 16,
                    color: color,
                  ),
                ),
                subtitle: parts.length > 1
                    ? Text(
                        parts[1],
                        style: AppTextStyles.bodySm.copyWith(
                          color: context.appTextMuted,
                        ),
                      )
                    : null,
                trailing: checks
                    ? null
                    : Icon(Icons.chevron_right_rounded, color: color),
              ),
              if (index < rows.length - 1)
                Divider(height: 1, color: context.appDivider),
            ],
          );
        }),
      ),
    );
  }
}
