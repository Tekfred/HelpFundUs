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
          Stack(
            clipBehavior: Clip.none,
            children: [
              const CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.primary,
                child: Text(
                  'JD',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                right: -2,
                bottom: -1,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: const Icon(Icons.add, size: 18, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Jane Doe', style: AppTextStyles.h2.copyWith(fontSize: 24)),
              Text(
                'jane@example.com',
                style: AppTextStyles.bodyMd.copyWith(fontSize: 15),
              ),
              const SizedBox(height: 4),
              Text(
                '✓ Verified',
                style: AppTextStyles.buttonMd.copyWith(
                  color: AppColors.primary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 30),
      Text(
        'VIEW AS',
        style: AppTextStyles.label.copyWith(
          color: const Color(0xFF9AA4B5),
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 9),
      Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 245, 246, 245),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            for (final role in ShellRole.values)
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.setRole(role),
                  child: AnimatedContainer(
                    duration: AppMotion.fast,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: controller.role == role
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: controller.role == role
                          ? Border.all(color: const Color(0xFFCDD5DE))
                          : null,
                      boxShadow: controller.role == role
                          ? const [
                              BoxShadow(
                                color: Color(0x12000000),
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      role == ShellRole.donor ? 'Donor' : 'Fundraiser',
                      style: AppTextStyles.buttonLg.copyWith(
                        fontSize: 15,
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
      const SizedBox(height: 28),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFE6F7ED),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(
        title,
        style: AppTextStyles.buttonMd.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodyMd.copyWith(
          fontSize: 14,
          color: const Color(0xFF6B7587),
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFF9AA4B5)),
    ),
  );
}
