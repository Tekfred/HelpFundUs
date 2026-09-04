import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/campaign_card.dart';

class CampaignsScreen extends StatelessWidget {
  const CampaignsScreen({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(24, 30, 24, 112),
    children: [
      Row(
        children: [
          Text('My campaigns', style: AppTextStyles.h1),
          const Spacer(),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Create'),
          ),
        ],
      ),
      const SizedBox(height: 24),
      const CampaignCard(
        title: 'Help rebuild our community centre',
        category: 'Active',
        amount: '\$14,400',
        progress: .72,
        location: 'Lagos, Nigeria',
      ),
      const SizedBox(height: 24),
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Draft · School supplies for 200 children',
              style: AppTextStyles.buttonMd,
            ),
            const SizedBox(height: 8),
            Text('Last edited yesterday', style: AppTextStyles.bodyMd),
            const SizedBox(height: 16),
            Row(
              children: [
                OutlinedButton(onPressed: () {}, child: const Text('Edit')),
                const SizedBox(width: 12),
                FilledButton(onPressed: () {}, child: const Text('Submit')),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 30),
      Text('Lifetime impact', style: AppTextStyles.h3),
      const SizedBox(height: 14),
      Row(
        children: [
          _tile('\$24.8k', 'Raised'),
          _tile('391', 'Donors'),
          _tile('3', 'Campaigns'),
        ],
      ),
    ],
  );
  static Widget _tile(String value, String label) => Expanded(
    child: Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.buttonMd.copyWith(color: AppColors.primary),
          ),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    ),
  );
}
