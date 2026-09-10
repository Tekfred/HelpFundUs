import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/features/donation/presentation/screens/payment_status/widgets/payment_status_header.dart';
import 'package:helpfundus/features/donation/presentation/screens/payment_status/widgets/payment_transaction_summary.dart';
import 'package:helpfundus/features/donation/presentation/screens/payment_status/widgets/payment_warning_card.dart';
import 'package:helpfundus/features/donation/presentation/screens/widgets/donation_flow_scaffold.dart';
import 'package:helpfundus/features/donation/state/donation_controller.dart';

class PaymentProcessingScreen extends StatelessWidget {
  const PaymentProcessingScreen({super.key, required this.controller});

  final DonationController controller;

  String get _displayMethod => switch (controller.paymentMethod) {
    'Card' => 'Credit / Debit Card',
    _ => controller.paymentMethod,
  };

  @override
  Widget build(BuildContext context) => DonationFlowScaffold(
    title: 'Processing Payment',
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 36),
      child: Column(
        children: [
          const PaymentStatusHeader(
            icon: Icons.lock_outline_rounded,
            iconColor: AppColors.primary,
            title: 'Processing your payment',
            message:
                'Please wait while we securely confirm your payment. This usually takes only a moment.',
            showProgress: true,
          ),
          const SizedBox(height: 28),
          PaymentTransactionSummary(
            amount: controller.amount,
            fee: controller.fee,
            total: controller.total,
            method: _displayMethod,
            reference: 'HF-A3F8B2',
            status: 'Processing',
            statusColor: AppColors.primary,
          ),
          const SizedBox(height: 20),
          const PaymentWarningCard(
            title: 'Keep this screen open',
            message:
                'Do not close the app, refresh, or press back while your payment is being processed.',
            backgroundColor: Color(0xFFFFF1C6),
            color: Color(0xFFDB7A00),
          ),
        ],
      ),
    ),
  );
}
