import '../entities/campaign.dart';

abstract interface class CampaignRepository {
  Future<List<Campaign>> getAllCampaigns();
  Future<List<Campaign>> getFeaturedCampaigns();
  Future<List<Campaign>> getTrendingCampaigns();
  Future<List<Campaign>> getRecentCampaigns();
  Future<List<Campaign>> getCampaignsByCategory(String categoryName);
  Future<Campaign?> getCampaignById(String id);
}
