import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/pill_badge.dart';

/// The tilted campaign preview card on the Welcome screen: gradient
/// header, verified badge, supporter count, animated progress bar,
/// and two floating celebration chips.
class CampaignCardIllustration extends StatelessWidget {
  const CampaignCardIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Two duplicate cards peeking out behind the main card, for depth —
          // matches the reference's layered-card look.
          Positioned(
            left: -18,
            child: Transform.rotate(
              angle: -0.09,
              child: _shadowCard(color: const Color(0xFF7B5CF0).withValues(alpha: 0.55)),
            ),
          ),
          Positioned(
            right: -14,
            child: Transform.rotate(
              angle: 0.06,
              child: _shadowCard(color: AppColors.primaryLight.withValues(alpha: 0.7)),
            ),
          ),
          _MainCard(),
          Positioned(
            top: -14,
            right: 8,
            child: FloatingNotificationChip(
              label: '+\$500 🎉',
              background: AppColors.surface,
            ),
          ),
          Positioned(
            bottom: -10,
            left: 4,
            child: FloatingNotificationChip(
              label: '💚 Just donated!',
              delay: const Duration(milliseconds: 500),
              background: AppColors.surface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _shadowCard({required Color color}) {
    return Container(
      width: 250,
      height: 168,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1),
      ),
    );
  }
}

class _MainCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderStrong, width: 1.2),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.10), blurRadius: 24, offset: const Offset(0, 12))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 88,
            decoration: const BoxDecoration(gradient: AppColors.cardGradient),
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Stack(
              children: [
                const PillBadge(
                  label: 'Verified',
                  leading: Icon(Icons.check_circle, size: 12, color: AppColors.primary),
                ),
                Positioned(
                  right: 0,
                  child: PillBadge(
                    label: '248 supporters',
                    leading: const Text('❤️', style: TextStyle(fontSize: 11)),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _AvatarStack(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Help rebuild our community center', style: AppTextStyles.buttonMd),
                const SizedBox(height: AppSpacing.sm),
                _AnimatedProgressBar(progress: 0.72),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$14,400 raised', style: AppTextStyles.bodySm.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                    Text('72%', style: AppTextStyles.bodySm),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarStack extends StatelessWidget {
  static const _colors = [AppColors.coral, AppColors.teal, AppColors.gold];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: Stack(
        children: List.generate(_colors.length, (i) {
          return Positioned(
            left: i * 16.0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _colors[i],
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.surface, width: 2),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _AnimatedProgressBar extends StatelessWidget {
  const _AnimatedProgressBar({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress),
      duration: const Duration(milliseconds: 1100),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 6,
            backgroundColor: AppColors.border,
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          ),
        );
      },
    );
  }
}
