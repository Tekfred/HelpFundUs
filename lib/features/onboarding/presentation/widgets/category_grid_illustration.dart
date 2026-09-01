import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/pill_badge.dart';

class _Category {
  const _Category(this.title, this.count, this.icon, this.color, {this.verified = false});
  final String title;
  final String count;
  final IconData icon;
  final Color color;
  final bool verified;
}

const _categories = [
  _Category('Medical', '2.3K campaigns', Icons.favorite_rounded, AppColors.coral),
  _Category('Education', '1.8K campaigns', Icons.school_rounded, Color(0xFF4F8EF7), verified: true),
  _Category('Environment', '987 campaigns', Icons.eco_rounded, AppColors.primaryLight),
  _Category('Community', '3.1K campaigns', Icons.groups_rounded, AppColors.gold),
];

class CategoryGridIllustration extends StatelessWidget {
  const CategoryGridIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const PillBadge(label: '100+ categories', leading: Icon(Icons.public, size: 14, color: AppColors.primary)),
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
              final c = _categories[i];
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutBack,
                // Stagger each card's entrance by its grid index.
                builder: (context, raw, child) {
                  final delayed = ((raw * 4) - i * 0.6).clamp(0.0, 1.0);
                  return Transform.scale(scale: 0.7 + 0.3 * delayed, child: Opacity(opacity: delayed, child: child));
                },
                child: _CategoryCard(category: c),
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 6))],
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
                decoration: BoxDecoration(color: category.color.withOpacity(0.18), shape: BoxShape.circle),
                child: Icon(category.icon, color: category.color, size: 20),
              ),
              const Spacer(),
              Text(category.title, style: AppTextStyles.buttonMd),
              Text(category.count, style: AppTextStyles.bodySm),
            ],
          ),
          if (category.verified)
            const Positioned(
              top: 0,
              right: 0,
              child: PillBadge(
                label: 'All verified',
                dense: true,
                background: AppColors.primary,
                foreground: AppColors.surface,
              ),
            ),
        ],
      ),
    );
  }
}
