import 'dart:async';
import 'package:flutter/material.dart';
import 'package:helpfundus/core/scroll/helpfundus_scroll_behavior.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../state/app_shell_controller.dart';
import '../state/online_status.dart';
import 'package:helpfundus/features/account/presentation/account/account_screen.dart';
import 'package:helpfundus/features/activity/presentation/activity/activity_screen.dart';
import 'package:helpfundus/features/campaign/presentation/screens/donor_home/donor_home_screen.dart';
import 'package:helpfundus/features/campaign/presentation/screens/explore/explore_screen.dart';
import 'package:helpfundus/features/fundraiser/presentation/campaigns/campaigns_screen.dart';
import 'package:helpfundus/features/fundraiser/presentation/home/fundraiser_home_screen.dart';
import 'package:helpfundus/features/inbox/presentation/inbox/inbox_screen.dart';
import 'widgets/app_bottom_nav.dart';
import 'widgets/login_gate.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.onSignOut,
    this.controller,
    this.initialUri,
    this.isGuest = false,
    this.onGuestSignIn,
    this.onGuestCreateAccount,
  });
  final VoidCallback onSignOut;
  final AppShellController? controller;
  final Uri? initialUri;
  final bool isGuest;
  final VoidCallback? onGuestSignIn;
  final VoidCallback? onGuestCreateAccount;
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late final AppShellController _controller;
  StreamSubscription<bool>? _onlineSubscription;
  late bool _loading;
  @override
  void initState() {
    super.initState();
    _loading = !widget.isGuest;
    _controller = widget.controller ?? AppShellController();
    if (widget.initialUri != null) {
      _controller.handleDeepLink(widget.initialUri!);
    }
    _controller.addListener(_refresh);
    _onlineSubscription = onlineStatusChanges().listen(_controller.setOnline);
    if (_loading) {
      Future<void>.delayed(const Duration(milliseconds: 900), () {
        if (mounted) setState(() => _loading = false);
      });
    }
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(covariant AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    final uri = widget.initialUri;
    if (uri != null && uri != oldWidget.initialUri) {
      _controller.handleDeepLink(uri);
    }
  }

  @override
  void dispose() {
    _onlineSubscription?.cancel();
    _controller.removeListener(_refresh);
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  void _showGuestGate(LoginGatePurpose purpose) {
    showLoginGate(
      context,
      purpose: purpose,
      onSignIn: widget.onGuestSignIn ?? widget.onSignOut,
      onCreateAccount: widget.onGuestCreateAccount ?? widget.onSignOut,
    );
  }

  Widget get _body {
    if (widget.isGuest) {
      return switch (_controller.tabIndex) {
        0 => DonorHomeScreen(
          onExplore: () => _controller.setTab(1),
          onStartFundraiser: () => _showGuestGate(LoginGatePurpose.campaign),
          onDonate: () => _showGuestGate(LoginGatePurpose.donate),
        ),
        1 => ExploreScreen(
          onGuestDonate: () => _showGuestGate(LoginGatePurpose.donate),
        ),
        _ => DonorHomeScreen(
          onExplore: () => _controller.setTab(1),
          onStartFundraiser: () => _showGuestGate(LoginGatePurpose.campaign),
          onDonate: () => _showGuestGate(LoginGatePurpose.donate),
        ),
      };
    }
    return switch ((_controller.role, _controller.tabIndex)) {
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
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: Stack(
      children: [
        ScrollConfiguration(
          behavior: const _ShellScrollBehavior(),
          child: SafeArea(
            bottom: false,
            child: AnimatedSwitcher(
              duration: AppMotion.fast,
              child: KeyedSubtree(
                key: ValueKey('${_controller.role}-${_controller.tabIndex}'),
                child: _body,
              ),
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
                    Expanded(
                      child: Text(
                        'You’re offline — changes will sync when connected.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.buttonMd.copyWith(
                          color: Colors.white,
                        ),
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
    bottomNavigationBar: AppBottomNav(
      controller: _controller,
      isGuest: widget.isGuest,
      onSignIn: widget.onGuestSignIn,
    ),
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

class _ShellScrollBehavior extends HelpFundUsScrollBehavior {
  const _ShellScrollBehavior();

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => Scrollbar(
    controller: details.controller,
    interactive: false,
    thickness: 3,
    radius: const Radius.circular(99),
    child: child,
  );
}
