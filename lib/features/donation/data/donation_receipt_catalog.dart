import 'package:helpfundus/features/donation/domain/entities/donation_receipt.dart';

abstract final class DonationReceiptCatalog {
  static const activityReceipt = DonationReceipt(
    campaignTitle: "Medical expenses for Leah's treatment",
    campaignLocation: 'Nairobi, Kenya',
    campaignEmoji: '🏥',
    campaignId: '2',
    reference: 'HF-A3F8B2',
    donorName: 'Jane Doe',
    amount: 100,
    paymentMethod: 'Visa •••• 4242',
    paymentDate: 'Aug 20, 2026 · 14:32',
    status: 'Completed',
    donorMessage: '“Sending love and strength to Leah 💙”',
    receiptId: 'HF-A3F8B2',
  );

  static const waterReceipt = DonationReceipt(
    campaignTitle: 'Clean water wells for Turkana County',
    campaignLocation: 'Turkana County, Kenya',
    campaignEmoji: '💧',
    campaignId: '3',
    reference: 'HF-CW2514',
    donorName: 'Jane Doe',
    amount: 25,
    paymentMethod: 'Visa •••• 4242',
    paymentDate: 'Aug 17, 2026 · 09:14',
    status: 'Completed',
    donorMessage: '“Wishing your community clean water.”',
    receiptId: 'HF-CW2514',
  );
}
