import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';

class CampaignOperationsSection extends StatelessWidget {
  const CampaignOperationsSection({
    super.key,
    required this.onPerformance,
    required this.onDocuments,
    required this.onRequestPayout,
  });

  final VoidCallback onPerformance;
  final VoidCallback onDocuments;
  final VoidCallback onRequestPayout;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          Text(
            'CAMPAIGN OPERATIONS',
            style: AppTextStyles.buttonMd.copyWith(
              fontSize: 12,
              letterSpacing: .4,
              color: context.appTextMuted,
            ),
          ),
          const Spacer(),
          Text(
            '3 core tools',
            style: AppTextStyles.caption.copyWith(
              fontSize: 11,
              color: context.appTextMuted,
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Container(
        decoration: BoxDecoration(
          color: context.appSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.appBorder),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            children: [
              CampaignOperationTile(
                icon: Icons.bar_chart_rounded,
                iconColor: AppColors.primary,
                iconBackground: AppColors.primary.withValues(alpha: .1),
                title: 'Performance analytics',
                subtitle: 'Donations, trends, reach & audience breakdown',
                trailing: const _StatusPill(
                  label: '+18.4%',
                  color: AppColors.primary,
                ),
                onTap: onPerformance,
              ),
              Divider(height: 1, color: context.appDivider),
              CampaignOperationTile(
                icon: Icons.image_outlined,
                iconColor: const Color(0xFF2B6CF6),
                iconBackground: const Color(0xFFECF2FF),
                title: 'Documents',
                subtitle: 'Upload and verify supporting documents',
                trailing: const _TileValue(value: '2 files'),
                onTap: onDocuments,
              ),
              Divider(height: 1, color: context.appDivider),
              CampaignOperationTile(
                icon: Icons.credit_card_rounded,
                iconColor: AppColors.warning,
                iconBackground: AppColors.warning.withValues(alpha: .12),
                title: 'Request payout',
                subtitle: 'No pending balance available',
                trailing: _TileValue(value: '${String.fromCharCode(36)}0.00'),
                onTap: onRequestPayout,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class CampaignOperationTile extends StatelessWidget {
  const CampaignOperationTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 19, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.buttonMd.copyWith(
                    fontSize: 14,
                    color: context.appTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 11,
                    color: context.appTextMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          trailing,
          const SizedBox(width: 4),
          Icon(Icons.chevron_right_rounded, color: context.appTextMuted),
        ],
      ),
    ),
  );
}

class _TileValue extends StatelessWidget {
  const _TileValue({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) => Text(
    value,
    style: AppTextStyles.caption.copyWith(
      fontSize: 11,
      color: context.appTextMuted,
    ),
  );
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .1),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Text(
      label,
      style: AppTextStyles.buttonMd.copyWith(fontSize: 10, color: color),
    ),
  );
}
