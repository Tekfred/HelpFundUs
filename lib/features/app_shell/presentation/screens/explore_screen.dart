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

  @override
  Widget build(BuildContext context) {
    final cards = _category == 'Health'
        ? [_health()]
        : [_community(), _health()];
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 112),
      children: [
        Text('Explore', style: AppTextStyles.h1),
        const SizedBox(height: 24),
        TextField(
          controller: _search,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: 'Search campaigns...',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: const BorderSide(color: Color(0xFFD1D6DE)),
            ),
          ),
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
                    child: ChoiceChip(
                      label: Text(item),
                      selected: selected,
                      onSelected: (_) => setState(() => _category = label),
                      selectedColor: AppColors.primary,
                      labelStyle: AppTextStyles.buttonMd.copyWith(
                        color: selected
                            ? Colors.white
                            : const Color(0xFF6B7587),
                      ),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFD1D6DE)),
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

  CampaignCard _community() => const CampaignCard(
    title: 'Help rebuild our community centre',
    category: 'Community Dev.',
    amount: '\$14,400',
    progress: .72,
    location: 'Lagos, Nigeria',
  );
  CampaignCard _health() => const CampaignCard(
    title: "Medical expenses for Leah's treatment",
    category: 'Health',
    amount: '\$8,700',
    progress: .58,
    location: 'Accra, Ghana',
    icon: '🏥',
    gradient: LinearGradient(colors: [Color(0xFFFF4545), Color(0xFFFF791E)]),
  );
}
