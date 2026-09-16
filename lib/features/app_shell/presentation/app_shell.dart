import 'dart:async';
import 'package:flutter/material.dart';
import 'package:helpfundus/core/scroll/helpfundus_scroll_behavior.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme_colors.dart';
import '../../../core/widgets/app_shimmer.dart';
import '../../../core/widgets/brand_logo.dart';
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
      Future<void>.delayed(const Duration(milliseconds: 1400), () {
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
    backgroundColor: context.appBackground,
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
    bottomNavigationBar: _loading
        ? null
        : AppBottomNav(
            controller: _controller,
            isGuest: widget.isGuest,
            onSignIn: widget.onGuestSignIn,
          ),
  );
}

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.appBackground,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            children: [
              SizedBox(height: constraints.maxHeight * .23),
              const BrandLogo(size: 134),
              const SizedBox(height: 4),
              const _LoadingDots(),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: AppShimmer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _SkeletonBlock(height: 12, widthFactor: 1),
                      SizedBox(height: 16),
                      _SkeletonBlock(height: 12, widthFactor: .7),
                      SizedBox(height: 44),
                      _SkeletonBlock(height: 120, widthFactor: 1, radius: 24),
                      SizedBox(height: 16),
                      _SkeletonBlock(height: 120, widthFactor: 1, radius: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({
    required this.height,
    required this.widthFactor,
    this.radius = 99,
  });

  final double height;
  final double widthFactor;
  final double radius;

  @override
  Widget build(BuildContext context) => FractionallySizedBox(
    widthFactor: widthFactor,
    child: Container(
      height: height,
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
  );
}

class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1050),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          final value = (_controller.value - (index * .18)) % 1;
          final opacity = .35 + ((1 - ((value - .5).abs() * 2)) * .65);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Opacity(
              opacity: opacity,
              child: const SizedBox(
                width: 10,
                height: 10,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _ShellScrollBehavior extends HelpFundUsScrollBehavior {
  const _ShellScrollBehavior();

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;
}
