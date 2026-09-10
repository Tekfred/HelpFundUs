import 'package:flutter/material.dart';
import 'package:helpfundus/features/donation/presentation/screens/widgets/donation_flow_scaffold.dart';

class DonationContinueButton extends StatelessWidget {
  const DonationContinueButton({
    super.key,
    required this.amount,
    required this.enabled,
    required this.onPressed,
  });

  final double amount;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => DonationPrimaryButton(
    label: enabled
        ? 'Continue — \$${amount.toStringAsFixed(2)} USD'
        : 'Continue',
    enabled: enabled,
    onPressed: onPressed,
  );
}
