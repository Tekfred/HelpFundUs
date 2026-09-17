import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/core/widgets/animated_progress_bar.dart';
import 'package:helpfundus/core/widgets/app_share_sheet.dart';
import 'package:helpfundus/features/fundraiser/domain/entities/fundraiser_campaign.dart';

/// Read-only campaign overview used for suspended fundraisers.
class SuspendedCampaignDetailsScreen extends StatelessWidget {
  const SuspendedCampaignDetailsScreen({super.key, required this.campaign});

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
                  fontSize: 22,
                  color: context.appTextPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _suspensionNotice(context),
              const SizedBox(height: 20),
              _summary(context),
              const SizedBox(height: 26),
              Text(
                'Campaign checklist',
                style: AppTextStyles.buttonMd.copyWith(
                  fontSize: 17,
                  color: context.appTextPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _checklistCard(context),
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
              'Suspended',
              style: AppTextStyles.buttonMd.copyWith(
                fontSize: 14,
                color: AppColors.danger,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _actions(BuildContext context) => Row(
    children: [
      _roundAction(
        context,
        Icons.arrow_back_ios_new_rounded,
        () => Navigator.of(context).pop(),
      ),
      const Spacer(),
      _roundAction(context, Icons.share_outlined, () => _share(context)),
      const SizedBox(width: 8),
      _roundAction(
        context,
        Icons.open_in_new_rounded,
        () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'This campaign is unavailable while it is suspended.',
            ),
          ),
        ),
      ),
    ],
  );

  Widget _roundAction(
    BuildContext context,
    IconData icon,
    VoidCallback onTap,
  ) => Material(
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

  Widget _suspensionNotice(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.danger.withValues(
        alpha: context.isDarkTheme ? .14 : .07,
      ),
      border: Border.all(color: AppColors.danger.withValues(alpha: .32)),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.error_outline_rounded,
          size: 23,
          color: AppColors.danger,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Campaign suspended',
                style: AppTextStyles.buttonMd.copyWith(
                  fontSize: 17,
                  color: AppColors.danger,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                campaign.suspendedReason ??
                    'Your campaign is pending verification.',
                style: AppTextStyles.bodyMd.copyWith(
                  fontSize: 14,
                  height: 1.45,
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
    padding: const EdgeInsets.all(16),
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
                fontSize: 28,
                color: AppColors.primary,
              ),
            ),
            const Spacer(),
            Text(
              'of ${String.fromCharCode(36)}${campaign.goal.toStringAsFixed(0)} goal',
              style: AppTextStyles.bodyMd.copyWith(
                fontSize: 14,
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

  Widget _checklistCard(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: context.appSurface,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: context.appBorder),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Column(
        children: [
          _checklistItem(context, 'Campaign story written', complete: true),
          _divider(context),
          _checklistItem(
            context,
            'Cover image / media uploaded',
            complete: true,
          ),
          _divider(context),
          _checklistItem(
            context,
            'Identity verification (KYC)',
            complete: true,
          ),
          _divider(context),
          _checklistItem(context, 'Bank account linked', complete: true),
          _divider(context),
          _checklistItem(context, 'Milestones added', complete: false),
        ],
      ),
    ),
  );

  Widget _divider(BuildContext context) =>
      Divider(height: 1, indent: 16, endIndent: 16, color: context.appDivider);

  Widget _checklistItem(
    BuildContext context,
    String label, {
    required bool complete,
  }) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    child: Row(
      children: [
        Icon(
          complete ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
          size: 28,
          color: complete ? AppColors.primary : context.appTextMuted,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.buttonMd.copyWith(
              fontSize: 16,
              color: complete ? context.appTextPrimary : context.appTextMuted,
            ),
          ),
        ),
        if (!complete)
          Text(
            'Fix →',
            style: AppTextStyles.buttonMd.copyWith(
              fontSize: 14,
              color: AppColors.primary,
            ),
          ),
      ],
    ),
  );

  void _share(BuildContext context) => showAppShareSheet(
    context,
    ShareSheetData(
      title: campaign.title,
      subtitle: 'Campaign is currently suspended',
      emoji: campaign.icon,
      link: 'https://helpfundus.app/c/${campaign.id}',
      iconGradient: LinearGradient(
        colors: campaign.gradientColorValues.map(Color.new).toList(),
      ),
    ),
  );
}
