import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/features/donation/domain/entities/donation_record.dart';
import 'package:helpfundus/features/donation/presentation/screens/donation_detail/widgets/donation_amount_header.dart';
import 'package:helpfundus/features/donation/presentation/screens/donation_detail/widgets/donation_campaign_card.dart';
import 'package:helpfundus/features/donation/presentation/screens/donation_detail/widgets/donation_detail_actions.dart';
import 'package:helpfundus/features/donation/presentation/screens/donation_detail/widgets/donation_payment_details_card.dart';
import 'package:helpfundus/features/donation/presentation/screens/donation_receipt/donation_receipt_screen.dart';

class DonationDetailScreen extends StatelessWidget {
  const DonationDetailScreen({super.key, required this.donation});

  final DonationRecord donation;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.appBackground,
    body: SafeArea(
      child: Column(
        children: [
          _Header(onBack: () => Navigator.of(context).pop()),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                children: [
                  DonationAmountHeader(donation: donation),
                  const SizedBox(height: 28),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'CAMPAIGN',
                      style: AppTextStyles.label.copyWith(
                        fontSize: 14,
                        color: context.appTextMuted,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DonationCampaignCard(donation: donation),
                  const SizedBox(height: 14),
                  _ViewCampaignButton(onPressed: () {}),
                  const SizedBox(height: 20),
                  DonationPaymentDetailsCard(donation: donation),
                  const SizedBox(height: 16),
                  DonationDetailActions(
                    onContactSupport: () {},
                    onViewReceipt: donation.status == DonationStatus.completed
                        ? () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => DonationReceiptScreen(
                                receipt: donation.receipt!,
                              ),
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _ViewCampaignButton extends StatelessWidget {
  const _ViewCampaignButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 56,
    child: OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.open_in_new_rounded, size: 20),
      label: Text(
        'View campaign',
        style: AppTextStyles.buttonMd.copyWith(
          fontSize: 16,
          color: context.appTextPrimary,
        ),
      ),
    ),
  );
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 8, 20, 6),
    child: SizedBox(
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Material(
              color: context.appSurface,
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
          Text(
            'Donation Detail',
            style: AppTextStyles.h2.copyWith(
              fontSize: 23,
              color: context.appTextPrimary,
            ),
          ),
        ],
      ),
    ),
  );
}
