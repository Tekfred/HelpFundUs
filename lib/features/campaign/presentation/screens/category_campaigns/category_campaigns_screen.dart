import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_dimens.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/features/campaign/data/campaign_catalog.dart';
import 'package:helpfundus/features/campaign/presentation/screens/campaign_detail/campaign_detail_screen.dart';
import 'package:helpfundus/features/campaign/presentation/widgets/campaign_card.dart';

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
  String _categoryFilter = '';
  String _goalFilter = 'Any goal';
  String _sortBy = 'Recommended';
  bool _verifiedOnly = false;
  bool _fundingProgress = false;

  @override
  void initState() {
    super.initState();
    _categoryFilter = widget.category.name;
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final campaigns = CampaignCatalog.all
        .where(
          (campaign) =>
              query.isEmpty ||
              campaign.title.toLowerCase().contains(query) ||
              campaign.location.toLowerCase().contains(query),
        )
        .toList();
    campaigns.removeWhere((campaign) {
      final goal = double.tryParse(campaign.goal.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      final inGoalRange = switch (_goalFilter) {
        'Under \$10,000' => goal < 10000,
        '\$10,000–\$25,000' => goal >= 10000 && goal <= 25000,
        'Over \$25,000' => goal > 25000,
        _ => true,
      };
      return (_categoryFilter.isNotEmpty && campaign.categoryKey != _categoryFilter) ||
          (_verifiedOnly && !campaign.verified) ||
          (_fundingProgress && campaign.progress < .5) ||
          !inGoalRange;
    });
    switch (_sortBy) {
      case 'Funding progress':
        campaigns.sort((a, b) => b.progress.compareTo(a.progress));
        break;
      case 'Goal: low to high':
        campaigns.sort((a, b) =>
            (double.tryParse(a.goal.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0)
                .compareTo(double.tryParse(b.goal.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0));
        break;
    }
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
              _showFilters,
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

  Future<void> _showFilters() async {
    final result = await showModalBottomSheet<_CampaignFilters>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _CampaignFilterSheet(
        category: _categoryFilter.isEmpty ? 'All categories' : _categoryFilter,
        goal: _goalFilter,
        sortBy: _sortBy,
        verifiedOnly: _verifiedOnly,
        fundingProgress: _fundingProgress,
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      _categoryFilter = result.category == 'All categories' ? '' : result.category;
      _goalFilter = result.goal;
      _sortBy = result.sortBy;
      _verifiedOnly = result.verifiedOnly;
      _fundingProgress = result.fundingProgress;
    });
  }
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

class _CampaignFilters {
  const _CampaignFilters(this.category, this.goal, this.sortBy,
      this.verifiedOnly, this.fundingProgress);
  final String category, goal, sortBy;
  final bool verifiedOnly, fundingProgress;
}

class _CampaignFilterSheet extends StatefulWidget {
  const _CampaignFilterSheet({required this.category, required this.goal,
    required this.sortBy, required this.verifiedOnly, required this.fundingProgress});
  final String category, goal, sortBy;
  final bool verifiedOnly, fundingProgress;
  @override
  State<_CampaignFilterSheet> createState() => _CampaignFilterSheetState();
}

class _CampaignFilterSheetState extends State<_CampaignFilterSheet> {
  late String category = widget.category;
  late String goal = widget.goal;
  late String sortBy = widget.sortBy;
  late bool verifiedOnly = widget.verifiedOnly;
  late bool fundingProgress = widget.fundingProgress;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: EdgeInsets.fromLTRB(24, 20, 24, 20 + MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Filter campaigns', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          _dropdown('Category', category, ['All categories', ...CampaignCatalog.categories.map((e) => e.name)], (v) => setState(() => category = v)),
          _dropdown('Goal range', goal, ['Any goal', 'Under \$10,000', '\$10,000–\$25,000', 'Over \$25,000'], (v) => setState(() => goal = v)),
          _dropdown('Sort by', sortBy, ['Recommended', 'Funding progress', 'Goal: low to high'], (v) => setState(() => sortBy = v)),
          SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('Verified campaigns only'), value: verifiedOnly, onChanged: (v) => setState(() => verifiedOnly = v)),
          SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('Funding progress above 50%'), value: fundingProgress, onChanged: (v) => setState(() => fundingProgress = v)),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: FilledButton(onPressed: () => Navigator.pop(context, _CampaignFilters(category, goal, sortBy, verifiedOnly, fundingProgress)), child: const Text('Apply filters'))),
        ])),
    ),
  );

  Widget _dropdown(String label, String value, List<String> values, ValueChanged<String> onChanged) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      items: values.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
      onChanged: (v) { if (v != null) onChanged(v); },
    ),
  );
}
