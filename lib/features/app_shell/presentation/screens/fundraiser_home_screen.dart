import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class FundraiserHomeScreen extends StatelessWidget {
  const FundraiserHomeScreen({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(24, 30, 24, 112),
    children: [
      Text('Your fundraising', style: AppTextStyles.h1),
      const SizedBox(height: 7),
      Text('Here’s how your causes are growing.', style: AppTextStyles.bodyLg),
      const SizedBox(height: 28),
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Help rebuild our community centre', style: AppTextStyles.h3),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: const LinearProgressIndicator(
                value: .72,
                minHeight: 8,
                backgroundColor: Color(0xFFE2E6EB),
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '\$14,400 raised of \$20,000 · 72%',
              style: AppTextStyles.buttonMd.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _number('248', 'Donors'),
                _number('12', 'Shares'),
                _number('4d', 'Left'),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 28),
      Text('Recent donors', style: AppTextStyles.h3),
      const SizedBox(height: 12),
      ...[
        'Ama Mensah donated \$50',
        'Marcus Thompson donated \$25',
        'Anonymous donated \$100',
      ].map(
        (item) => ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const CircleAvatar(
            backgroundColor: Color(0xFFE2F7EA),
            child: Icon(Icons.favorite, color: AppColors.primary),
          ),
          title: Text(item, style: AppTextStyles.buttonMd),
          subtitle: Text('Today', style: AppTextStyles.bodySm),
        ),
      ),
    ],
  );
  static Widget _number(String n, String l) => Column(
    children: [
      Text(n, style: AppTextStyles.h3),
      Text(l, style: AppTextStyles.bodySm),
    ],
  );
}
