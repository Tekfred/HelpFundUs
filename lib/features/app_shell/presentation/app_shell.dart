import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../state/app_shell_controller.dart';
import '../state/online_status.dart';
import 'screens/account_screen.dart';
import 'screens/activity_screen.dart';
import 'screens/campaigns_screen.dart';
import 'screens/donor_home_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/fundraiser_home_screen.dart';
import 'screens/inbox_screen.dart';
import 'widgets/app_bottom_nav.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.onSignOut, this.controller});
  final VoidCallback onSignOut;
  final AppShellController? controller;
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late final AppShellController _controller;
  StreamSubscription<bool>? _onlineSubscription;
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? AppShellController();
    _controller.addListener(_refresh);
    _onlineSubscription = onlineStatusChanges().listen(_controller.setOnline);
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _onlineSubscription?.cancel();
    _controller.removeListener(_refresh);
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  Widget get _body => switch ((_controller.role, _controller.tabIndex)) {
    (_, 0) =>
      _controller.role == ShellRole.donor
          ? DonorHomeScreen(onExplore: () => _controller.setTab(1))
          : const FundraiserHomeScreen(),
    (ShellRole.donor, 1) => const ExploreScreen(),
    (ShellRole.fundraiser, 1) => const CampaignsScreen(),
    (_, 2) => const ActivityScreen(),
    (_, 3) => const InboxScreen(),
    (_, _) => AccountScreen(
      controller: _controller,
      onSignOut: widget.onSignOut,
    ),
  };
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: Stack(
      children: [
        SafeArea(
          bottom: false,
          child: AnimatedSwitcher(
            duration: AppMotion.fast,
            child: KeyedSubtree(
              key: ValueKey('${_controller.role}-${_controller.tabIndex}'),
              child: _body,
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AnimatedSlide(
            duration: AppMotion.normal,
            offset: _controller.online ? const Offset(0, -1) : Offset.zero,
            child: SafeArea(
              bottom: false,
              child: Container(
                color: AppColors.warning,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.wifi_off, color: Colors.white),
                    const SizedBox(width: 10),
                    Text(
                      'You’re offline — changes will sync when connected.',
                      style: AppTextStyles.buttonMd.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_loading) const _LoadingOverlay(),
      ],
    ),
    bottomNavigationBar: AppBottomNav(controller: _controller),
  );
}

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();
  @override
  Widget build(BuildContext context) => ColoredBox(
    color: AppColors.background,
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite, color: Colors.white, size: 35),
          ),
          const SizedBox(height: 18),
          Text('HelpFundUs', style: AppTextStyles.brand),
          const SizedBox(height: 18),
          const SizedBox(
            width: 30,
            child: LinearProgressIndicator(
              color: AppColors.primary,
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    ),
  );
}
