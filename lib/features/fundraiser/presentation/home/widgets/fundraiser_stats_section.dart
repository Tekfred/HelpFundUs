import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';

class FundraiserStatsSection extends StatelessWidget {
  const FundraiserStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _card(context, '\$7,800', 'Total raised\nall time', primary: true),
        const SizedBox(width: 8),
        _card(context, '1', 'Active\nlive campaigns'),
        const SizedBox(width: 8),
        _card(context, '\$3,800', 'Balance\navailable'),
      ],
    );
  }

  Widget _card(
    BuildContext context,
    String value,
    String label, {
    bool primary = false,
  }) {
    return Expanded(
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: primary ? AppColors.primary : context.appSurface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              maxLines: 1,
              style: AppTextStyles.h3.copyWith(
                fontSize: 20,
                color: primary ? Colors.white : AppColors.primary,
              ),
            ),
            const Spacer(),
            Text(
              label,
              style: AppTextStyles.bodyMd.copyWith(
                fontSize: 11,
                color: primary ? Colors.white70 : context.appTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
