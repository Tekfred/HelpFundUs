class DonationReceipt {
  const DonationReceipt({
    required this.campaignTitle,
    required this.campaignLocation,
    required this.campaignEmoji,
    required this.campaignId,
    required this.reference,
    required this.donorName,
    required this.amount,
    required this.paymentMethod,
    required this.paymentDate,
    required this.status,
    required this.donorMessage,
    required this.receiptId,
  });

  final String campaignTitle;
  final String campaignLocation;
  final String campaignEmoji;
  final String campaignId;
  final String reference;
  final String donorName;
  final double amount;
  final String paymentMethod;
  final String paymentDate;
  final String status;
  final String donorMessage;
  final String receiptId;

  factory DonationReceipt.forDonation({
    required double amount,
    required String paymentMethod,
    required String reference,
  }) => DonationReceipt(
    campaignTitle: 'Help rebuild our community centre',
    campaignLocation: 'Lagos, Nigeria',
    campaignEmoji: '🏘️',
    campaignId: '1',
    reference: reference,
    donorName: 'Jane Doe',
    amount: amount,
    paymentMethod: paymentMethod,
    paymentDate: 'Aug 20, 2026 · 14:32',
    status: 'Completed',
    donorMessage: '“Sending love and strength to every donor 💚”',
    receiptId: reference,
  );
}
