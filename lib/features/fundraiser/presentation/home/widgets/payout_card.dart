import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';

class PayoutCard extends StatelessWidget {
  const PayoutCard({super.key, this.onRequest});

  final VoidCallback? onRequest;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7438F2), Color(0xFF4D46E9)],
        ),
        borderRadius: BorderRadius.circular(23),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .16),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available for payout',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '\$3,800',
                  style: AppTextStyles.h2.copyWith(
                    color: Colors.white,
                    fontSize: 27,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 44,
            child: OutlinedButton(
              onPressed: onRequest,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(100, 44),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                foregroundColor: Colors.white,
                backgroundColor: Colors.white.withValues(alpha: .16),
                side: const BorderSide(color: Color(0x88FFFFFF)),
                textStyle: AppTextStyles.buttonMd.copyWith(color: Colors.white),
              ),
              child: const Text('Request'),
            ),
          ),
        ],
      ),
    );
  }
}
