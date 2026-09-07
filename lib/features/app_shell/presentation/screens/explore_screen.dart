import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/campaign_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _category = 'All';
  final _search = TextEditingController();
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _openSearch() => Navigator.of(context, rootNavigator: true).push(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => const _ExploreSearchOverlay(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final cards = _category == 'All'
        ? _cards
        : _cards.where((card) => card.category == _category).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 112),
      children: [
        Text('Explore', style: AppTextStyles.h1),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _search,
                readOnly: true,
                onTap: _openSearch,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search campaigns...',
                  filled: true,
                  fillColor: Colors.white,
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
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 58,
              height: 58,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  side: const BorderSide(color: Color(0xFFCBD1DB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Icon(
                  Icons.filter_alt_outlined,
                  size: 30,
                  color: Color(0xFF687386),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['All', '📚 Education', '🏥 Health', '🆘 Crisis Support']
                .map((item) {
                  final label = item.replaceAll(RegExp(r'^.. '), '');
                  final selected = _category == label;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () => setState(() => _category = label),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primary : Colors.white,
                          border: Border.all(
                            color: selected
                                ? AppColors.primary
                                : const Color(0xFFCBD1DB),
                          ),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          item,
                          style: AppTextStyles.buttonMd.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: selected
                                ? Colors.white
                                : const Color(0xFF697487),
                          ),
                        ),
                      ),
                    ),
                  );
                })
                .toList(),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          '${cards.length + 5} campaigns',
          style: AppTextStyles.bodyLg.copyWith(color: const Color(0xFF9AA4B5)),
        ),
        const SizedBox(height: 18),
        ...cards.expand((card) => [card, const SizedBox(height: 20)]),
      ],
    );
  }

  static const _cards = [
    CampaignCard(
      title: 'Help rebuild our community centre',
      category: 'Community Dev.',
      amount: '\$14,400',
      progress: .72,
      location: 'Lagos, Nigeria',
    ),
    CampaignCard(
      title: "Medical expenses for Leah's treatment",
      category: 'Health',
      amount: '\$8,700',
      progress: .58,
      location: 'Accra, Ghana',
      icon: '🏥',
      gradient: LinearGradient(colors: [Color(0xFFFF4545), Color(0xFFFF791E)]),
    ),
    CampaignCard(
      title: 'School supplies for rural Kenya',
      category: 'Education',
      amount: '\$3,200',
      progress: .64,
      location: 'Kisumu, Kenya',
      icon: '📚',
      gradient: LinearGradient(colors: [Color(0xFF3495F4), Color(0xFF12B5D7)]),
    ),
    CampaignCard(
      title: 'Clean water wells for Turkana County',
      category: 'Water',
      amount: '\$19,200',
      progress: .77,
      location: 'Turkana, Kenya',
      icon: '💧',
      gradient: LinearGradient(colors: [Color(0xFF12B5D7), Color(0xFF2B57A5)]),
    ),
    CampaignCard(
      title: 'Disaster relief — Morocco earthquake',
      category: 'Crisis Support',
      amount: '\$31,000',
      progress: .78,
      location: 'Marrakech, Morocco',
      icon: '🌊',
      gradient: LinearGradient(colors: [Color(0xFFF12E23), Color(0xFFAB3A11)]),
    ),
    CampaignCard(
      title: 'Emergency food parcels',
      category: 'Food Security',
      amount: '\$6,100',
      progress: .76,
      location: 'Tema, Ghana',
      icon: '🍚',
      gradient: LinearGradient(colors: [Color(0xFFE97B09), Color(0xFFC63928)]),
    ),
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
}

class _ExploreSearchOverlay extends StatefulWidget {
  const _ExploreSearchOverlay();
  @override
  State<_ExploreSearchOverlay> createState() => _ExploreSearchOverlayState();
}

class _ExploreSearchOverlayState extends State<_ExploreSearchOverlay> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 26, 24, 28),
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focus,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search campaigns, causes, locations',
                    filled: true,
                    fillColor: Colors.white,
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
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.buttonLg.copyWith(
                    color: AppColors.primary,
                  ),
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
            (item) => ListTile(
              leading: const Icon(Icons.history, color: Color(0xFF9AA4B5)),
              title: Text(
                item,
                style: AppTextStyles.buttonMd.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              trailing: const Icon(Icons.north_east, color: Color(0xFF9AA4B5)),
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
                      (label) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFCBD1DB)),
                          borderRadius: BorderRadius.circular(99),
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
                    )
                    .toList(),
          ),
        ],
      ),
    ),
  );
}
