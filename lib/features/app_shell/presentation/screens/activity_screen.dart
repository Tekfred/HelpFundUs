import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../donation/presentation/screens/my_donations_screen.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});
  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String _filter = 'All';
  final _items = const [
    (
      '💚',
      'You donated \$25',
      'Clean water wells for Turkana County',
      '2h ago',
    ),
    (
      '📣',
      'Campaign update posted',
      'Plant trees across urban schools',
      'Yesterday',
    ),
    (
      '🧾',
      'Receipt #HF-A3F8B2',
      '\$100 donation · Tax deductible',
      '2 days ago',
    ),
    ('💚', 'You donated \$100', 'Medical expenses for Leah', '5 days ago'),
    ('📣', 'New milestone reached', 'Help rebuild — 70% funded!', '1 wk ago'),
  ];
  @override
  Widget build(BuildContext context) {
    final visibleItems = _items.where((item) {
      if (_filter == 'All') return true;
      if (_filter == 'Donations') return item.$2.startsWith('You donated');
      if (_filter == 'Updates') {
        return item.$2.contains('update') || item.$2.contains('milestone');
      }
      return item.$2.startsWith('Receipt');
    });
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 112),
      children: [
        Row(
          children: [
            Text('Activity', style: AppTextStyles.h2.copyWith(fontSize: 27)),
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
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F7ED),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '↻  My Donations',
                  style: AppTextStyles.buttonMd.copyWith(
                    fontSize: 14,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['All', 'Donations', 'Updates', 'Receipts']
                .map(
                  (filter) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () => setState(() => _filter = filter),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
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
                            fontSize: 14,
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
        const SizedBox(height: 24),
        ...visibleItems.map(
          (item) => Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE0E4E8))),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(item.$1, style: const TextStyle(fontSize: 28)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.$2,
                        style: AppTextStyles.buttonMd.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.$3,
                        style: AppTextStyles.bodyMd.copyWith(
                          fontSize: 15,
                          color: const Color(0xFF6B7587),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  item.$4,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 13,
                    color: const Color(0xFF9AA4B5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
