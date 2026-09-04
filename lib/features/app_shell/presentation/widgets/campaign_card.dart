import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';

class CampaignCard extends StatelessWidget {
  const CampaignCard({
    super.key,
    required this.title,
    required this.category,
    required this.amount,
    required this.progress,
    required this.location,
    this.icon = '🏘️',
    this.gradient = AppColors.cardGradient,
  });
  final String title, category, amount, location, icon;
  final double progress;
  final Gradient gradient;
  @override
  Widget build(BuildContext context) => Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(28),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 190,
          decoration: BoxDecoration(gradient: gradient),
          child: Stack(
            children: [
              Center(child: Text(icon, style: const TextStyle(fontSize: 64))),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xB9273C8F),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    category,
                    style: AppTextStyles.buttonMd.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 20, 28, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.h3),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: Color(0xFF9AA4B5),
                    size: 19,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    location,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: const Color(0xFF9AA4B5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progress),
                duration: const Duration(milliseconds: 850),
                builder: (context, value, _) => ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: value,
                    minHeight: 10,
                    backgroundColor: const Color(0xFFE1E4E9),
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    amount,
                    style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                  ),
                  const Spacer(),
                  Text(
                    '${(progress * 100).round()}% · 248 donors',
                    style: AppTextStyles.bodyMd.copyWith(
                      color: const Color(0xFF9AA4B5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
