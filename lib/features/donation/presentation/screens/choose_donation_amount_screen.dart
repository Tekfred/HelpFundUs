import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../state/donation_controller.dart';

class ChooseDonationAmountScreen extends StatefulWidget {
  const ChooseDonationAmountScreen({
    super.key,
    this.campaignTitle = 'Help rebuild our community centre',
    this.campaignEmoji = '🏘️',
  });
  final String campaignTitle;
  final String campaignEmoji;
  @override
  State<ChooseDonationAmountScreen> createState() =>
      _ChooseDonationAmountScreenState();
}

class _ChooseDonationAmountScreenState
    extends State<ChooseDonationAmountScreen> {
  final controller = DonationController();
  late final TextEditingController field = TextEditingController(text: '25');
  @override
  void dispose() {
    field.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    appBar: AppBar(
      backgroundColor: AppColors.background,
      title: const Text('Make a donation'),
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Text(widget.campaignEmoji, style: const TextStyle(fontSize: 34)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.campaignTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text('Choose your amount', style: AppTextStyles.h2),
        const SizedBox(height: 8),
        Text(
          'USD · Minimum \$5 · Maximum \$10,000',
          style: AppTextStyles.bodyMd,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [10, 25, 50, 100, 250, 500]
              .map(
                (amount) => ChoiceChip(
                  label: Text('\$$amount'),
                  selected: controller.amount == amount,
                  onSelected: (_) => setState(() {
                    controller.setAmount(amount.toDouble());
                    field.text = '$amount';
                  }),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: controller.amount == amount
                        ? Colors.white
                        : AppColors.textPrimary,
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 18),
        TextField(
          controller: field,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) =>
              setState(() => controller.setAmount(double.tryParse(value) ?? 0)),
          decoration: InputDecoration(
            prefixText: '\$ ',
            suffixText: 'USD',
            labelText: 'Custom amount',
            errorText: controller.amount == 0 || controller.amountIsValid
                ? null
                : 'Enter an amount from \$5 to \$10,000',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'A 2.9% processing fee (\$${controller.fee.toStringAsFixed(2)}) will be added at checkout.',
          style: AppTextStyles.bodySm,
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFE2F7EA),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Text(
            'You’re donating as Jane Doe. Donations require an authenticated donor account.',
          ),
        ),
        const SizedBox(height: 26),
        FilledButton(
          onPressed: controller.amountIsValid
              ? () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        DonationDetailsScreen(controller: controller),
                  ),
                )
              : null,
          child: Text('Continue — \$${controller.amount.toStringAsFixed(2)}'),
        ),
      ],
    ),
  );
}

class DonationDetailsScreen extends StatelessWidget {
  const DonationDetailsScreen({super.key, required this.controller});
  final DonationController controller;
  @override
  Widget build(BuildContext context) => _DonationPage(
    title: 'Donation details',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Help rebuild our community centre', style: AppTextStyles.h3),
        const SizedBox(height: 16),
        _row('Donation amount', '\$${controller.amount.toStringAsFixed(2)}'),
        _row('Processing fee', '\$${controller.fee.toStringAsFixed(2)}'),
        _row(
          'Total payable',
          '\$${controller.total.toStringAsFixed(2)}',
          strong: true,
        ),
        const SizedBox(height: 16),
        const Text('Donor: Jane Doe'),
        const SizedBox(height: 12),
        const TextField(
          maxLines: 3,
          maxLength: 200,
          decoration: InputDecoration(
            labelText: 'Message to the fundraiser (optional)',
            border: OutlineInputBorder(),
          ),
        ),
        CheckboxListTile(
          value: controller.acceptedTerms,
          onChanged: (value) {
            controller.setTerms(value ?? false);
            (context as Element).markNeedsBuild();
          },
          title: const Text('I agree to the donation terms and privacy policy'),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        FilledButton(
          onPressed: controller.acceptedTerms
              ? () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentMethodScreen(controller: controller),
                  ),
                )
              : null,
          child: const Text('Continue to payment'),
        ),
      ],
    ),
  );
}

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key, required this.controller});
  final DonationController controller;
  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  @override
  Widget build(BuildContext context) => _DonationPage(
    title: 'Payment method',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Available in your region', style: AppTextStyles.bodyMd),
        const SizedBox(height: 10),
        ...['Card', 'Mobile Money', 'Bank transfer', 'HelpFundUs Wallet'].map(
          (method) => RadioListTile<String>(
            value: method,
            groupValue: widget.controller.paymentMethod,
            onChanged: (v) => setState(() => widget.controller.setMethod(v!)),
            title: Text(method),
            subtitle: Text(
              method == 'Card'
                  ? '2.9% fee · processed securely'
                  : 'Available payment channel',
            ),
          ),
        ),
        const SizedBox(height: 18),
        FilledButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  PaymentAuthorizationScreen(controller: widget.controller),
            ),
          ),
          child: Text('Pay \$${widget.controller.total.toStringAsFixed(2)}'),
        ),
      ],
    ),
  );
}

class PaymentAuthorizationScreen extends StatelessWidget {
  const PaymentAuthorizationScreen({super.key, required this.controller});
  final DonationController controller;
  @override
  Widget build(BuildContext context) => _DonationPage(
    title: 'Secure payment',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Icon(Icons.lock_outline, size: 48, color: AppColors.primary),
        ),
        const SizedBox(height: 16),
        const Text(
          'You are being securely handed off to your payment provider.',
        ),
        const SizedBox(height: 16),
        _row('Campaign', 'Community centre'),
        _row('Method', controller.paymentMethod),
        _row('Reference', 'HF-A3F8B2'),
        _row('Total', '\$${controller.total.toStringAsFixed(2)}', strong: true),
        const SizedBox(height: 16),
        const Text(
          'Do not close this process until the provider returns you to HelpFundUs.',
          style: TextStyle(color: AppColors.warning),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PaymentProcessingScreen(controller: controller),
            ),
          ),
          child: const Text('Open secure provider'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel payment'),
        ),
      ],
    ),
  );
}

class PaymentProcessingScreen extends StatelessWidget {
  const PaymentProcessingScreen({super.key, required this.controller});
  final DonationController controller;
  @override
  Widget build(BuildContext context) => _DonationPage(
    title: 'Verifying payment',
    child: Column(
      children: [
        const SizedBox(height: 20),
        const CircularProgressIndicator(),
        const SizedBox(height: 24),
        Text('We’re verifying your payment', style: AppTextStyles.h3),
        const SizedBox(height: 8),
        const Text(
          'This can take a moment. Please don’t submit another payment.',
        ),
        const SizedBox(height: 16),
        const Text('Reference: HF-A3F8B2'),
        const SizedBox(height: 24),
        OutlinedButton(onPressed: () {}, child: const Text('Check status')),
      ],
    ),
  );
}

class _DonationPage extends StatelessWidget {
  const _DonationPage({required this.title, required this.child});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    appBar: AppBar(backgroundColor: AppColors.background, title: Text(title)),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: child,
          ),
        ],
      ),
    ),
  );
}

Widget _row(String left, String right, {bool strong = false}) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 7),
  child: Row(
    children: [
      Text(left),
      const Spacer(),
      Text(
        right,
        style: strong ? const TextStyle(fontWeight: FontWeight.w700) : null,
      ),
    ],
  ),
);
