import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../state/app_shell_controller.dart';
import 'notification_badge.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.controller});
  final AppShellController controller;
  static const _donor = [
    Icons.home_rounded,
    Icons.explore_outlined,
    Icons.bar_chart_rounded,
    Icons.notifications_none_rounded,
    Icons.person_outline_rounded,
  ];
  static const _fundraiser = [
    Icons.home_rounded,
    Icons.campaign_outlined,
    Icons.bar_chart_rounded,
    Icons.notifications_none_rounded,
    Icons.person_outline_rounded,
  ];
  @override
  Widget build(BuildContext context) {
    final labels = controller.tabLabels;
    final icons = controller.role == ShellRole.donor ? _donor : _fundraiser;
    return SafeArea(
      top: false,
      child: Container(
        height: 84,
        color: Colors.white,
        child: LayoutBuilder(
          builder: (context, box) {
            return Stack(
              children: [
                AnimatedAlign(
                  duration: AppMotion.normal,
                  curve: Curves.elasticOut,
                  alignment: Alignment(-1 + controller.tabIndex * .5, -.38),
                  child: Container(
                    width: box.maxWidth / 5 - 28,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                ),
                Row(
                  children: List.generate(
                    5,
                    (index) => _item(index, labels[index], icons[index]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _item(int index, String label, IconData icon) {
    final selected = index == controller.tabIndex;
    final count = index == 2
        ? controller.unreadActivity
        : index == 3
        ? controller.unreadInbox
        : 0;
    return Expanded(
      child: InkWell(
        onTap: () => controller.setTab(index),
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    icon,
                    size: 27,
                    color: selected
                        ? AppColors.primary
                        : const Color(0xFF9AA4B5),
                  ),
                  if (count > 0)
                    Positioned(
                      right: -10,
                      top: -8,
                      child: NotificationBadge(count: count),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: selected ? AppColors.primary : const Color(0xFF9AA4B5),
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
