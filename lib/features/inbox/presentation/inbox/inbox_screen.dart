import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';

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
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 112),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                'Inbox',
                style: AppTextStyles.h2.copyWith(
                  fontSize: 25,
                  color: context.appTextPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2F2),
                  border: Border.all(color: const Color(0xFFFFB9B9)),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '3 unread',
                  style: AppTextStyles.buttonMd.copyWith(
                    fontSize: 13,
                    color: AppColors.coral,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...threads.map(
          (t) => _InboxRow(
            initials: t.$1,
            sender: t.$2,
            preview: t.$3,
            timestamp: t.$4,
            avatarColor: t.$5,
          ),
        ),
      ],
    );
  }
}

class _InboxRow extends StatelessWidget {
  const _InboxRow({
    required this.initials,
    required this.sender,
    required this.preview,
    required this.timestamp,
    required this.avatarColor,
  });

  final String initials;
  final String sender;
  final String preview;
  final String timestamp;
  final Color avatarColor;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: context.appDivider)),
    ),
    child: Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: avatarColor,
              child: Text(
                initials,
                style: AppTextStyles.buttonMd.copyWith(
                  fontSize: 16,
                  color:
                      avatarColor == AppColors.primary ||
                          avatarColor == const Color(0xFF8255F3)
                      ? Colors.white
                      : context.appTextPrimary,
                ),
              ),
            ),
            Positioned(
              right: -1,
              top: -1,
              child: CircleAvatar(
                radius: 7,
                backgroundColor: context.appSurface,
                child: CircleAvatar(
                  radius: 4.5,
                  backgroundColor: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sender,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.buttonMd.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: context.appTextPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                preview,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMd.copyWith(
                  fontSize: 14,
                  color: context.appTextSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          timestamp,
          style: AppTextStyles.caption.copyWith(
            fontSize: 12,
            color: context.appTextMuted,
          ),
        ),
      ],
    ),
  );
}
