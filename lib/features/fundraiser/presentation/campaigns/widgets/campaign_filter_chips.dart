import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';

class CampaignFilterChips extends StatelessWidget {
  const CampaignFilterChips({
    super.key,
    required this.selected,
    required this.counts,
    required this.onSelected,
  });
  final String selected;
  final Map<String, int> counts;
  final ValueChanged<String> onSelected;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: counts.entries.map((entry) {
        final active = selected == entry.key;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: InkWell(
            onTap: () => onSelected(entry.key),
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: active ? AppColors.primary : context.appSurface,
                border: Border.all(
                  color: active ? AppColors.primary : context.appBorderStrong,
                ),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${entry.key}  ${entry.value}',
                style: AppTextStyles.buttonMd.copyWith(
                  fontSize: 13,
                  color: active ? Colors.white : context.appTextSecondary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}
