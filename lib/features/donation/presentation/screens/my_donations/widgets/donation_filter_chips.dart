import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';

class DonationFilterChips extends StatelessWidget {
  const DonationFilterChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: ['All', 'Completed', 'Pending', 'Failed'].map((filter) {
        final isSelected = filter == selected;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: InkWell(
            onTap: () => onSelected(filter),
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : context.appSurface,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : context.appBorderStrong,
                ),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                filter,
                style: AppTextStyles.buttonMd.copyWith(
                  fontSize: 13,
                  color: isSelected ? Colors.white : context.appTextSecondary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}
