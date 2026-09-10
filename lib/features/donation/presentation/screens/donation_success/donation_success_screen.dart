import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/features/donation/domain/entities/donation_receipt.dart';
import 'package:helpfundus/features/donation/presentation/screens/donation_receipt/donation_receipt_screen.dart';
import 'package:helpfundus/features/donation/presentation/screens/payment_status/widgets/payment_status_actions.dart';
import 'package:helpfundus/features/donation/presentation/screens/payment_status/widgets/payment_status_header.dart';
import 'package:helpfundus/features/donation/presentation/screens/payment_status/widgets/payment_transaction_summary.dart';
import 'package:helpfundus/features/donation/presentation/screens/widgets/donation_flow_scaffold.dart';
import 'package:helpfundus/features/donation/state/donation_controller.dart';

class DonationSuccessScreen extends StatelessWidget {
  const DonationSuccessScreen({
    super.key,
    this.controller,
    this.reference = 'HF-A3F8B2',
  });

  final DonationController? controller;
  final String reference;

  double get _amount => controller?.amount ?? 25;

  String get _method => switch (controller?.paymentMethod ?? 'Card') {
    'Card' => 'Credit / Debit Card',
    final method => method,
  };

  @override
  Widget build(BuildContext context) => DonationFlowScaffold(
    title: 'Payment Success',
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 36),
      child: Column(
        children: [
          const PaymentStatusHeader(
            icon: Icons.check_rounded,
            iconColor: AppColors.primary,
            title: 'Payment successful',
            message:
                'Thank you. Your donation has been confirmed and will help make an impact.',
          ),
          const SizedBox(height: 28),
          PaymentTransactionSummary(
            amount: _amount,
            fee: controller?.fee,
            total: controller?.total,
            method: _method,
            reference: reference,
            status: 'Successful',
            statusColor: AppColors.primary,
          ),
          const SizedBox(height: 28),
          PaymentStatusActions(
            primaryLabel: 'View receipt',
            onPrimary: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => DonationReceiptScreen(
                  receipt: DonationReceipt.forDonation(
                    amount: _amount,
                    paymentMethod: _method,
                    reference: reference,
                  ),
                ),
              ),
            ),
            secondaryLabel: 'Share campaign',
            onSecondary: () {},
            tertiaryLabel: 'Return home',
            onTertiary: () {},
          ),
        ],
      ),
    ),
  );
}
