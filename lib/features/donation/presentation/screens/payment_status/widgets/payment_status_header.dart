import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';

class PaymentStatusHeader extends StatelessWidget {
  const PaymentStatusHeader({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    this.showProgress = false,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final bool showProgress;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: 72,
        height: 72,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: .10),
          shape: BoxShape.circle,
        ),
        child: showProgress
            ? SizedBox(
                width: 31,
                height: 31,
                child: CircularProgressIndicator(
                  color: iconColor,
                  strokeWidth: 3,
                ),
              )
            : Icon(icon, color: iconColor, size: 36),
      ),
      const SizedBox(height: 18),
      Text(title, textAlign: TextAlign.center, style: AppTextStyles.h3),
      const SizedBox(height: 8),
      Text(
        message,
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyMd.copyWith(fontSize: 16, height: 1.42),
      ),
    ],
  );
}
