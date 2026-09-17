import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';
import 'package:helpfundus/features/campaign/data/campaign_catalog.dart';
import 'package:helpfundus/features/campaign/presentation/screens/campaign_detail/campaign_detail_screen.dart';
import 'package:helpfundus/features/campaign/presentation/widgets/campaign_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key, this.onGuestDonate});
  final VoidCallback? onGuestDonate;
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _category = 'All';
  String _goalRange = 'All';
  String _sortBy = 'Newest';
  bool _verifiedOnly = false;
  String _fundingProgress = 'Any progress';
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
    var campaigns = _category == 'All'
        ? CampaignCatalog.all
        : CampaignCatalog.all
              .where(
                (campaign) =>
                    campaign.category == _category ||
                    campaign.categoryKey == _category,
              )
              .toList();
    campaigns = campaigns
        .where((campaign) => _matchesGoalRange(campaign.goal))
        .toList();
    campaigns = campaigns.where(_matchesAdditionalFilters).toList();
    campaigns = _sortCampaigns(campaigns);
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 112),
      children: [
        Text(
          'Explore',
          style: AppTextStyles.h1.copyWith(
            fontSize: 27,
            color: context.appTextPrimary,
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _search,
          readOnly: true,
          onTap: _openSearch,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: 'Search campaigns...',
            filled: true,
            fillColor: context.appInput,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: context.appBorderStrong),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: context.appBorderStrong),
            ),
          ),
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _filterButton(
                context,
                Icons.sell_outlined,
                'Category',
                _category,
                _selectCategory,
              ),
              const SizedBox(width: 10),
              _filterButton(
                context,
                Icons.show_chart_rounded,
                'Goal range',
                _goalRange,
                _selectGoalRange,
              ),
              const SizedBox(width: 10),
              _filterButton(
                context,
                Icons.sort_rounded,
                'Sort by',
                _sortBy,
                _selectSort,
              ),
              const SizedBox(width: 10),
              _filterButton(
                context,
                Icons.tune_rounded,
                'Filters',
                _verifiedOnly || _fundingProgress != 'Any progress'
                    ? 'Active'
                    : 'All',
                _selectAdditionalFilters,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          '${campaigns.length} campaigns',
          style: AppTextStyles.bodyLg.copyWith(color: context.appTextMuted),
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

  Widget _filterButton(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    VoidCallback onTap,
  ) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: context.appSurface,
        border: Border.all(color: context.appBorderStrong),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: context.appTextSecondary),
          const SizedBox(width: 7),
          Text(
            '$label: ',
            style: AppTextStyles.caption.copyWith(
              fontSize: 11,
              color: context.appTextMuted,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.buttonMd.copyWith(
              fontSize: 12,
              color: context.appTextPrimary,
            ),
          ),
          const SizedBox(width: 3),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: context.appTextMuted,
          ),
        ],
      ),
    ),
  );

  Future<void> _selectCategory() async {
    final options = [
      'All',
      ...CampaignCatalog.categories.map((category) => category.name),
    ];
    final selection = await _showChoices(
      'Select category',
      'Choose a category to filter campaigns.',
      options,
      _category,
    );
    if (selection != null) setState(() => _category = selection);
  }

  Future<void> _selectGoalRange() async {
    const options = [
      'All',
      '\$0 – \$10k',
      '\$10k – \$50k',
      '\$50k – \$250k',
      '\$250k – \$500k',
      '\$500k – \$1M',
      '\$1M+',
    ];
    final selection = await _showChoices(
      'Select goal range',
      'Choose a goal range to filter campaigns.',
      options,
      _goalRange,
    );
    if (selection != null) setState(() => _goalRange = selection);
  }

  Future<void> _selectSort() async {
    const options = [
      'Newest',
      'Oldest',
      'Highest target',
      'Lowest target',
      'Most funded',
    ];
    final selection = await _showChoices(
      'Sort campaigns',
      'Choose the order for displayed campaigns.',
      options,
      _sortBy,
      listStyle: true,
    );
    if (selection != null) setState(() => _sortBy = selection);
  }

  Future<String?> _showChoices(
    String title,
    String description,
    List<String> options,
    String selected, {
    bool listStyle = false,
  }) => showModalBottomSheet<String>(
    context: context,
    backgroundColor: context.appSurfaceElevated,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheetContext) => SafeArea(
      top: false,
      child: SizedBox(
        width: double.infinity,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(sheetContext).height * .72,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.h3.copyWith(
                      fontSize: 19,
                      color: sheetContext.appTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: AppTextStyles.bodySm.copyWith(
                      fontSize: 13,
                      color: sheetContext.appTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (listStyle)
                    ...options.map(
                      (option) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () =>
                                Navigator.pop(sheetContext, option),
                            style: OutlinedButton.styleFrom(
                              alignment: Alignment.centerLeft,
                              backgroundColor: option == selected
                                  ? AppColors.primary
                                  : sheetContext.appInput,
                              foregroundColor: option == selected
                                  ? Colors.white
                                  : sheetContext.appTextPrimary,
                              side: BorderSide(
                                color: option == selected
                                    ? AppColors.primary
                                    : sheetContext.appBorderStrong,
                              ),
                            ),
                            child: Text(option),
                          ),
                        ),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 9,
                      runSpacing: 10,
                      children: options
                          .map(
                            (option) => ChoiceChip(
                              label: Text(option),
                              selected: option == selected,
                              onSelected: (_) =>
                                  Navigator.pop(sheetContext, option),
                              selectedColor: AppColors.primary,
                              labelStyle: AppTextStyles.buttonMd.copyWith(
                                fontSize: 13,
                                color: option == selected
                                    ? Colors.white
                                    : sheetContext.appTextPrimary,
                              ),
                              backgroundColor: sheetContext.appInput,
                              side: BorderSide(
                                color: option == selected
                                    ? AppColors.primary
                                    : sheetContext.appBorderStrong,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Future<void> _selectAdditionalFilters() async {
    final result = await showModalBottomSheet<_AdditionalFilters>(
      context: context,
      backgroundColor: context.appSurfaceElevated,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => _AdditionalFiltersSheet(
        verifiedOnly: _verifiedOnly,
        fundingProgress: _fundingProgress,
      ),
    );
    if (result != null) {
      setState(() {
        _verifiedOnly = result.verifiedOnly;
        _fundingProgress = result.fundingProgress;
      });
    }
  }

  bool _matchesAdditionalFilters(CampaignData campaign) {
    if (_verifiedOnly && campaign.status != CampaignStatus.active) return false;
    return switch (_fundingProgress) {
      'Under 50% funded' => campaign.progress < .5,
      'Over 50% funded' => campaign.progress >= .5,
      'Nearly funded (80%+)' => campaign.progress >= .8,
      _ => true,
    };
  }

  bool _matchesGoalRange(String goal) {
    final value = int.tryParse(goal.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    return switch (_goalRange) {
      'All' => true,
      '\$0 – \$10k' => value <= 10000,
      '\$10k – \$50k' => value > 10000 && value <= 50000,
      '\$50k – \$250k' => value > 50000 && value <= 250000,
      '\$250k – \$500k' => value > 250000 && value <= 500000,
      '\$500k – \$1M' => value > 500000 && value <= 1000000,
      _ => value > 1000000,
    };
  }

  List<CampaignData> _sortCampaigns(List<CampaignData> campaigns) {
    final sorted = [...campaigns];
    int target(CampaignData campaign) =>
        int.tryParse(campaign.goal.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    switch (_sortBy) {
      case 'Oldest':
        return sorted.reversed.toList();
      case 'Highest target':
        sorted.sort((a, b) => target(b).compareTo(target(a)));
        break;
      case 'Lowest target':
        sorted.sort((a, b) => target(a).compareTo(target(b)));
        break;
      case 'Most funded':
        sorted.sort((a, b) => b.donors.compareTo(a.donors));
        break;
    }
    return sorted;
  }
}

class _AdditionalFilters {
  const _AdditionalFilters(this.verifiedOnly, this.fundingProgress);
  final bool verifiedOnly;
  final String fundingProgress;
}

class _AdditionalFiltersSheet extends StatefulWidget {
  const _AdditionalFiltersSheet({
    required this.verifiedOnly,
    required this.fundingProgress,
  });
  final bool verifiedOnly;
  final String fundingProgress;
  @override
  State<_AdditionalFiltersSheet> createState() =>
      _AdditionalFiltersSheetState();
}

class _AdditionalFiltersSheetState extends State<_AdditionalFiltersSheet> {
  late bool _verifiedOnly = widget.verifiedOnly;
  late String _fundingProgress = widget.fundingProgress;
  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'More filters',
            style: AppTextStyles.h3.copyWith(
              fontSize: 19,
              color: context.appTextPrimary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'VERIFICATION',
            style: AppTextStyles.label.copyWith(
              fontSize: 12,
              color: context.appTextMuted,
            ),
          ),
          const SizedBox(height: 9),
          _option(
            'Verified campaigns only',
            _verifiedOnly,
            () => setState(() => _verifiedOnly = !_verifiedOnly),
            leading: Icons.verified_outlined,
          ),
          const SizedBox(height: 22),
          Text(
            'FUNDING PROGRESS',
            style: AppTextStyles.label.copyWith(
              fontSize: 12,
              color: context.appTextMuted,
            ),
          ),
          const SizedBox(height: 9),
          ...[
            'Any progress',
            'Under 50% funded',
            'Over 50% funded',
            'Nearly funded (80%+)',
          ].map(
            (value) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: _option(
                value,
                value == _fundingProgress,
                () => setState(() => _fundingProgress = value),
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.pop(
                context,
                _AdditionalFilters(_verifiedOnly, _fundingProgress),
              ),
              child: const Text('Apply filters'),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _option(
    String label,
    bool selected,
    VoidCallback onTap, {
    IconData? leading,
  }) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: selected
            ? AppColors.primary.withValues(alpha: .1)
            : context.appSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? AppColors.primary : context.appBorderStrong,
          width: selected ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          if (leading != null) ...[
            Icon(leading, color: context.appTextMuted),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.buttonMd.copyWith(
                fontSize: 15,
                color: context.appTextPrimary,
              ),
            ),
          ),
          if (selected)
            const Icon(Icons.check_rounded, color: AppColors.primary),
        ],
      ),
    ),
  );
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
    backgroundColor: context.appBackground,
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
                    fillColor: context.appInput,
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
            (item) => ListTile(
              leading: Icon(Icons.history, color: context.appTextMuted),
              title: Text(
                item,
                style: AppTextStyles.buttonMd.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: context.appTextPrimary,
                ),
              ),
              trailing: Icon(Icons.north_east, color: context.appTextMuted),
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
                          color: context.appSurface,
                          border: Border.all(color: context.appBorderStrong),
                          borderRadius: BorderRadius.circular(99),
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
                    )
                    .toList(),
          ),
        ],
      ),
    ),
  );
}
