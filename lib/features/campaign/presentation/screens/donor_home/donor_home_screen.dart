import 'dart:async';
import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_dimens.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/core/theme/theme_provider.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';
import 'package:helpfundus/core/network/api_client.dart';
import 'package:provider/provider.dart';
import 'package:helpfundus/features/campaign/data/campaign_catalog.dart';
import 'package:helpfundus/features/campaign/data/datasources/featured_campaigns_remote_data_source.dart';
import 'package:helpfundus/features/campaign/data/repositories/featured_campaigns_repository.dart';
import 'package:helpfundus/features/campaign/presentation/screens/campaign_detail/campaign_detail_screen.dart';
import 'package:helpfundus/features/campaign/presentation/screens/category_campaigns/category_campaigns_screen.dart';
import 'package:helpfundus/features/campaign/presentation/widgets/campaign_card.dart';

class DonorHomeScreen extends StatefulWidget {
  const DonorHomeScreen({
    super.key,
    required this.onExplore,
    this.firstName,
    this.onStartFundraiser,
    this.onDonate,
  });
  final VoidCallback onExplore;
  final String? firstName;
  final VoidCallback? onStartFundraiser;
  final VoidCallback? onDonate;

  @override
  State<DonorHomeScreen> createState() => _DonorHomeScreenState();
}

class _DonorHomeScreenState extends State<DonorHomeScreen> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  Timer? _refreshTimer;
  bool _refreshing = false;

  @override
  void initState() {
    super.initState();
    unawaited(_fetchFeaturedCampaigns());
  }

  Future<void> _fetchFeaturedCampaigns() async {
    try {
      await FeaturedCampaignsRepository(
        FeaturedCampaignsRemoteDataSource(ApiClient()),
      ).fetchFeaturedCampaigns();
    } catch (_) {
      // Keep the existing local cards visible until the backend campaign
      // response contract is confirmed and mapped into the UI.
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _startRefresh() {
    _refreshTimer?.cancel();
    setState(() => _refreshing = true);
    _refreshTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _refreshing = false);
    });
  }

  // Retained temporarily for the internal search overlay, which is no longer
  // exposed from the donor dashboard header.
  // ignore: unused_element
  void _openSearch() {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => Scaffold(
          backgroundColor: context.appBackground,
          body: SafeArea(child: _searchView()),
        ),
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _searchFocus.requestFocus(),
    );
  }

  void _closeSearch() {
    _searchFocus.unfocus();
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(24, 22, 24, 28),
    children: [
      _refreshBanner(),
      _header(),
      const SizedBox(height: 14),
      Text(
        'Make your giving count today',
        style: AppTextStyles.bodyMd.copyWith(
          fontSize: 16,
          color: context.appTextSecondary,
        ),
      ),
      const SizedBox(height: 18),
      _impact(),
      const SizedBox(height: 28),
      _section(
        'Browse by category',
        action: 'See all',
        onTap: widget.onExplore,
      ),
      const SizedBox(height: 10),
      _categories(),
      const SizedBox(height: 27),
      _section('⭐ Featured', action: 'See all', onTap: widget.onExplore),
      const SizedBox(height: 10),
      _featured(),
      const SizedBox(height: 28),
      _section('🔥 Trending now', action: 'See all', onTap: widget.onExplore),
      const SizedBox(height: 12),
      ..._campaignCards(CampaignCatalog.trending.take(3).toList()),
      const SizedBox(height: 28),
      _section('🕐 Recently added', action: 'See all', onTap: widget.onExplore),
      const SizedBox(height: 12),
      ..._campaignCards(CampaignCatalog.recent.take(3).toList()),
      const SizedBox(height: 24),
      _fundraiserCta(),
    ],
  );
  Widget _refreshBanner() => AnimatedSize(
    duration: const Duration(milliseconds: 340),
    curve: Curves.easeOutCubic,
    alignment: Alignment.topCenter,
    child: !_refreshing
        ? const SizedBox.shrink()
        : Column(
            children: [
              Container(
                height: 72,
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.linear,
                      builder: (context, turns, child) => Transform.rotate(
                        angle: turns * 6.28318,
                        child: child,
                      ),
                      child: const Icon(
                        Icons.sync_rounded,
                        size: 27,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Refreshing…',
                      style: AppTextStyles.buttonLg.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
  );
  Widget _header() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Good morning, ${widget.firstName?.trim().isNotEmpty == true ? widget.firstName!.trim() : 'Jane'}',
        style: AppTextStyles.h2.copyWith(
          fontSize: 25,
          color: context.appTextPrimary,
        ),
      ),
      const SizedBox(height: 4),
      Row(
        children: [
          const Text('👋', style: TextStyle(fontSize: 31)),
          const Spacer(),
          Tooltip(
            message: context.watch<ThemeProvider>().isDarkMode
                ? 'Switch to light mode'
                : 'Switch to dark mode',
            child: _action(
              context.watch<ThemeProvider>().isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_outlined,
              onTap: context.read<ThemeProvider>().toggleTheme,
            ),
          ),
          const SizedBox(width: 12),
          _action(
            Icons.refresh_rounded,
            onTap: _startRefresh,
            active: _refreshing,
          ),
          const SizedBox(width: 12),
          Stack(
            clipBehavior: Clip.none,
            children: [
              _action(Icons.notifications_none_rounded),
              const Positioned(
                right: 3,
                top: 3,
                child: CircleAvatar(
                  radius: 4,
                  backgroundColor: AppColors.coral,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
  Widget _action(IconData icon, {VoidCallback? onTap, bool active = false}) =>
      InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: context.appSurface,
            shape: BoxShape.circle,
            border: Border.all(color: context.appBorderStrong, width: 1.5),
          ),
          alignment: Alignment.center,
          child: active
              ? const SizedBox(
                  width: 19,
                  height: 19,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                )
              : Icon(
                  icon,
                  size: 21,
                  color: active ? AppColors.primary : context.appTextPrimary,
                ),
        ),
      );
  Widget _searchView() => ListView(
    padding: const EdgeInsets.fromLTRB(24, 26, 24, 28),
    children: [
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocus,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search campaigns, causes, locations',
                filled: true,
                fillColor: context.appInput,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: _closeSearch,
            child: Text(
              'Cancel',
              style: AppTextStyles.buttonLg.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
      const SizedBox(height: 26),
      Text(
        'RECENT SEARCHES',
        style: AppTextStyles.label.copyWith(
          color: context.appTextMuted,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 14),
      ...[
        'clean water',
        'medical expenses',
        'community centre',
        'school Kenya',
        'disaster relief',
      ].map(
        (item) => Container(
          height: 60,
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0x1A1A1A2E))),
          ),
          child: Row(
            children: [
              Icon(Icons.history, size: 22, color: context.appTextMuted),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  item,
                  style: AppTextStyles.buttonMd.copyWith(
                    fontSize: 16,
                    color: context.appTextPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(Icons.north_east, size: 20, color: context.appTextMuted),
            ],
          ),
        ),
      ),
      const SizedBox(height: 22),
      Text(
        'SUGGESTED CATEGORIES',
        style: AppTextStyles.label.copyWith(
          color: context.appTextMuted,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 14),
      Wrap(
        alignment: WrapAlignment.start,
        spacing: 10,
        runSpacing: 12,
        children:
            [
                  '📚  Education',
                  '🏥  Health',
                  '🆘  Crisis Support',
                  '🌾  Agriculture',
                  '🌱  Environment',
                  '🏘️  Community Dev.',
                ]
                .map(
                  (label) => InkWell(
                    onTap: () => _searchController.text = label,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: context.appSurface,
                        border: Border.all(color: context.appBorderStrong),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        label,
                        style: AppTextStyles.buttonMd.copyWith(
                          fontSize: 14,
                          color: context.appTextSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    ],
  );
  Widget _impact() => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppColors.primary, Color(0xFF11A8E0)],
      ),
      borderRadius: BorderRadius.circular(22),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'YOUR IMPACT THIS YEAR',
          style: AppTextStyles.buttonMd.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            _stat('\$147', 'Donated'),
            _stat('3', 'Causes'),
            _stat('est. 94', 'People helped'),
          ],
        ),
      ],
    ),
  );
  Widget _stat(String number, String label) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.h3.copyWith(color: Colors.white),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: Colors.white70),
        ),
      ],
    ),
  );
  Widget _section(String title, {String? action, VoidCallback? onTap}) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: AppTextStyles.h3.copyWith(
            fontSize: 20,
            color: context.appTextPrimary,
          ),
        ),
      ),
      if (action != null)
        TextButton(
          onPressed: onTap,
          child: Text(
            action,
            style: AppTextStyles.buttonMd.copyWith(color: AppColors.primary),
          ),
        ),
    ],
  );
  Widget _categories() => SizedBox(
    height: 91,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: CampaignCatalog.categories.length,
      separatorBuilder: (_, __) => const SizedBox(width: 13),
      itemBuilder: (_, i) {
        final category = CampaignCatalog.categories[i];
        return SizedBox(
          width: 64,
          child: InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => CategoryCampaignsScreen(
                  category: category,
                  onGuestDonate: widget.onDonate,
                ),
              ),
            ),
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: category.color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    category.emoji,
                    style: const TextStyle(
                      fontSize: 28,
                      shadows: [
                        Shadow(
                          color: Color(0x330A1B3D),
                          offset: Offset(0, 2),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: context.appTextMuted,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
  Widget _featured() => SizedBox(
    height: 220,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: CampaignCatalog.featured.length,
      separatorBuilder: (_, __) => const SizedBox(width: 14),
      itemBuilder: (_, i) => SizedBox(
        width: 232,
        child: CampaignCard.fromCampaign(
          campaign: CampaignCatalog.featured[i],
          variant: CampaignCardVariant.featured,
          onTap: () => _openDetail(CampaignCatalog.featured[i]),
        ),
      ),
    ),
  );
  List<Widget> _campaignCards(List<CampaignData> campaigns) => [
    for (final campaign in campaigns) ...[
      CampaignCard.fromCampaign(
        campaign: campaign,
        onTap: () => _openDetail(campaign),
      ),
      const SizedBox(height: 16),
    ],
  ];

  void _openDetail(CampaignData campaign) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => CampaignDetailScreen(
        campaign: campaign,
        onGuestDonate: widget.onDonate,
      ),
    ),
  );
  Widget _fundraiserCta() => Semantics(
    button: true,
    label: 'Start a fundraiser',
    child: InkWell(
      onTap: widget.onStartFundraiser,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        constraints: const BoxConstraints(minHeight: 132),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          gradient: context.isDarkTheme
              ? null
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFC6F1D5), Color(0xFFE0F7EA)],
                ),
          color: context.isDarkTheme ? context.appSurfaceElevated : null,
          border: Border.all(
            color: context.isDarkTheme
                ? context.appBorder
                : const Color(0xFFAAE6BF),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(19),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Start a fundraiser',
                    style: AppTextStyles.h3.copyWith(
                      fontSize: 20,
                      height: 1.15,
                      color: context.appTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Launch your campaign in minutes and reach thousands of donors worldwide.',
                    style: AppTextStyles.bodyMd.copyWith(
                      fontSize: 14,
                      height: 1.42,
                      color: context.appTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_forward, color: AppColors.primary, size: 26),
          ],
        ),
      ),
    ),
  );
}
