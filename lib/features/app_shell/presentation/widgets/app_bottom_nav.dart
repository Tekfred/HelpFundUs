import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../state/app_shell_controller.dart';
import 'notification_badge.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.controller,
    this.isGuest = false,
    this.onSignIn,
  });
  final AppShellController controller;
  final bool isGuest;
  final VoidCallback? onSignIn;
  static const _d = [
    Icons.home_rounded,
    Icons.explore_outlined,
    Icons.bar_chart_rounded,
    Icons.notifications_none_rounded,
    Icons.person_outline_rounded,
  ];
  static const _f = [
    Icons.home_rounded,
    Icons.grid_view_outlined,
    Icons.bar_chart_rounded,
    Icons.notifications_none_rounded,
    Icons.person_outline_rounded,
  ];
  @override
  Widget build(BuildContext context) {
    final icons = controller.role == ShellRole.donor ? _d : _f;
    final guestIcons = [_d[0], _d[1], _d[4]];
    final labels = isGuest
        ? const ['Home', 'Explore', 'Sign In']
        : controller.tabLabels;
    final displayedIcons = isGuest ? guestIcons : icons;
    return SafeArea(
      top: false,
      child: Container(
        height: 84,
        decoration: BoxDecoration(
          color: context.appNavigation,
          border: Border(top: BorderSide(color: context.appBorder)),
        ),
        child: Row(
          children: List.generate(
            labels.length,
            (i) => _item(context, i, labels[i], displayedIcons[i]),
          ),
        ),
      ),
    );
  }

  Widget _item(BuildContext context, int i, String label, IconData icon) {
    final signIn = isGuest && i == 2;
    final s = signIn || i == controller.tabIndex;
    final n = isGuest
        ? 0
        : i == 2
        ? controller.unreadActivity
        : i == 3
        ? controller.unreadInbox
        : 0;
    return Expanded(
      child: InkWell(
        onTap: signIn ? onSignIn : () => controller.setTab(i),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                    duration: AppMotion.normal,
                    curve: Curves.elasticOut,
                    width: 48,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: s
                          ? AppColors.primary.withValues(alpha: .12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Icon(
                      icon,
                      size: 24,
                      color: s ? AppColors.primary : context.appTextMuted,
                    ),
                  ),
                  if (n > 0)
                    Positioned(
                      right: -4,
                      top: -5,
                      child: NotificationBadge(count: n),
                    ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: s ? AppColors.primary : context.appTextMuted,
                  fontWeight: s ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
