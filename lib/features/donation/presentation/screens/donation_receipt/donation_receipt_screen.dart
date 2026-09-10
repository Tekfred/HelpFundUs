import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/core/widgets/app_share_sheet.dart';
import 'package:helpfundus/features/donation/data/donation_receipt_catalog.dart';
import 'package:helpfundus/features/donation/domain/entities/donation_receipt.dart';

class DonationReceiptScreen extends StatelessWidget {
  const DonationReceiptScreen({
    super.key,
    this.receipt = DonationReceiptCatalog.activityReceipt,
  });

  final DonationReceipt receipt;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(
      child: Column(
        children: [
          _ReceiptHeader(
            onBack: () => Navigator.of(context).pop(),
            onShare: () => _shareReceipt(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                children: [
                  const _OfficialReceiptIntro(),
                  const SizedBox(height: 22),
                  _ReceiptDetailsCard(receipt: receipt),
                  const SizedBox(height: 18),
                  _TaxInformationCard(receiptId: receipt.receiptId),
                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Contact support',
                      style: AppTextStyles.buttonMd.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
              child: Row(
                children: [
                  Expanded(
                    child: _ReceiptActionButton(
                      icon: Icons.download_rounded,
                      label: 'Download PDF',
                      primary: true,
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ReceiptActionButton(
                      icon: Icons.share_outlined,
                      label: 'Share',
                      onPressed: () => _shareReceipt(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );

  void _shareReceipt(BuildContext context) => showAppShareSheet(
    context,
    ShareSheetData(
      title: receipt.campaignTitle,
      subtitle:
          '\$${receipt.amount.toStringAsFixed(2)} donation · ${receipt.status}',
      emoji: receipt.campaignEmoji,
      link: 'https://helpfundus.app/c/${receipt.campaignId}',
      iconGradient: const LinearGradient(
        colors: [Color(0xFFFF5B48), Color(0xFFFF7A20)],
      ),
    ),
  );
}

class _OfficialReceiptIntro extends StatelessWidget {
  const _OfficialReceiptIntro();

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: 76,
        height: 76,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: .05),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.receipt_long_outlined,
          size: 37,
          color: AppColors.primary,
        ),
      ),
      const SizedBox(height: 16),
      Text('Official Receipt', style: AppTextStyles.h2.copyWith(fontSize: 23)),
      const SizedBox(height: 4),
      Text(
        'HelpFundUs · Tax reference document',
        style: AppTextStyles.bodyMd.copyWith(
          fontSize: 15,
          color: AppColors.textMuted,
        ),
      ),
    ],
  );
}

class _ReceiptHeader extends StatelessWidget {
  const _ReceiptHeader({required this.onBack, required this.onShare});

  final VoidCallback onBack;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 8, 20, 6),
    child: SizedBox(
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onBack,
                customBorder: const CircleBorder(),
                child: const SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(Icons.arrow_back_ios_new_rounded, size: 19),
                ),
              ),
            ),
          ),
          Text(
            'Donation Receipt',
            style: AppTextStyles.h2.copyWith(fontSize: 23),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: onShare,
              borderRadius: BorderRadius.circular(22),
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Icon(Icons.share_outlined, size: 24),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _ReceiptDetailsCard extends StatelessWidget {
  const _ReceiptDetailsCard({required this.receipt});

  final DonationReceipt receipt;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF5B48), Color(0xFFFF7A20)],
                ),
                borderRadius: BorderRadius.circular(19),
              ),
              child: Text(
                receipt.campaignEmoji,
                style: const TextStyle(fontSize: 31),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    receipt.campaignTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.h3.copyWith(fontSize: 17),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    receipt.campaignLocation,
                    style: AppTextStyles.bodyMd.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(height: 1, color: AppColors.borderStrong),
        const SizedBox(height: 8),
        _ReceiptRow(label: 'Donation reference', value: receipt.reference),
        const _ReceiptDivider(),
        _ReceiptRow(label: 'Donor name', value: receipt.donorName),
        const _ReceiptDivider(),
        _ReceiptRow(
          label: 'Amount',
          value: '\$${receipt.amount.toStringAsFixed(2)} USD',
        ),
        const _ReceiptDivider(),
        _ReceiptRow(label: 'Payment method', value: receipt.paymentMethod),
        const _ReceiptDivider(),
        _ReceiptRow(label: 'Payment date', value: receipt.paymentDate),
        const _ReceiptDivider(),
        _ReceiptRow(
          label: 'Status',
          value: '✓ ${receipt.status}',
          valueColor: AppColors.primary,
        ),
        const SizedBox(height: 14),
        const Divider(height: 1, color: AppColors.borderStrong),
        const SizedBox(height: 14),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Donor message',
            style: AppTextStyles.label.copyWith(fontSize: 14),
          ),
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            receipt.donorMessage,
            style: AppTextStyles.bodyMd.copyWith(fontSize: 15),
          ),
        ),
      ],
    ),
  );
}

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.textPrimary,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyMd.copyWith(fontSize: 14),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: AppTextStyles.buttonMd.copyWith(
              fontSize: 14,
              color: valueColor,
            ),
          ),
        ),
      ],
    ),
  );
}

class _ReceiptDivider extends StatelessWidget {
  const _ReceiptDivider();

  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, thickness: 1, color: AppColors.borderStrong);
}

class _TaxInformationCard extends StatelessWidget {
  const _TaxInformationCard({required this.receiptId});

  final String receiptId;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .55),
      borderRadius: BorderRadius.circular(19),
    ),
    child: Text(
      'This receipt is issued by HelpFundUs Inc. Donations to verified campaigns may be eligible for tax deductions in your jurisdiction. Please consult a tax professional for advice.\nReceipt ID: $receiptId.',
      style: AppTextStyles.bodySm.copyWith(fontSize: 13, height: 1.38),
    ),
  );
}

class _ReceiptActionButton extends StatelessWidget {
  const _ReceiptActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.primary = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool primary;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 58,
    child: OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: primary ? AppColors.primary : AppColors.textPrimary,
        side: BorderSide(
          color: primary
              ? AppColors.primary.withValues(alpha: .22)
              : AppColors.borderStrong,
        ),
        backgroundColor: primary
            ? AppColors.primary.withValues(alpha: .04)
            : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
      ),
      icon: Icon(icon, size: 21),
      label: Text(label, style: AppTextStyles.buttonMd.copyWith(fontSize: 15)),
    ),
  );
}
