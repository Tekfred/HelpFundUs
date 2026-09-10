import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/features/donation/data/donation_catalog.dart';
import 'package:helpfundus/features/donation/domain/entities/donation_record.dart';
import 'package:helpfundus/features/donation/presentation/screens/donation_detail/donation_detail_screen.dart';
import 'package:helpfundus/features/donation/presentation/screens/my_donations/widgets/donation_filter_chips.dart';
import 'package:helpfundus/features/donation/presentation/screens/my_donations/widgets/donation_list_card.dart';
import 'package:helpfundus/features/donation/presentation/screens/my_donations/widgets/donation_search_field.dart';
import 'package:helpfundus/features/donation/presentation/screens/my_donations/widgets/donation_summary_card.dart';

class MyDonationsScreen extends StatefulWidget {
  const MyDonationsScreen({super.key});

  @override
  State<MyDonationsScreen> createState() => _MyDonationsScreenState();
}

class _MyDonationsScreenState extends State<MyDonationsScreen> {
  String _filter = 'All';
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<DonationRecord> get _visibleDonations {
    final query = _search.text.trim().toLowerCase();
    return DonationCatalog.donations.where((donation) {
      final matchesFilter =
          _filter == 'All' || donation.status.label == _filter;
      final matchesQuery =
          query.isEmpty ||
          donation.campaignTitle.toLowerCase().contains(query) ||
          donation.reference.toLowerCase().contains(query);
      return matchesFilter && matchesQuery;
    }).toList();
  }

  void _openDonation(DonationRecord donation) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DonationDetailScreen(donation: donation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final donations = _visibleDonations;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
          children: [
            _Header(onBack: () => Navigator.of(context).pop()),
            const SizedBox(height: 14),
            const DonationSummaryCard(donations: DonationCatalog.donations),
            const SizedBox(height: 18),
            DonationSearchField(
              controller: _search,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            DonationFilterChips(
              selected: _filter,
              onSelected: (filter) => setState(() => _filter = filter),
            ),
            const SizedBox(height: 16),
            ...donations.map(
              (donation) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DonationListCard(
                  donation: donation,
                  onTap: () => _openDonation(donation),
                ),
              ),
            ),
            if (donations.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 36),
                child: Text(
                  'No donations match this filter.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMd,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 48,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Material(
            color: Colors.white,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onBack,
              customBorder: const CircleBorder(),
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Icon(Icons.arrow_back_ios_new_rounded, size: 19),
              ),
            ),
          ),
        ),
        Text('My Donations', style: AppTextStyles.h2.copyWith(fontSize: 23)),
      ],
    ),
  );
}
