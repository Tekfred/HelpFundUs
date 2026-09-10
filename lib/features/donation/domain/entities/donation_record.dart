import 'donation_receipt.dart';

enum DonationStatus { completed, pending, failed }

extension DonationStatusLabel on DonationStatus {
  String get label => switch (this) {
    DonationStatus.completed => 'Completed',
    DonationStatus.pending => 'Pending',
    DonationStatus.failed => 'Failed',
  };
}

class DonationRecord {
  const DonationRecord({
    required this.id,
    required this.campaignId,
    required this.campaignTitle,
    required this.campaignLocation,
    required this.campaignEmoji,
    required this.campaignProgress,
    required this.gradientColorValues,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    required this.paymentDate,
    required this.donorName,
    required this.reference,
    this.donorMessage,
    this.receipt,
  });

  final String id;
  final String campaignId;
  final String campaignTitle;
  final String campaignLocation;
  final String campaignEmoji;
  final double campaignProgress;
  final List<int> gradientColorValues;
  final double amount;
  final DonationStatus status;
  final String paymentMethod;
  final String paymentDate;
  final String donorName;
  final String reference;
  final String? donorMessage;
  final DonationReceipt? receipt;
}
