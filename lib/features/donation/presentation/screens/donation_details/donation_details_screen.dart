import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/features/donation/presentation/screens/choose_donation_amount/widgets/campaign_summary.dart';
import 'package:helpfundus/features/donation/presentation/screens/payment_method/payment_method_screen.dart';
import 'package:helpfundus/features/donation/presentation/screens/widgets/donation_flow_scaffold.dart';
import 'package:helpfundus/features/donation/state/donation_controller.dart';

class DonationDetailsScreen extends StatefulWidget {
  const DonationDetailsScreen({super.key, required this.controller});

  final DonationController controller;

  @override
  State<DonationDetailsScreen> createState() => _DonationDetailsScreenState();
}

class _DonationDetailsScreenState extends State<DonationDetailsScreen> {
  final _messageController = TextEditingController();
  bool _anonymous = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _continue() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentMethodScreen(controller: widget.controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => DonationFlowScaffold(
    title: 'Donation Details',
    bottomHorizontalPadding: 20,
    bottomAction: DonationPrimaryButton(
      label: 'Choose Payment Method',
      enabled: widget.controller.acceptedTerms,
      onPressed: _continue,
    ),
    child: ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      children: [
        const CampaignSummary(
          title: 'Help rebuild our community centre',
          emoji: '🏘️',
        ),
        const SizedBox(height: 16),
        _donationAmountCard(),
        const SizedBox(height: 18),
        Text(
          'DONOR INFORMATION',
          style: AppTextStyles.label.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: .5,
          ),
        ),
        const SizedBox(height: 12),
        _donorCard(),
        const SizedBox(height: 12),
        _anonymousToggle(),
        const SizedBox(height: 20),
        RichText(
          text: TextSpan(
            style: AppTextStyles.h3.copyWith(fontSize: 19),
            children: [
              const TextSpan(text: 'Add a message '),
              TextSpan(
                text: '(optional)',
                style: AppTextStyles.bodyMd.copyWith(fontSize: 18),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _messageController,
          maxLines: 3,
          maxLength: 200,
          style: AppTextStyles.bodyMd.copyWith(fontSize: 17),
          decoration: InputDecoration(
            hintText: 'Write a short message of support…',
            hintStyle: AppTextStyles.bodyMd.copyWith(fontSize: 17),
            counterStyle: AppTextStyles.caption.copyWith(fontSize: 13),
            contentPadding: const EdgeInsets.all(18),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Color(0xFFD2D6DF), width: 2),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
          ),
        ),
        const SizedBox(height: 15),
        _paymentSummary(),
        const SizedBox(height: 14),
        _termsToggle(),
        const SizedBox(height: 10),
      ],
    ),
  );

  Widget _donorCard() => _surface(
    child: const Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.primary,
          child: Text(
            'JD',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jane Doe',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 3),
              Text(
                'jane@example.com · Verified',
                style: TextStyle(fontSize: 15, color: Color(0xFF687386)),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _donationAmountCard() => _surface(
    padding: const EdgeInsets.fromLTRB(15, 13, 15, 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Donation amount',
          style: AppTextStyles.bodyMd.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 12),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '\$${widget.controller.amount.toStringAsFixed(2)}',
                style: AppTextStyles.h1.copyWith(
                  fontSize: 30,
                  color: AppColors.primary,
                ),
              ),
              TextSpan(
                text: ' USD',
                style: AppTextStyles.bodyMd.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _anonymousToggle() => _surface(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: Material(
      color: Colors.transparent,
      child: CheckboxListTile(
        value: _anonymous,
        onChanged: (value) => setState(() => _anonymous = value ?? false),
        dense: true,
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          'Make this donation anonymous',
          style: AppTextStyles.bodyMd.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );

  Widget _paymentSummary() => _surface(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment summary', style: AppTextStyles.h3.copyWith(fontSize: 18)),
        const SizedBox(height: 18),
        _summaryRow(
          'Donation',
          '\$${widget.controller.amount.toStringAsFixed(2)}',
        ),
        const SizedBox(height: 10),
        _summaryRow(
          'Platform fee (2.9%) · optional tip',
          '\$${widget.controller.fee.toStringAsFixed(2)}',
          muted: true,
        ),
        const Divider(height: 24),
        _summaryRow(
          'Total payable',
          '\$${widget.controller.total.toStringAsFixed(2)}',
          total: true,
        ),
      ],
    ),
  );

  Widget _termsToggle() => CheckboxListTile(
    value: widget.controller.acceptedTerms,
    onChanged: (value) =>
        setState(() => widget.controller.setTerms(value ?? false)),
    dense: true,
    contentPadding: EdgeInsets.zero,
    controlAffinity: ListTileControlAffinity.leading,
    title: RichText(
      text: TextSpan(
        style: AppTextStyles.bodyMd.copyWith(fontSize: 15, height: 1.42),
        children: const [
          TextSpan(text: 'I agree to the '),
          TextSpan(
            text: 'donation terms',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text:
                ' and confirm that I am authorised to use the selected payment method. Donations are non-refundable except in cases of verified fraud.',
          ),
        ],
      ),
    ),
  );

  Widget _surface({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(15),
  }) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(19),
    ),
    child: child,
  );

  Widget _summaryRow(
    String label,
    String value, {
    bool muted = false,
    bool total = false,
  }) => Row(
    children: [
      Expanded(
        child: Text(
          label,
          style: (total ? AppTextStyles.h3 : AppTextStyles.bodyMd).copyWith(
            fontSize: total ? 18 : 15,
          ),
        ),
      ),
      Text(
        value,
        style: TextStyle(
          color: total ? AppColors.primary : AppColors.textSecondary,
          fontSize: total ? 19 : 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}
