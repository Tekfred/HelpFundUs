import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_colors.dart';

class JourneyCard extends StatelessWidget {
  const JourneyCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.fast,
        curve: Curves.easeOut,
        constraints: const BoxConstraints(minHeight: 104),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? context.appBackground : context.appSurface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: selected ? AppColors.primary : context.appBorderStrong,
            width: selected ? 2 : 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.appBackground,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 28)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.h3.copyWith(
                      fontSize: 18,
                      color: context.appTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMd.copyWith(
                      fontSize: 14,
                      color: context.appTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            AnimatedScale(
              duration: AppMotion.fast,
              curve: Curves.elasticOut,
              scale: selected ? 1 : 0,
              child: const CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.check, size: 14, color: AppColors.surface),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
