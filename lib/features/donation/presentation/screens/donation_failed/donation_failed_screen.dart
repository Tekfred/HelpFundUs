import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/features/donation/presentation/screens/payment_status/widgets/payment_status_actions.dart';
import 'package:helpfundus/features/donation/presentation/screens/payment_status/widgets/payment_status_header.dart';
import 'package:helpfundus/features/donation/presentation/screens/payment_status/widgets/payment_transaction_summary.dart';
import 'package:helpfundus/features/donation/presentation/screens/payment_status/widgets/payment_warning_card.dart';
import 'package:helpfundus/features/donation/presentation/screens/widgets/donation_flow_scaffold.dart';
import 'package:helpfundus/features/donation/state/donation_controller.dart';

class DonationFailedScreen extends StatelessWidget {
  const DonationFailedScreen({
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
    title: 'Payment Failed',
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 36),
      child: Column(
        children: [
          const PaymentStatusHeader(
            icon: Icons.close_rounded,
            iconColor: AppColors.danger,
            title: 'Payment unsuccessful',
            message:
                'We could not complete your payment. No donation has been confirmed yet.',
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: AppColors.danger.withValues(alpha: .22),
              borderRadius: BorderRadius.circular(25),
            ),
            child: PaymentTransactionSummary(
              amount: _amount,
              method: _method,
              reference: reference,
              status: 'Failed',
              statusColor: AppColors.danger,
            ),
          ),
          const SizedBox(height: 20),
          const PaymentWarningCard(
            title: 'Were you charged?',
            message:
                'If a charge appears in your account, do not try again yet. Contact support so we can help confirm its status.',
            backgroundColor: Color(0xFFFFF1C6),
            color: Color(0xFFDB7A00),
          ),
          const SizedBox(height: 20),
          const _FailureReasonsCard(),
          const SizedBox(height: 28),
          PaymentStatusActions(
            primaryLabel: 'Try again',
            onPrimary: () {},
            secondaryLabel: 'Change method',
            onSecondary: () {},
            tertiaryLabel: 'Support',
            onTertiary: () {},
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Return home',
              style: AppTextStyles.buttonMd.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _FailureReasonsCard extends StatelessWidget {
  const _FailureReasonsCard();

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
          'Common reasons for failure',
          style: AppTextStyles.h3.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 13),
        const _Reason('Insufficient funds or wallet balance'),
        const SizedBox(height: 9),
        const _Reason('Card declined by your bank'),
        const SizedBox(height: 9),
        const _Reason('Incorrect PIN or authentication timeout'),
        const SizedBox(height: 9),
        const _Reason('Network error during payment'),
      ],
    ),
  );
}

class _Reason extends StatelessWidget {
  const _Reason(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(top: 6),
        child: Icon(Icons.circle, size: 6, color: AppColors.danger),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Text(text, style: AppTextStyles.bodyMd.copyWith(fontSize: 14)),
      ),
    ],
  );
}
