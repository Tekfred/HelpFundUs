import '../domain/entities/campaign.dart' as domain;
import '../domain/repositories/campaign_repository.dart';
import 'campaign_catalog.dart';

/// Temporary repository backed by the existing in-memory catalog.
/// Replace this source with [CampaignApi] calls once an API is available.
class CampaignRepositoryImpl implements CampaignRepository {
  const CampaignRepositoryImpl();

  @override
  Future<List<domain.Campaign>> getAllCampaigns() async =>
      CampaignCatalog.all.map(_toEntity).toList(growable: false);

  @override
  Future<List<domain.Campaign>> getFeaturedCampaigns() async =>
      CampaignCatalog.featured.map(_toEntity).toList(growable: false);

  @override
  Future<List<domain.Campaign>> getTrendingCampaigns() async =>
      CampaignCatalog.trending.map(_toEntity).toList(growable: false);

  @override
  Future<List<domain.Campaign>> getRecentCampaigns() async =>
      CampaignCatalog.recent.map(_toEntity).toList(growable: false);

  @override
  Future<List<domain.Campaign>> getCampaignsByCategory(
    String categoryName,
  ) async => CampaignCatalog.all
      .where((campaign) => campaign.categoryKey == categoryName)
      .map(_toEntity)
      .toList(growable: false);

  @override
  Future<domain.Campaign?> getCampaignById(String id) async {
    for (final campaign in CampaignCatalog.all) {
      if (campaign.id == id) return _toEntity(campaign);
    }
    return null;
  }

  domain.Campaign _toEntity(CampaignData source) => domain.Campaign(
    id: source.id,
    title: source.title,
    category: source.category,
    categoryKey: source.categoryKey,
    amount: source.amount,
    goal: source.goal,
    progress: source.progress,
    location: source.location,
    icon: source.icon,
    gradientColorValues: source.gradient.colors
        .map((color) => color.toARGB32())
        .toList(growable: false),
    donors: source.donors,
    daysLeft: source.daysLeft,
    fundraiser: source.fundraiser,
    story: source.story,
    milestones: source.milestones
        .map(
          (item) => domain.CampaignMilestone(
            title: item.title,
            dateAmount: item.dateAmount,
            completed: item.completed,
          ),
        )
        .toList(growable: false),
    updates: source.updates
        .map(
          (item) => domain.CampaignUpdate(
            title: item.title,
            when: item.when,
            message: item.message,
            emoji: item.emoji,
          ),
        )
        .toList(growable: false),
    organisation: source.organisation,
    status: domain.CampaignStatus.values.byName(source.status.name),
  );
}
