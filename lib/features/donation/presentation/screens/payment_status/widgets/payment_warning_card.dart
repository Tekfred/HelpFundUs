import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';

class PaymentWarningCard extends StatelessWidget {
  const PaymentWarningCard({
    super.key,
    required this.title,
    required this.message,
    required this.backgroundColor,
    required this.color,
  });

  final String title;
  final String message;
  final Color backgroundColor;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline_rounded, color: color, size: 22),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.buttonMd.copyWith(color: color)),
              const SizedBox(height: 4),
              Text(
                message,
                style: AppTextStyles.bodyMd.copyWith(
                  fontSize: 14,
                  height: 1.38,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
