import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';

class CampaignOverviewReturnButton extends StatelessWidget {
  const CampaignOverviewReturnButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
    child: SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: context.appTextPrimary,
          foregroundColor: context.appSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          'Return to Campaign Overview',
          style: AppTextStyles.buttonMd.copyWith(
            fontSize: 14,
            color: context.appSurface,
          ),
        ),
      ),
    ),
  );
}
