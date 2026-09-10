import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';

class SecureHandoffIntro extends StatelessWidget {
  const SecureHandoffIntro({super.key, required this.paymentMethod});

  final String paymentMethod;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: 76,
        height: 76,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: .055),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.lock_outline_rounded,
          color: AppColors.primary,
          size: 37,
        ),
      ),
      const SizedBox(height: 18),
      Text(
        'Secure handoff to $paymentMethod',
        textAlign: TextAlign.center,
        style: AppTextStyles.h3.copyWith(fontSize: 20),
      ),
      const SizedBox(height: 9),
      Text(
        'You are about to be handed off to $paymentMethod’s secure payment interface. Do not close the app or refresh until you are returned here.',
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyMd.copyWith(fontSize: 15, height: 1.42),
      ),
    ],
  );
}
