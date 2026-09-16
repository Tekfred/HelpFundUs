import 'package:flutter/material.dart';
import '../../../../core/animation/reveal_on_enter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/pill_badge.dart';
import 'onboarding_category_card.dart';

class _Category {
  const _Category(
    this.title,
    this.count,
    this.emoji,
    this.color, {
    this.verified = false,
  });

  final String title;
  final String count;
  final String emoji;
  final Color color;
  final bool verified;
}

const _categories = [
  _Category('Medical', '2.3K campaigns', '🏥', Color(0xFFF77A7A)),
  _Category(
    'Education',
    '1.8K campaigns',
    '📚',
    Color(0xFF719DF0),
    verified: true,
  ),
  _Category('Environment', '987 campaigns', '🌱', Color(0xFF75CF8A)),
  _Category('Community', '3.1K campaigns', '❤️', Color(0xFFFCC06D)),
];

final kCategoryGridRevealCount = 1 + _categories.length;

class CategoryGridIllustration extends StatelessWidget {
  const CategoryGridIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.clamp(280.0, 344.0);
        return SizedBox(
          width: width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const RevealOnEnter(
                index: 1,
                child: PillBadge(
                  label: '100+ categories',
                  leading: Icon(
                    Icons.public,
                    size: 14,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.35,
                ),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      RevealOnEnter(
                        index: index + 2,
                        child: OnboardingCategoryCard(
                          title: category.title,
                          campaignCount: category.count,
                          emoji: category.emoji,
                          color: category.color,
                        ),
                      ),
                      if (category.verified)
                        Positioned(
                          top: 8,
                          right: -8,
                          child: RevealOnEnter(
                            index: 2 + _categories.length + 1,
                            offsetY: 6,
                            child: const PillBadge(
                              label: 'All verified',
                              dense: true,
                              background: AppColors.primary,
                              foreground: AppColors.surface,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
