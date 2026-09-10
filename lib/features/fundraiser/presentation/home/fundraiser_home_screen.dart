import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_dimens.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';

class FundraiserHomeScreen extends StatelessWidget {
  const FundraiserHomeScreen({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 26, 20, 112),
    children: [
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fundraiser home', style: AppTextStyles.h1),
                Text(
                  'KYC verified ✓',
                  style: AppTextStyles.buttonMd.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('New'),
          ),
        ],
      ),
      const SizedBox(height: 18),
      _alert(),
      const SizedBox(height: 16),
      Row(
        children: [
          _stat('\$24.8k', 'Total raised'),
          _stat('2', 'Active'),
          _stat('\$4,680', 'Available'),
        ],
      ),
      const SizedBox(height: 22),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Help rebuild our community centre', style: AppTextStyles.h3),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: const LinearProgressIndicator(
                value: .72,
                minHeight: 8,
                color: AppColors.primary,
                backgroundColor: Color(0xFFE2E6EB),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$14,400 raised of \$20,000 · 248 donors',
              style: AppTextStyles.bodyMd,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton(onPressed: () {}, child: const Text('Manage')),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Performance'),
                ),
                OutlinedButton(onPressed: () {}, child: const Text('Share')),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFF0E9FF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.account_balance_wallet_outlined,
              color: Color(0xFF7542D8),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '\$4,680 available for payout',
                style: AppTextStyles.buttonMd,
              ),
            ),
            TextButton(onPressed: () {}, child: const Text('Request')),
          ],
        ),
      ),
      const SizedBox(height: 26),
      Text('Recent donors', style: AppTextStyles.h3),
      ...[
        'Ama Mensah donated \$50 · Ghana',
        'Marcus Thompson donated \$25 · Nigeria',
        'Anonymous donated \$100 · Kenya',
      ].map(
        (text) => ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const CircleAvatar(
            backgroundColor: Color(0xFFE2F7EA),
            child: Icon(Icons.favorite, color: AppColors.primary),
          ),
          title: Text(text, style: AppTextStyles.buttonMd),
          subtitle: const Text('Today'),
        ),
      ),
    ],
  );
  Widget _stat(String value, String label) => Expanded(
    child: Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
  Widget _alert() => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.warning.withValues(alpha: .12),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        const Icon(Icons.pending_outlined, color: AppColors.warning),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('1 campaign is under review', style: AppTextStyles.buttonMd),
              Text(
                'We’ll notify you when it is ready to publish.',
                style: AppTextStyles.bodySm,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
