import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';

/// Stand-in for the real authenticated app (campaign feed, dashboard,
/// profile, etc.). Every "you're done with auth/onboarding" callback in
/// the app currently lands here so the flow has somewhere concrete to go
/// and the dev screen-nav has a real "App Shell" destination — swap the
/// body out for the actual home/feed screen once it's built.
class AppShellScreen extends StatefulWidget {
  const AppShellScreen({super.key, required this.onSignOut});
  final VoidCallback onSignOut;

  @override
  State<AppShellScreen> createState() => _AppShellScreenState();
}

class _AppShellScreenState extends State<AppShellScreen> {
  int _tab = 0;

  static const _tabs = [
    (Icons.home_rounded, 'Home'),
    (Icons.explore_outlined, 'Discover'),
    (Icons.add_circle_outline, 'Create'),
    (Icons.person_outline, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    child: const Icon(Icons.favorite, color: AppColors.surface, size: 20),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text('HelpFundUs', style: AppTextStyles.buttonLg.copyWith(color: AppColors.textPrimary)),
                  const Spacer(),
                  IconButton(onPressed: widget.onSignOut, icon: const Icon(Icons.logout, color: AppColors.textSecondary)),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome, color: AppColors.primary, size: 40),
                      const SizedBox(height: AppSpacing.md),
                      Text("You're in!", style: AppTextStyles.h1),
                      const SizedBox(height: AppSpacing.sm),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                        child: Text(
                          'This is a placeholder for the real app shell — the campaign '
                          'feed, dashboard, and profile screens go here next.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMd,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text('Currently viewing: ${_tabs[_tab].$2}', style: AppTextStyles.bodySm),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.borderStrong),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 6))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_tabs.length, (i) {
              final selected = i == _tab;
              final (icon, label) = _tabs[i];
              return GestureDetector(
                onTap: () => setState(() => _tab = i),
                child: AnimatedContainer(
                  duration: AppMotion.fast,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary.withOpacity(0.12) : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 20, color: selected ? AppColors.primary : AppColors.textMuted),
                      const SizedBox(height: 2),
                      Text(label, style: AppTextStyles.caption.copyWith(color: selected ? AppColors.primary : AppColors.textMuted)),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
