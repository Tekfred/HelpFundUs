import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_dimens.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';
import 'package:helpfundus/features/app_shell/state/app_shell_controller.dart';
import 'package:helpfundus/features/account/data/models/user_profile.dart';
import 'package:helpfundus/core/theme/theme_mode_notifier.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({
    super.key,
    required this.controller,
    required this.onSignOut,
    this.profile,
  });
  final AppShellController controller;
  final VoidCallback onSignOut;
  final UserProfile? profile;
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(24, 30, 24, 112),
    children: [
      Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.primary,
                child: Text(
                  profile?.initials.isNotEmpty == true
                      ? profile!.initials
                      : 'JD',
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
              Text(
                profile?.displayName.isNotEmpty == true
                    ? profile!.displayName
                    : 'Jane Doe',
                style: AppTextStyles.h2.copyWith(
                  fontSize: 24,
                  color: context.appTextPrimary,
                ),
              ),
              if (profile == null || profile!.email.isNotEmpty)
                Text(
                  profile?.email.isNotEmpty == true
                      ? profile!.email
                      : 'jane@example.com',
                  style: AppTextStyles.bodyMd.copyWith(
                    fontSize: 15,
                    color: context.appTextSecondary,
                  ),
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
          color: context.appTextMuted,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 9),
      Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: context.appInput,
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
                          ? context.appSurface
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: controller.role == role
                          ? Border.all(color: context.appBorderStrong)
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
                            ? context.appTextPrimary
                            : context.appTextMuted,
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
          color: context.appSurface,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
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
              'Personalisation',
              'Campaign updates and appearance',
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
          style: AppTextStyles.bodySm.copyWith(color: context.appTextMuted),
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
          : Border(bottom: BorderSide(color: context.appDivider)),
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
          color: context.appTextPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodyMd.copyWith(
          fontSize: 14,
          color: context.appTextSecondary,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: context.appTextMuted),
      onTap: title == 'Personalisation'
          ? () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const _PersonalisationSheet(),
            )
          : null,
    ),
  );
}

class _PersonalisationSheet extends ConsumerStatefulWidget {
  const _PersonalisationSheet();

  @override
  ConsumerState<_PersonalisationSheet> createState() =>
      _PersonalisationSheetState();
}

class _PersonalisationSheetState extends ConsumerState<_PersonalisationSheet> {
  bool _campaignUpdates = true;

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(themeModeProvider);
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
        decoration: BoxDecoration(
          color: context.appSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 42, height: 4, color: context.appBorder)),
            const SizedBox(height: 20),
            Text('Personalisation', style: AppTextStyles.h2.copyWith(color: context.appTextPrimary)),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Campaign updates', style: TextStyle(color: context.appTextPrimary)),
              subtitle: Text('Get notified about campaigns you follow', style: TextStyle(color: context.appTextSecondary)),
              value: _campaignUpdates,
              onChanged: (value) => setState(() => _campaignUpdates = value),
            ),
            const SizedBox(height: 12),
            Text('Appearance', style: AppTextStyles.buttonMd.copyWith(color: context.appTextPrimary)),
            for (final option in [
              (ThemeMode.system, 'System'),
              (ThemeMode.light, 'Light'),
              (ThemeMode.dark, 'Dark'),
            ])
              RadioListTile<ThemeMode>(
                contentPadding: EdgeInsets.zero,
                title: Text(option.$2, style: TextStyle(color: context.appTextPrimary)),
                value: option.$1,
                groupValue: mode,
                onChanged: (value) {
                  if (value != null) ref.read(themeModeProvider.notifier).setThemeMode(value);
                },
              ),
          ],
        ),
      ),
    );
  }
}
