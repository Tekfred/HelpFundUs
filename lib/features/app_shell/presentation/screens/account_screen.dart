import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../state/app_shell_controller.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({
    super.key,
    required this.controller,
    required this.onSignOut,
  });
  final AppShellController controller;
  final VoidCallback onSignOut;
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(24, 30, 24, 112),
    children: [
      Row(
        children: [
          const CircleAvatar(
            radius: 46,
            backgroundColor: AppColors.primary,
            child: Text(
              'JD',
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Jane Doe', style: AppTextStyles.h1),
              Text('jane@example.com', style: AppTextStyles.bodyLg),
              const SizedBox(height: 6),
              Text(
                '✓ Verified',
                style: AppTextStyles.buttonMd.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 38),
      Text(
        'VIEW AS',
        style: AppTextStyles.label.copyWith(
          color: const Color(0xFF9AA4B5),
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xF7FFFFFF),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            for (final role in ShellRole.values)
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.setRole(role),
                  child: AnimatedContainer(
                    duration: AppMotion.fast,
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: controller.role == role
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(17),
                      border: controller.role == role
                          ? Border.all(color: const Color(0xFFD1D6DE))
                          : null,
                    ),
                    child: Text(
                      role == ShellRole.donor ? 'Donor' : 'Fundraiser',
                      style: AppTextStyles.buttonLg.copyWith(
                        color: controller.role == role
                            ? AppColors.textPrimary
                            : const Color(0xFF9AA4B5),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: 38),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          children: const [
            _Setting(
              Icons.person_outline,
              'Edit profile',
              'Photo, bio, display name',
            ),
            _Setting(
              Icons.shield_outlined,
              'Security & privacy',
              'Password, 2FA, sessions',
            ),
            _Setting(
              Icons.notifications_none,
              'Notifications',
              'Push, email, digest',
            ),
            _Setting(
              Icons.receipt_long_outlined,
              'Tax receipts',
              'Download donation receipts',
            ),
            _Setting(
              Icons.trending_up,
              'Impact report',
              'Your giving history & stats',
            ),
            _Setting(
              Icons.help_outline,
              'Help & support',
              'FAQs, contact, report an issue',
              last: true,
            ),
          ],
        ),
      ),
      const SizedBox(height: 32),
      OutlinedButton(
        onPressed: onSignOut,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.coral,
          side: const BorderSide(color: Color(0xFFFFB9B9)),
        ),
        child: const Text('Sign Out'),
      ),
      const SizedBox(height: 18),
      Center(
        child: Text(
          'HelpFundUs v2.4.1 · Terms · Privacy',
          style: AppTextStyles.bodySm,
        ),
      ),
    ],
  );
}

class _Setting extends StatelessWidget {
  const _Setting(this.icon, this.title, this.subtitle, {this.last = false});
  final IconData icon;
  final String title, subtitle;
  final bool last;
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      border: last
          ? null
          : const Border(bottom: BorderSide(color: Color(0xFFE0E4E8))),
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFE6F7ED),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(title, style: AppTextStyles.h3),
      subtitle: Text(subtitle, style: AppTextStyles.bodyMd),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFF9AA4B5)),
    ),
  );
}
