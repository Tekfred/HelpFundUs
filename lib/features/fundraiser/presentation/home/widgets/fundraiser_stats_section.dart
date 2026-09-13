import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';

class FundraiserStatsSection extends StatelessWidget {
  const FundraiserStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _card('\$7,800', 'Total raised\nall time', primary: true),
        const SizedBox(width: 8),
        _card('1', 'Active\nlive campaigns'),
        const SizedBox(width: 8),
        _card('\$3,800', 'Balance\navailable'),
      ],
    );
  }

  Widget _card(String value, String label, {bool primary = false}) {
    return Expanded(
      child: Container(
        height: 116,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: primary ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              maxLines: 1,
              style: AppTextStyles.h3.copyWith(
                fontSize: 22,
                color: primary ? Colors.white : AppColors.primary,
              ),
            ),
            const Spacer(),
            Text(
              label,
              style: AppTextStyles.bodyMd.copyWith(
                fontSize: 12,
                color: primary ? Colors.white70 : const Color(0xFF9AA4B5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
