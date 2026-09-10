import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/features/donation/presentation/screens/choose_donation_amount/widgets/campaign_summary.dart';
import 'package:helpfundus/features/donation/presentation/screens/payment_authorization/payment_authorization_screen.dart';
import 'package:helpfundus/features/donation/presentation/screens/widgets/donation_flow_scaffold.dart';
import 'package:helpfundus/features/donation/state/donation_controller.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key, required this.controller});

  final DonationController controller;

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  static const _methods = [
    _PaymentMethod(
      'Card',
      'Credit / Debit Card',
      'Visa, Mastercard, Amex',
      '2.9% fee',
      Icons.credit_card_rounded,
    ),
    _PaymentMethod(
      'Mobile Money',
      'Mobile Money',
      'M-PESA, Airtel Money, MTN MoMo',
      '1.5% fee',
      Icons.phone_android_rounded,
    ),
    _PaymentMethod(
      'Bank transfer',
      'Bank Transfer',
      'Direct bank payment',
      'No fee',
      Icons.account_balance_outlined,
    ),
    _PaymentMethod(
      'HelpFundUs Wallet',
      'HelpFundUs Wallet',
      'Balance: \$12.50',
      'No fee',
      Icons.account_balance_wallet_outlined,
    ),
  ];

  void _continue() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            PaymentAuthorizationScreen(controller: widget.controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final method = _methods.firstWhere(
      (item) => item.value == widget.controller.paymentMethod,
      orElse: () => _methods.first,
    );
    return DonationFlowScaffold(
      title: 'Payment Method',
      bottomAction: DonationPrimaryButton(
        label:
            'Pay \$${widget.controller.total.toStringAsFixed(2)} via ${method.title}',
        enabled: true,
        onPressed: _continue,
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
        children: [
          const CampaignSummary(
            title: 'Help rebuild our community centre',
            emoji: '🏘️',
          ),
          const SizedBox(height: 20),
          Text(
            'Select a payment method',
            style: AppTextStyles.h3.copyWith(fontSize: 19),
          ),
          const SizedBox(height: 10),
          ..._methods.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: _PaymentMethodTile(
                method: item,
                selected: item.value == widget.controller.paymentMethod,
                onTap: () =>
                    setState(() => widget.controller.setMethod(item.value)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FF),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.language_rounded,
                  color: Color(0xFF2563EB),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Available payment methods are determined by your region and the campaign’s accepted currencies. All transactions are encrypted end-to-end.',
                    style: AppTextStyles.bodyMd.copyWith(
                      fontSize: 13,
                      height: 1.32,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final _PaymentMethod method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: selected ? AppColors.primary.withValues(alpha: .06) : Colors.white,
    borderRadius: BorderRadius.circular(19),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(19),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFD2D6DF),
            width: selected ? 2 : 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : const Color(0xFFF5FAF7),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                method.icon,
                color: selected ? Colors.white : const Color(0xFF687386),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.title,
                    style: AppTextStyles.h3.copyWith(fontSize: 17),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    method.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMd.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  method.fee,
                  style: AppTextStyles.label.copyWith(
                    color: method.fee == 'No fee'
                        ? AppColors.primary
                        : AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 9),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected
                          ? AppColors.primary
                          : const Color(0xFFD2D6DF),
                      width: 2.5,
                    ),
                  ),
                  child: selected
                      ? const Icon(Icons.circle, color: Colors.white, size: 12)
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _PaymentMethod {
  const _PaymentMethod(
    this.value,
    this.title,
    this.subtitle,
    this.fee,
    this.icon,
  );

  final String value;
  final String title;
  final String subtitle;
  final String fee;
  final IconData icon;
}
