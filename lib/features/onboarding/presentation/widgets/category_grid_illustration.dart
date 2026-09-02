import 'package:flutter/material.dart';
import '../../../../core/animation/reveal_on_enter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/pill_badge.dart';

class _Category {
  const _Category(
    this.title,
    this.count,
    this.icon,
    this.color, {
    this.verified = false,
  });
  final String title;
  final String count;
  final IconData icon;
  final Color color;
  final bool verified;
}

const _categories = [
  _Category(
    'Medical',
    '2.3K campaigns',
    Icons.favorite_rounded,
    AppColors.coral,
  ),
  _Category(
    'Education',
    '1.8K campaigns',
    Icons.school_rounded,
    Color(0xFF4F8EF7),
    verified: true,
  ),
  _Category(
    'Environment',
    '987 campaigns',
    Icons.eco_rounded,
    AppColors.primaryLight,
  ),
  _Category(
    'Community',
    '3.1K campaigns',
    Icons.groups_rounded,
    AppColors.gold,
  ),
];

/// How many staggered items this illustration reveals — the pill badge
/// plus one per card — so [OnboardingSlideScaffold] can queue the dot
/// indicator/headline/body right after this cascade finishes.
final kCategoryGridRevealCount = 1 + _categories.length;

class CategoryGridIllustration extends StatelessWidget {
  const CategoryGridIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const RevealOnEnter(
          index: 1,
          child: PillBadge(
            label: '100+ categories',
            leading: Icon(Icons.public, size: 14, color: AppColors.primary),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width: 280,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
              childAspectRatio: 1.05,
            ),
            itemBuilder: (context, i) {
              // Reading order: Medical, Education, Environment, Community —
              // index 2 onward, right after the pill badge at index 1.
              return RevealOnEnter(
                index: 2 + i,
                child: _CategoryCard(category: _categories[i]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category});
  final _Category category;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: category.color.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(category.icon, color: category.color, size: 20),
              ),
              const Spacer(),
              Text(category.title, style: AppTextStyles.buttonMd),
              Text(category.count, style: AppTextStyles.bodySm),
            ],
          ),
          if (category.verified)
            // Arrives last, as its own small flourish after every card has
            // already settled — matches the reference recording, where the
            // "All verified" tag is the very last thing to fade in.
            Positioned(
              top: 0,
              right: 0,
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
      ),
    );
  }
}
