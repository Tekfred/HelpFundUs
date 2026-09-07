import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class MyDonationsScreen extends StatefulWidget {
  const MyDonationsScreen({super.key});
  @override
  State<MyDonationsScreen> createState() => _MyDonationsScreenState();
}

class _MyDonationsScreenState extends State<MyDonationsScreen> {
  String _filter = 'All';
  final _search = TextEditingController();
  static const _items = [
    (
      '🏥',
      "Medical expenses for Leah's treatment",
      'Aug 20, 2026 · 14:32',
      '\$100.00',
      'Completed',
    ),
    (
      '💧',
      'Clean water wells for Turkana County',
      'Aug 17, 2026 · 09:14',
      '\$25.00',
      'Completed',
    ),
    (
      '🏘️',
      'Help rebuild our community centre',
      'Aug 15, 2026 · 18:07',
      '\$50.00',
      'Pending',
    ),
    (
      '🍚',
      'Emergency food parcels — flood survivors',
      'Aug 10, 2026 · 11:55',
      '\$20.00',
      'Failed',
    ),
  ];
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filter == 'All'
        ? _items
        : _items.where((item) => item.$5 == _filter).toList();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 30),
          children: [
            _title(),
            const SizedBox(height: 18),
            _hero(),
            const SizedBox(height: 24),
            _searchInput(),
            const SizedBox(height: 16),
            _filters(),
            const SizedBox(height: 20),
            ...items.map(_card),
            if (items.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 48),
                child: Center(child: Text('No donations match this filter.')),
              ),
          ],
        ),
      ),
    );
  }

  Widget _title() => Row(
    children: [
      Container(
        width: 52,
        height: 52,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      const Spacer(),
      Text('My Donations', style: AppTextStyles.h2.copyWith(fontSize: 27)),
      const Spacer(),
      const SizedBox(width: 52),
    ],
  );
  Widget _hero() => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppColors.primary, Color(0xFF12A9D9)],
      ),
      borderRadius: BorderRadius.circular(32),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TOTAL DONATED',
          style: AppTextStyles.buttonMd.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              '\$125.00',
              style: AppTextStyles.h1.copyWith(
                fontSize: 42,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.favorite_border,
              size: 58,
              color: Color(0x88FFFFFF),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '2 successful donations',
          style: AppTextStyles.bodyLg.copyWith(color: Colors.white70),
        ),
      ],
    ),
  );
  Widget _searchInput() => TextField(
    controller: _search,
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.search, color: Color(0xFF9AA4B5)),
      hintText: 'Search donations...',
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFCBD1DB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFCBD1DB)),
      ),
    ),
  );
  Widget _filters() => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: ['All', 'Completed', 'Pending', 'Failed'].map((filter) {
        final selected = filter == _filter;
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: InkWell(
            onTap: () => setState(() => _filter = filter),
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.white,
                border: Border.all(
                  color: selected ? AppColors.primary : const Color(0xFFCBD1DB),
                ),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                filter,
                style: AppTextStyles.buttonMd.copyWith(
                  fontSize: 14,
                  color: selected ? Colors.white : const Color(0xFF697487),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
  Widget _card((String, String, String, String, String) item) {
    final done = item.$5 == 'Completed';
    final pending = item.$5 == 'Pending';
    final color = done
        ? AppColors.primary
        : pending
        ? AppColors.warning
        : AppColors.danger;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7859F5), Color(0xFF3984ED)],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(item.$1, style: const TextStyle(fontSize: 29)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.$2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.buttonMd.copyWith(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item.$3,
                  style: AppTextStyles.caption.copyWith(
                    color: const Color(0xFF9AA4B5),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '◉  ${item.$5}',
                    style: AppTextStyles.caption.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.$4,
                style: AppTextStyles.buttonMd.copyWith(
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
              if (done) const SizedBox(height: 12),
              if (done)
                Text(
                  '▣  Receipt',
                  style: AppTextStyles.caption.copyWith(
                    color: const Color(0xFF697487),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
