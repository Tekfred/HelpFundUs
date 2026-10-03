import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/core/theme/theme_mode_notifier.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';
import 'package:helpfundus/features/account/data/models/user_profile.dart';

class FundraiserHeader extends ConsumerWidget {
  const FundraiserHeader({super.key, this.profile});

  final UserProfile? profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fundraiser Hub',
                style: AppTextStyles.h1.copyWith(
                  fontSize: 24,
                  color: context.appTextPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Welcome back, ${profile?.firstName.trim().isNotEmpty == true ? profile!.firstName.trim() : 'Jane'} 👋',
                style: AppTextStyles.bodyLg.copyWith(
                  fontSize: 14,
                  color: context.appTextSecondary,
                ),
              ),
            ],
          ),
        ),
        Tooltip(
          message: isDarkMode ? 'Switch to light mode' : 'Switch to dark mode',
          child: IconButton(
            onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
            icon: Icon(
              isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_outlined,
              color: AppColors.primary,
            ),
          ),
        ),
        CircleAvatar(
          radius: 26,
          backgroundColor: AppColors.primary,
          child: Text(
            profile?.initials.isNotEmpty == true ? profile!.initials : 'JD',
            style: AppTextStyles.h3.copyWith(color: Colors.white, fontSize: 17),
          ),
        ),
      ],
    );
  }
}
