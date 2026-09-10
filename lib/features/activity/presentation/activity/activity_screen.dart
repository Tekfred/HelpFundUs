import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/features/donation/data/donation_receipt_catalog.dart';
import 'package:helpfundus/features/donation/domain/entities/donation_receipt.dart';
import 'package:helpfundus/features/donation/presentation/screens/donation_receipt/donation_receipt_screen.dart';
import 'package:helpfundus/features/donation/presentation/screens/my_donations/my_donations_screen.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});
  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String _filter = 'All';
  final _items = [
    const _ActivityItem(
      emoji: '💚',
      title: 'You donated \$25',
      subtitle: 'Clean water wells for Turkana County',
      timestamp: '2h ago',
    ),
    const _ActivityItem(
      emoji: '📣',
      title: 'Campaign update posted',
      subtitle: 'Plant trees across urban schools',
      timestamp: 'Yesterday',
    ),
    _ActivityItem(
      emoji: '🧾',
      title: 'Receipt #${DonationReceiptCatalog.activityReceipt.reference}',
      subtitle:
          '\$${DonationReceiptCatalog.activityReceipt.amount.toStringAsFixed(0)} donation · Tax deductible',
      timestamp: '2 days ago',
      receipt: DonationReceiptCatalog.activityReceipt,
    ),
    const _ActivityItem(
      emoji: '💚',
      title: 'You donated \$100',
      subtitle: 'Medical expenses for Leah',
      timestamp: '5 days ago',
    ),
    const _ActivityItem(
      emoji: '📣',
      title: 'New milestone reached',
      subtitle: 'Help rebuild — 70% funded!',
      timestamp: '1 wk ago',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final visibleItems = _items.where((item) {
      if (_filter == 'All') return true;
      if (_filter == 'Donations') return item.title.startsWith('You donated');
      if (_filter == 'Updates') {
        return item.title.contains('update') ||
            item.title.contains('milestone');
      }
      return item.title.startsWith('Receipt');
    });
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 112),
      children: [
        Row(
          children: [
            Text('Activity', style: AppTextStyles.h2.copyWith(fontSize: 24)),
            const Spacer(),
            InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const MyDonationsScreen(),
                ),
              ),
              borderRadius: BorderRadius.circular(999),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F7ED),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '↻  My Donations',
                  style: AppTextStyles.buttonMd.copyWith(
                    fontSize: 12,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['All', 'Donations', 'Updates', 'Receipts']
                .map(
                  (filter) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => setState(() => _filter = filter),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: filter == _filter
                              ? AppColors.primary
                              : Colors.white,
                          border: Border.all(
                            color: filter == _filter
                                ? AppColors.primary
                                : const Color(0xFFCBD1DB),
                          ),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          filter,
                          style: AppTextStyles.buttonMd.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: filter == _filter
                                ? Colors.white
                                : const Color(0xFF697487),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 16),
        ...visibleItems.map(
          (item) => Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: item.receipt == null
                  ? null
                  : () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            DonationReceiptScreen(receipt: item.receipt!),
                      ),
                    ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFE0E4E8))),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        item.emoji,
                        style: const TextStyle(fontSize: 23),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: AppTextStyles.buttonMd.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.subtitle,
                            style: AppTextStyles.bodyMd.copyWith(
                              fontSize: 14,
                              color: const Color(0xFF6B7587),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      item.timestamp,
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 12,
                        color: const Color(0xFF9AA4B5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActivityItem {
  const _ActivityItem({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    this.receipt,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final String timestamp;
  final DonationReceipt? receipt;
}
