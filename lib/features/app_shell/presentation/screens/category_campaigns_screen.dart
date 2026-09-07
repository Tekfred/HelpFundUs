import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../models/campaign_catalog.dart';
import '../widgets/campaign_card.dart';
import 'campaign_detail_screen.dart';

class CategoryCampaignsScreen extends StatefulWidget {
  const CategoryCampaignsScreen({
    super.key,
    required this.category,
    this.onGuestDonate,
  });
  final CampaignCategory category;
  final VoidCallback? onGuestDonate;
  @override
  State<CategoryCampaignsScreen> createState() =>
      _CategoryCampaignsScreenState();
}

class _CategoryCampaignsScreenState extends State<CategoryCampaignsScreen> {
  final _searchController = TextEditingController();
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final campaigns = CampaignCatalog.forCategory(widget.category)
        .where(
          (campaign) =>
              query.isEmpty ||
              campaign.title.toLowerCase().contains(query) ||
              campaign.location.toLowerCase().contains(query),
        )
        .toList();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _hero(context),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF9AA4B5),
                      ),
                      hintText: 'Search in ${widget.category.name}...',
                      hintStyle: AppTextStyles.bodyLg.copyWith(
                        color: const Color(0xFF9098A8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      enabledBorder: _searchBorder,
                      focusedBorder: _searchBorder.copyWith(
                        borderSide: BorderSide(
                          color: widget.category.color,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Text(
                    'Showing ${campaigns.length} ${campaigns.length == 1 ? 'campaign' : 'campaigns'}',
                    style: AppTextStyles.bodyLg.copyWith(
                      color: const Color(0xFF929DAE),
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (campaigns.isEmpty)
                    _emptyState()
                  else
                    for (final campaign in campaigns) ...[
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  OutlineInputBorder get _searchBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(18),
    borderSide: const BorderSide(color: Color(0xFFCBD1DB)),
  );
  Widget _hero(BuildContext context) => Container(
    color: widget.category.color,
    padding: const EdgeInsets.fromLTRB(24, 22, 24, 38),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _heroButton(
              Icons.arrow_back_ios_new_rounded,
              () => Navigator.of(context).pop(),
            ),
            _heroButton(
              Icons.tune_rounded,
              () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('More filters will be available soon.'),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 38),
        Text(widget.category.emoji, style: const TextStyle(fontSize: 48)),
        const SizedBox(height: 22),
        Text(
          widget.category.name,
          style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 31),
        ),
        const SizedBox(height: 10),
        Text(
          widget.category.description,
          style: AppTextStyles.bodyMd.copyWith(
            color: Colors.white,
            fontSize: 16,
            height: 1.32,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .22),
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Text(
            '${_formatCount(widget.category.campaignCount)} campaigns',
            style: AppTextStyles.buttonMd.copyWith(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      ],
    ),
  );
  Widget _heroButton(IconData icon, VoidCallback onTap) => Material(
    color: Colors.white.withValues(alpha: .22),
    shape: const CircleBorder(),
    child: InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: SizedBox(
        width: 54,
        height: 54,
        child: Icon(icon, color: Colors.white, size: 25),
      ),
    ),
  );
  Widget _emptyState() => Padding(
    padding: const EdgeInsets.only(top: 92),
    child: Center(
      child: Column(
        children: [
          Text(widget.category.emoji, style: const TextStyle(fontSize: 58)),
          const SizedBox(height: 24),
          Text('No campaigns found', style: AppTextStyles.h3),
          const SizedBox(height: 10),
          Text(
            'No active ${widget.category.name} campaigns yet.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMd.copyWith(
              color: const Color(0xFF929DAE),
            ),
          ),
        ],
      ),
    ),
  );
  String _formatCount(int value) => value.toString().replaceFirstMapped(
    RegExp(r'^(\d+)(\d{3})$'),
    (match) => '${match.group(1)},${match.group(2)}',
  );
}
