import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';

class FundraiserHeader extends StatelessWidget {
  const FundraiserHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fundraiser Hub',
                style: AppTextStyles.h1.copyWith(fontSize: 27),
              ),
              const SizedBox(height: 4),
              Text(
                'Welcome back, Jane 👋',
                style: AppTextStyles.bodyLg.copyWith(fontSize: 16),
              ),
            ],
          ),
        ),
        CircleAvatar(
          radius: 26,
          backgroundColor: AppColors.primary,
          child: Text(
            'JD',
            style: AppTextStyles.h3.copyWith(color: Colors.white, fontSize: 17),
          ),
        ),
      ],
    );
  }
}
