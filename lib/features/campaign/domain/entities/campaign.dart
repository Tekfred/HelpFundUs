/// Framework-independent campaign entities for repository and API work.
/// Presentation-specific values such as gradients are represented as ARGB ints.
enum CampaignStatus { active, closed, suspended }

class CampaignCategory {
  const CampaignCategory({
    required this.name,
    required this.emoji,
    required this.description,
    required this.colorValue,
    required this.campaignCount,
  });

  final String name;
  final String emoji;
  final String description;
  final int colorValue;
  final int campaignCount;
}

class CampaignMilestone {
  const CampaignMilestone({
    required this.title,
    required this.dateAmount,
    required this.completed,
  });

  final String title;
  final String dateAmount;
  final bool completed;
}

class CampaignUpdate {
  const CampaignUpdate({
    required this.title,
    required this.when,
    required this.message,
    required this.emoji,
  });

  final String title;
  final String when;
  final String message;
  final String emoji;
}

class Campaign {
  const Campaign({
    required this.id,
    required this.title,
    required this.category,
    required this.categoryKey,
    required this.amount,
    required this.goal,
    required this.progress,
    required this.location,
    required this.icon,
    required this.gradientColorValues,
    required this.donors,
    required this.daysLeft,
    required this.fundraiser,
    required this.story,
    required this.milestones,
    required this.updates,
    required this.organisation,
    required this.status,
  });

  final String id;
  final String title;
  final String category;
  final String categoryKey;
  final String amount;
  final String goal;
  final double progress;
  final String location;
  final String icon;
  final List<int> gradientColorValues;
  final int donors;
  final int daysLeft;
  final String fundraiser;
  final String story;
  final List<CampaignMilestone> milestones;
  final List<CampaignUpdate> updates;
  final bool organisation;
  final CampaignStatus status;
}
