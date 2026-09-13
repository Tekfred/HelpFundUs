enum FundraiserCampaignStatus { active, draft, inReview, suspended, closed }

extension FundraiserCampaignStatusLabel on FundraiserCampaignStatus {
  String get label => switch (this) {
    FundraiserCampaignStatus.active => 'Active',
    FundraiserCampaignStatus.draft => 'Draft',
    FundraiserCampaignStatus.inReview => 'In review',
    FundraiserCampaignStatus.suspended => 'Suspended',
    FundraiserCampaignStatus.closed => 'Closed',
  };
}

class FundraiserCampaign {
  const FundraiserCampaign({
    required this.id,
    required this.title,
    required this.icon,
    required this.status,
    required this.amountRaised,
    required this.goal,
    required this.donorCount,
    required this.progress,
    required this.daysRemaining,
    required this.updatedAt,
    required this.gradientColorValues,
    this.reviewerNote,
    this.payoutAvailable = false,
    this.suspendedReason,
  });

  final String id;
  final String title;
  final String icon;
  final FundraiserCampaignStatus status;
  final double amountRaised;
  final double goal;
  final int donorCount;
  final double progress;
  final int daysRemaining;
  final String updatedAt;
  final List<int> gradientColorValues;
  final String? reviewerNote;
  final bool payoutAvailable;
  final String? suspendedReason;
}
