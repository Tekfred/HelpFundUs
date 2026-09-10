import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/features/donation/presentation/screens/payment_status/widgets/payment_status_actions.dart';
import 'package:helpfundus/features/donation/presentation/screens/payment_status/widgets/payment_status_header.dart';
import 'package:helpfundus/features/donation/presentation/screens/payment_status/widgets/payment_transaction_summary.dart';
import 'package:helpfundus/features/donation/presentation/screens/payment_status/widgets/payment_warning_card.dart';
import 'package:helpfundus/features/donation/presentation/screens/widgets/donation_flow_scaffold.dart';
import 'package:helpfundus/features/donation/state/donation_controller.dart';

class DonationPendingScreen extends StatelessWidget {
  const DonationPendingScreen({
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
    title: 'Payment Pending',
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 36),
      child: Column(
        children: [
          const PaymentStatusHeader(
            icon: Icons.schedule_rounded,
            iconColor: AppColors.warning,
            title: 'Payment under review',
            message:
                'We are waiting for confirmation from your payment provider. This can take a few minutes.',
          ),
          const SizedBox(height: 28),
          PaymentTransactionSummary(
            amount: _amount,
            method: _method,
            reference: reference,
            status: 'Pending',
            statusColor: AppColors.warning,
          ),
          const SizedBox(height: 20),
          const PaymentWarningCard(
            title: 'Do not make a second payment',
            message:
                'Your payment may still complete. Making another payment could result in a duplicate donation.',
            backgroundColor: Color(0xFFFFF1C6),
            color: Color(0xFFDB7A00),
          ),
          const SizedBox(height: 20),
          const _WhatHappensNextCard(),
          const SizedBox(height: 28),
          PaymentStatusActions(
            primaryLabel: 'Refresh status',
            onPrimary: () {},
            secondaryLabel: 'Contact support',
            onSecondary: () {},
            tertiaryLabel: 'Home',
            onTertiary: () {},
          ),
        ],
      ),
    ),
  );
}

class _WhatHappensNextCard extends StatelessWidget {
  const _WhatHappensNextCard();

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What happens next?',
          style: AppTextStyles.h3.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 14),
        const _NextStep(
          number: '1',
          text: 'Your payment provider confirms the transaction.',
        ),
        const SizedBox(height: 12),
        const _NextStep(
          number: '2',
          text: 'We update your donation status automatically.',
        ),
        const SizedBox(height: 12),
        const _NextStep(
          number: '3',
          text: 'Your receipt becomes available once confirmed.',
        ),
      ],
    ),
  );
}

class _NextStep extends StatelessWidget {
  const _NextStep({required this.number, required this.text});

  final String number;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: Text(
          number,
          style: AppTextStyles.buttonMd.copyWith(
            color: Colors.white,
            fontSize: 13,
          ),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Text(text, style: AppTextStyles.bodyMd.copyWith(fontSize: 14)),
      ),
    ],
  );
}
