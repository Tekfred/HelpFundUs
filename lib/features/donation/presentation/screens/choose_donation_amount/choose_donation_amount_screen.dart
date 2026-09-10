import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/features/donation/presentation/screens/choose_donation_amount/widgets/campaign_summary.dart';
import 'package:helpfundus/features/donation/presentation/screens/choose_donation_amount/widgets/amount_nudge_controls.dart';
import 'package:helpfundus/features/donation/presentation/screens/choose_donation_amount/widgets/custom_amount_input.dart';
import 'package:helpfundus/features/donation/presentation/screens/choose_donation_amount/widgets/donation_continue_button.dart';
import 'package:helpfundus/features/donation/presentation/screens/choose_donation_amount/widgets/donor_requirement_notice.dart';
import 'package:helpfundus/features/donation/presentation/screens/choose_donation_amount/widgets/fee_summary.dart';
import 'package:helpfundus/features/donation/presentation/screens/choose_donation_amount/widgets/suggested_amounts.dart';
import 'package:helpfundus/features/donation/presentation/screens/donation_details/donation_details_screen.dart';
import 'package:helpfundus/features/donation/presentation/screens/widgets/donation_flow_scaffold.dart';
import 'package:helpfundus/features/donation/state/donation_controller.dart';

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
  late final TextEditingController field = TextEditingController();

  @override
  void dispose() {
    field.dispose();
    controller.dispose();
    super.dispose();
  }

  void _selectSuggestedAmount(int amount) {
    setState(() {
      controller.setAmount(amount.toDouble());
      field.clear();
    });
  }

  void _updateCustomAmount(String value) {
    setState(() => controller.setAmount(double.tryParse(value) ?? 0));
  }

  void _nudgeAmount(int amount) {
    final updated = controller.amount + amount;
    setState(() {
      controller.setAmount(updated);
      field.text = updated.toStringAsFixed(
        updated.truncateToDouble() == updated ? 0 : 2,
      );
    });
  }

  void _continue() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DonationDetailsScreen(controller: controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => DonationFlowScaffold(
    title: 'Donate',
    bottomAction: DonationContinueButton(
      amount: controller.amount,
      enabled: controller.amountIsValid,
      onPressed: _continue,
    ),
    child: ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
      children: [
        CampaignSummary(
          title: widget.campaignTitle,
          emoji: widget.campaignEmoji,
          expanded: true,
        ),
        const SizedBox(height: 28),
        Text(
          'Choose an amount',
          style: AppTextStyles.h3.copyWith(fontSize: 22),
        ),
        const SizedBox(height: 14),
        SuggestedAmounts(
          selectedAmount: controller.amount,
          onSelected: _selectSuggestedAmount,
          expanded: true,
        ),
        const SizedBox(height: 24),
        Text(
          'Or enter a custom amount',
          style: AppTextStyles.h3.copyWith(fontSize: 19),
        ),
        const SizedBox(height: 12),
        CustomAmountInput(
          controller: field,
          hasValidationError:
              controller.amount != 0 && !controller.amountIsValid,
          onChanged: _updateCustomAmount,
        ),
        const SizedBox(height: 12),
        AmountNudgeControls(onAdd: _nudgeAmount),
        const SizedBox(height: 20),
        FeeSummary(fee: controller.fee),
        const SizedBox(height: 16),
        const DonorRequirementNotice(),
        const SizedBox(height: 12),
      ],
    ),
  );
}
