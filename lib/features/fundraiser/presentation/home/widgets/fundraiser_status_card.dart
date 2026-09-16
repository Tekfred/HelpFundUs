import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';

class FundraiserStatusCard extends StatelessWidget {
  const FundraiserStatusCard({
    super.key,
    required this.icon,
    required this.leadingText,
    required this.message,
    required this.backgroundColor,
    required this.accentColor,
    this.action,
  });

  final IconData icon;
  final String leadingText;
  final String message;
  final Color backgroundColor;
  final Color accentColor;
  final String? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 82),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: context.isDarkTheme
            ? accentColor.withValues(alpha: .13)
            : backgroundColor,
        border: Border.all(color: accentColor.withValues(alpha: .28)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: accentColor, size: 25),
          const SizedBox(width: 14),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: leadingText,
                    style: AppTextStyles.buttonMd.copyWith(
                      fontSize: 14,
                      color: context.appTextPrimary,
                    ),
                  ),
                  TextSpan(
                    text: ' $message',
                    style: AppTextStyles.bodyMd.copyWith(
                      fontSize: 14,
                      color: context.appTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: 8),
            Text(
              action!,
              style: AppTextStyles.buttonMd.copyWith(color: AppColors.primary),
            ),
          ],
        ],
      ),
    );
  }
}
