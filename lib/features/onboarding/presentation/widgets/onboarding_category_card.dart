import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';

class OnboardingCategoryCard extends StatelessWidget {
  const OnboardingCategoryCard({
    super.key,
    required this.title,
    required this.campaignCount,
    required this.emoji,
    required this.color,
  });

  final String title;
  final String campaignCount;
  final String emoji;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: DecoratedBox(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Expanded(
              child: ColoredBox(
                color: color,
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 29)),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 9, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.buttonMd.copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      campaignCount,
                      style: AppTextStyles.bodySm.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
