import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/features/donation/presentation/screens/payment_authorization/widgets/payment_security_notice.dart';
import 'package:helpfundus/features/donation/presentation/screens/payment_authorization/widgets/payment_summary_card.dart';
import 'package:helpfundus/features/donation/presentation/screens/payment_authorization/widgets/secure_handoff_intro.dart';
import 'package:helpfundus/features/donation/presentation/screens/payment_processing/payment_processing_screen.dart';
import 'package:helpfundus/features/donation/presentation/screens/widgets/donation_flow_scaffold.dart';
import 'package:helpfundus/features/donation/state/donation_controller.dart';

class PaymentAuthorizationScreen extends StatelessWidget {
  const PaymentAuthorizationScreen({super.key, required this.controller});

  final DonationController controller;

  String get _displayMethod => switch (controller.paymentMethod) {
    'Card' => 'Credit / Debit Card',
    _ => controller.paymentMethod,
  };

  void _authorise(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentProcessingScreen(controller: controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => DonationFlowScaffold(
    title: 'Secure Payment',
    bottomAction: DonationPrimaryButton(
      label: 'Authorise payment — \$${controller.total.toStringAsFixed(2)}',
      enabled: true,
      onPressed: () => _authorise(context),
    ),
    bottomSecondaryAction: TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Text(
        'Cancel payment',
        style: AppTextStyles.buttonMd.copyWith(
          color: AppColors.textSecondary,
          fontSize: 16,
        ),
      ),
    ),
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 48),
      child: Column(
        children: [
          SecureHandoffIntro(paymentMethod: _displayMethod),
          const SizedBox(height: 32),
          PaymentSummaryCard(
            amount: controller.amount,
            fee: controller.fee,
            total: controller.total,
            method: _displayMethod,
            reference: 'HF-A3F8B2',
          ),
          const SizedBox(height: 24),
          const PaymentSecurityNotice(
            message:
                'HelpFundUs never stores card numbers, PINs, or mobile-money credentials. All sensitive payment data is handled exclusively by our PCI-DSS certified payment partners.',
            backgroundColor: Color(0xFFFFEFC2),
            iconColor: Color(0xFFDB7A00),
            textColor: AppColors.textSecondary,
          ),
          const SizedBox(height: 24),
          const PaymentSecurityNotice(
            message:
                'Do not close this app or press the back button while payment is in progress. Doing so may result in a failed transaction or delayed confirmation.',
            backgroundColor: Color(0xFFFFF5ED),
            iconColor: Color(0xFFD85B16),
            textColor: Color(0xFF8B2B10),
          ),
        ],
      ),
    ),
  );
}
