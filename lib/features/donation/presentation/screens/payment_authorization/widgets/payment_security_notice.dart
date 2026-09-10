import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';

class PaymentSecurityNotice extends StatelessWidget {
  const PaymentSecurityNotice({
    super.key,
    required this.message,
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
  });

  final String message;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline_rounded, color: iconColor, size: 22),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            message,
            style: AppTextStyles.bodyMd.copyWith(
              fontSize: 14,
              height: 1.38,
              color: textColor,
            ),
          ),
        ),
      ],
    ),
  );
}
