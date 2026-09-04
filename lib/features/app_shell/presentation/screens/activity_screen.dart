import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

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
  ];
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(24, 30, 24, 112),
    children: [
      Row(
        children: [
          Text('Activity', style: AppTextStyles.h1),
          const Spacer(),
          Text(
            '↻  My Donations',
            style: AppTextStyles.buttonMd.copyWith(color: AppColors.primary),
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
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: filter == _filter,
                    onSelected: (_) => setState(() => _filter = filter),
                    selectedColor: AppColors.primary,
                    labelStyle: AppTextStyles.buttonMd.copyWith(
                      color: filter == _filter
                          ? Colors.white
                          : const Color(0xFF6B7587),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
      const SizedBox(height: 24),
      ..._items.map(
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
                    Text(item.$2, style: AppTextStyles.h3),
                    const SizedBox(height: 5),
                    Text(item.$3, style: AppTextStyles.bodyLg),
                  ],
                ),
              ),
              Text(item.$4, style: AppTextStyles.bodySm),
            ],
          ),
        ),
      ),
    ],
  );
}
