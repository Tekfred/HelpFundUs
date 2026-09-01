import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

class GoogleAuthButton extends StatelessWidget {
  const GoogleAuthButton({super.key, required this.label, this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.borderStrong, width: 1.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Simple 'G' glyph in Google's brand colors, no network asset needed.
            const _GoogleGlyph(),
            const SizedBox(width: AppSpacing.sm),
            Text(label, style: AppTextStyles.buttonLg.copyWith(color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}

class _GoogleGlyph extends StatelessWidget {
  const _GoogleGlyph();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'G',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        foreground: null,
        color: Color(0xFF4285F4),
      ),
    );
  }
}

/// Divider row with an "or" label in the middle, e.g. between password
/// sign-in and Google sign-in.
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Text('or', style: AppTextStyles.bodyMd),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }
}
