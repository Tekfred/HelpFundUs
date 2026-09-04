import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/campaign_card.dart';

class DonorHomeScreen extends StatelessWidget {
  const DonorHomeScreen({super.key, required this.onExplore});
  final VoidCallback onExplore;
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 112),
      children: [
        Text('Good morning, Jane', style: AppTextStyles.h1),
        const SizedBox(height: 5),
        Text('👋  Make your giving count today', style: AppTextStyles.bodyLg),
        const SizedBox(height: 22),
        TextField(decoration: _searchDecoration()),
        const SizedBox(height: 28),
        _impactCard(),
        const SizedBox(height: 34),
        Row(
          children: [
            Text('Browse by category', style: AppTextStyles.h3),
            const Spacer(),
            TextButton(onPressed: onExplore, child: const Text('See all')),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 104,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              _Category('📚', 'Education'),
              _Category('🏥', 'Health'),
              _Category('🆘', 'Crisis'),
              _Category('🌾', 'Agriculture'),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Text('⭐ Featured', style: AppTextStyles.h3),
        const SizedBox(height: 12),
        const CampaignCard(
          title: 'Help rebuild our community centre',
          category: 'Community Dev.',
          amount: '\$14,400',
          progress: .72,
          location: 'Lagos, Nigeria',
        ),
        const SizedBox(height: 24),
        const CampaignCard(
          title: 'Clean water wells for Turkana County',
          category: 'Water & Sanitation',
          amount: '\$19,200',
          progress: .77,
          location: 'Turkana, Kenya',
          icon: '💧',
          gradient: LinearGradient(
            colors: [Color(0xFF12B5D7), Color(0xFF2B57A5)],
          ),
        ),
      ],
    );
  }

  InputDecoration _searchDecoration() => InputDecoration(
    prefixIcon: const Icon(Icons.search),
    hintText: 'Search campaigns, causes...',
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(22),
      borderSide: const BorderSide(color: Color(0xFFD1D6DE)),
    ),
  );
  Widget _impactCard() => Container(
    padding: const EdgeInsets.all(26),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppColors.primary, Color(0xFF11A8E0)],
      ),
      borderRadius: BorderRadius.circular(38),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'YOUR IMPACT THIS YEAR',
          style: AppTextStyles.buttonMd.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _stat('\$147', 'Donated'),
            _stat('3', 'Causes'),
            _stat('est. 94', 'People helped'),
          ],
        ),
      ],
    ),
  );
  Widget _stat(String value, String label) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(value, style: AppTextStyles.h2.copyWith(color: Colors.white)),
      Text(label, style: AppTextStyles.bodySm.copyWith(color: Colors.white70)),
    ],
  );
}

class _Category extends StatelessWidget {
  const _Category(this.icon, this.label);
  final String icon, label;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 16),
    child: Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(25),
          ),
          alignment: Alignment.center,
          child: Text(icon, style: const TextStyle(fontSize: 32)),
        ),
        const SizedBox(height: 5),
        Text(label, style: AppTextStyles.caption),
      ],
    ),
  );
}
