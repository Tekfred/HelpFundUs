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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2F2),
                  border: Border.all(color: const Color(0xFFFFB9B9)),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '3 unread',
                  style: AppTextStyles.buttonMd.copyWith(
                    color: AppColors.coral,
                    fontWeight: FontWeight.w700,
                  ),
                ),
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
            title: Text(
              t.$2,
              style: AppTextStyles.buttonMd.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              t.$3,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMd.copyWith(
                fontSize: 15,
                color: const Color(0xFF6B7587),
              ),
            ),
            trailing: Text(
              t.$4,
              style: AppTextStyles.caption.copyWith(
                fontSize: 13,
                color: const Color(0xFF9AA4B5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
