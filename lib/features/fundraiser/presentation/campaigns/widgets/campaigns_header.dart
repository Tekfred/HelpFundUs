import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';

class CampaignsHeader extends StatelessWidget {
  const CampaignsHeader({super.key, required this.onCreate});
  final VoidCallback onCreate;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(
        'My Campaigns',
        style: AppTextStyles.h1.copyWith(
          fontSize: 26,
          color: context.appTextPrimary,
        ),
      ),
      const Spacer(),
      SizedBox(
        height: 48,
        child: FilledButton.icon(
          onPressed: onCreate,
          icon: const Icon(Icons.add, size: 20),
          label: Text(
            'Create',
            style: AppTextStyles.buttonMd.copyWith(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ],
  );
}
