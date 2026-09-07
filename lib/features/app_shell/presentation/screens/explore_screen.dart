import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../models/campaign_catalog.dart';
import '../widgets/campaign_card.dart';
import 'campaign_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key, this.onGuestDonate});
  final VoidCallback? onGuestDonate;
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
    final campaigns = _category == 'All'
        ? CampaignCatalog.all
        : CampaignCatalog.all
              .where(
                (campaign) =>
                    campaign.category == _category ||
                    campaign.categoryKey == _category,
              )
              .toList();
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
          '${campaigns.length} campaigns',
          style: AppTextStyles.bodyLg.copyWith(color: const Color(0xFF9AA4B5)),
        ),
        const SizedBox(height: 18),
        ...campaigns.expand(
          (campaign) => [
            CampaignCard.fromCampaign(
              campaign: campaign,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => CampaignDetailScreen(
                    campaign: campaign,
                    onGuestDonate: widget.onGuestDonate,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ],
    );
  }
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
