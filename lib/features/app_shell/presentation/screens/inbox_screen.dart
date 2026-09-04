import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});
  @override
  Widget build(BuildContext context) {
    const threads = [
      (
        'HF',
        'HelpFundUs Team',
        'Your campaign has been approved and is ...',
        '10 min',
        AppColors.primary,
      ),
      (
        'MT',
        'Marcus Thompson',
        'Thank you for running this campaign — I don...',
        '2h',
        Color(0xFF8255F3),
      ),
      (
        '📣',
        'Campaign Update',
        "Leah's campaign just reached 58% of its ...",
        'Yesterday',
        Color(0xFFF4F6FA),
      ),
      (
        '💡',
        'HelpFundUs Tips',
        '3 proven strategies to increase your dona...',
        '3 days',
        Color(0xFFF4F6FA),
      ),
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 30, 0, 112),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Text('Inbox', style: AppTextStyles.h1),
              const Spacer(),
              Text(
                '3 unread',
                style: AppTextStyles.buttonMd.copyWith(color: AppColors.coral),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...threads.map(
          (t) => ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            leading: Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: t.$5,
                  child: Text(
                    t.$1,
                    style: AppTextStyles.h3.copyWith(
                      color:
                          t.$5 == AppColors.primary ||
                              t.$5 == const Color(0xFF8255F3)
                          ? Colors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                const Positioned(
                  right: -1,
                  top: -1,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            title: Text(t.$2, style: AppTextStyles.h3),
            subtitle: Text(
              t.$3,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyLg,
            ),
            trailing: Text(t.$4, style: AppTextStyles.bodySm),
          ),
        ),
      ],
    );
  }
}
