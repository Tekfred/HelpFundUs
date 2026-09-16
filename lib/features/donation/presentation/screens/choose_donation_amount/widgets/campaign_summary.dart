import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';

class CampaignSummary extends StatelessWidget {
  const CampaignSummary({
    super.key,
    required this.title,
    required this.emoji,
    this.expanded = false,
  });

  final String title;
  final String emoji;
  final bool expanded;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(expanded ? 14 : 12),
    decoration: BoxDecoration(
      color: context.appSurface,
      borderRadius: BorderRadius.circular(22),
    ),
    child: Row(
      children: [
        Container(
          width: expanded ? 66 : 60,
          height: expanded ? 66 : 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF8557F7), Color(0xFF3C7DF4)],
            ),
            borderRadius: BorderRadius.circular(expanded ? 19 : 17),
          ),
          child: Text(emoji, style: TextStyle(fontSize: expanded ? 33 : 30)),
        ),
        SizedBox(width: expanded ? 14 : 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.h3.copyWith(fontSize: expanded ? 16 : 15),
              ),
              SizedBox(height: expanded ? 10 : 8),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: LinearProgressIndicator(
                        value: .72,
                        minHeight: expanded ? 7 : 6,
                        color: AppColors.primary,
                        backgroundColor: context.isDarkTheme
                            ? AppColors.borderDark
                            : const Color(0xFFE3E5EA),
                      ),
                    ),
                  ),
                  SizedBox(width: expanded ? 12 : 10),
                  Text(
                    '72%',
                    style: AppTextStyles.label.copyWith(
                      fontSize: expanded ? 14 : 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: expanded ? 10 : 8),
        Container(
          width: expanded ? 37 : 34,
          height: expanded ? 28 : 25,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: .10),
            border: Border.all(color: AppColors.primary.withValues(alpha: .55)),
            borderRadius: BorderRadius.circular(99),
          ),
          child: Icon(
            Icons.verified_rounded,
            size: expanded ? 16 : 14,
            color: AppColors.primary,
          ),
        ),
      ],
    ),
  );
}
