import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/campaign_card.dart';

class DonorHomeScreen extends StatefulWidget {
  const DonorHomeScreen({
    super.key,
    required this.onExplore,
    this.onStartFundraiser,
  });
  final VoidCallback onExplore;
  final VoidCallback? onStartFundraiser;

  @override
  State<DonorHomeScreen> createState() => _DonorHomeScreenState();
}

class _DonorHomeScreenState extends State<DonorHomeScreen> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  Timer? _refreshTimer;
  bool _refreshing = false;

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

  void _openSearch() {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => Scaffold(
          backgroundColor: AppColors.background,
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
        style: AppTextStyles.bodyMd.copyWith(fontSize: 16),
      ),
      const SizedBox(height: 18),
      TextField(
        readOnly: true,
        onTap: _openSearch,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Color(0xFF9AA4B5)),
          hintText: 'Search campaigns, causes...',
          hintStyle: AppTextStyles.bodyLg.copyWith(
            color: const Color(0xFF9AA4B5),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFFCBD1DB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFFCBD1DB)),
          ),
        ),
      ),
      const SizedBox(height: 24),
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
      _section('🔥 Trending now'),
      const SizedBox(height: 12),
      ..._feedCards.take(4),
      const SizedBox(height: 28),
      _section('🕐 Recently added'),
      const SizedBox(height: 12),
      ..._feedCards.skip(4),
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
        'Good morning, Jane',
        style: AppTextStyles.h2.copyWith(fontSize: 27),
      ),
      const SizedBox(height: 4),
      Row(
        children: [
          const Text('👋', style: TextStyle(fontSize: 31)),
          const Spacer(),
          _action(
            Icons.refresh_rounded,
            onTap: _startRefresh,
            active: _refreshing,
          ),
          const SizedBox(width: 12),
          _action(Icons.search_rounded, onTap: _openSearch),
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
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFCBD1DB), width: 1.5),
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
                  color: active ? AppColors.primary : AppColors.textPrimary,
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
                fillColor: Colors.white,
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
          color: const Color(0xFF9AA4B5),
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
              const Icon(Icons.history, size: 22, color: Color(0xFF9AA4B5)),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  item,
                  style: AppTextStyles.buttonMd.copyWith(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Icon(Icons.north_east, size: 20, color: Color(0xFF9AA4B5)),
            ],
          ),
        ),
      ),
      const SizedBox(height: 22),
      Text(
        'SUGGESTED CATEGORIES',
        style: AppTextStyles.label.copyWith(
          color: const Color(0xFF9AA4B5),
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
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFCBD1DB)),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        label,
                        style: AppTextStyles.buttonMd.copyWith(
                          fontSize: 14,
                          color: const Color(0xFF697487),
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
      Expanded(child: Text(title, style: AppTextStyles.h3)),
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
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(width: 13),
      itemBuilder: (_, i) {
        const data = [
          ('🏥', 'Health', Color(0xFFF47E7E)),
          ('🆘', 'Crisis', Color(0xFFF9BA56)),
          ('🌾', 'Agriculture', Color(0xFF9BD95A)),
          ('🌱', 'Environment', Color(0xFF67CE86)),
          ('🏘️', 'Community', Color(0xFF9A77F0)),
          ('💧', 'Water', Color(0xFF52C4DA)),
        ];
        final item = data[i];
        return SizedBox(
          width: 64,
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: item.$3,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(item.$1, style: const TextStyle(fontSize: 28)),
              ),
              const SizedBox(height: 4),
              Text(
                item.$2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption,
              ),
            ],
          ),
        );
      },
    ),
  );
  Widget _featured() => SizedBox(
    height: 220,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(width: 14),
      itemBuilder: (_, i) => SizedBox(width: 232, child: _featuredCards[i]),
    ),
  );
  static const _featuredCards = [
    CampaignCard(
      title: 'Help rebuild our community centre',
      category: 'Community Dev.',
      amount: '\$14,400',
      progress: .72,
      location: '',
      variant: CampaignCardVariant.featured,
    ),
    CampaignCard(
      title: "Medical expenses for Leah's treatment",
      category: 'Health',
      amount: '\$8,700',
      progress: .58,
      location: '',
      icon: '🏥',
      variant: CampaignCardVariant.featured,
      gradient: LinearGradient(colors: [Color(0xFFFF4545), Color(0xFFFF791E)]),
    ),
    CampaignCard(
      title: 'Clean water wells',
      category: 'Water',
      amount: '\$19,200',
      progress: .77,
      location: '',
      icon: '💧',
      variant: CampaignCardVariant.featured,
      gradient: LinearGradient(colors: [Color(0xFF12B5D7), Color(0xFF2B57A5)]),
    ),
  ];
  static const _feedCards = [
    CampaignCard(
      title: 'Help rebuild our community centre',
      category: 'Community Dev.',
      amount: '\$14,400',
      progress: .72,
      location: 'Lagos, Nigeria',
    ),
    SizedBox(height: 16),
    CampaignCard(
      title: 'School supplies for rural Kenya',
      category: 'Education',
      amount: '\$3,200',
      progress: .64,
      location: 'Kisumu, Kenya',
      icon: '📚',
      gradient: LinearGradient(colors: [Color(0xFF3495F4), Color(0xFF12B5D7)]),
    ),
    SizedBox(height: 16),
    CampaignCard(
      title: 'Clean water wells for Turkana County',
      category: 'Water & Sanitation',
      amount: '\$19,200',
      progress: .77,
      location: 'Turkana, Kenya',
      icon: '💧',
      gradient: LinearGradient(colors: [Color(0xFF12B5D7), Color(0xFF2B57A5)]),
    ),
    SizedBox(height: 16),
    CampaignCard(
      title: 'Disaster relief — Morocco earthquake',
      category: 'Disaster Relief',
      amount: '\$31,000',
      progress: .78,
      location: 'Marrakech, Morocco',
      icon: '🌊',
      gradient: LinearGradient(colors: [Color(0xFFF12E23), Color(0xFFAB3A11)]),
    ),
    SizedBox(height: 16),
    CampaignCard(
      title: 'Emergency food parcels',
      category: 'Food Security',
      amount: '\$6,100',
      progress: .76,
      location: 'Tema, Ghana',
      icon: '🍚',
      gradient: LinearGradient(colors: [Color(0xFFE97B09), Color(0xFFC63928)]),
    ),
    SizedBox(height: 16),
    CampaignCard(
      title: 'Plant trees across urban schools',
      category: 'Environment',
      amount: '\$9,400',
      progress: .61,
      location: 'Kampala, Uganda',
      icon: '🌱',
      gradient: LinearGradient(colors: [Color(0xFF54C86B), Color(0xFF189F86)]),
    ),
  ];
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
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFC6F1D5), Color(0xFFE0F7EA)],
          ),
          border: Border.all(color: Color(0xFFAAE6BF), width: 2),
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
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Launch your campaign in minutes and reach thousands of donors worldwide.',
                    style: AppTextStyles.bodyMd.copyWith(
                      fontSize: 14,
                      height: 1.42,
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
