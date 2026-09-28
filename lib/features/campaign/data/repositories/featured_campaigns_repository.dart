import 'package:helpfundus/features/campaign/data/datasources/featured_campaigns_remote_data_source.dart';

/// Repository boundary for the featured-campaign endpoint.
class FeaturedCampaignsRepository {
  const FeaturedCampaignsRepository(this._remoteDataSource);

  final FeaturedCampaignsRemoteDataSource _remoteDataSource;

  Future<Object?> fetchFeaturedCampaigns() =>
      _remoteDataSource.fetchFeaturedCampaigns();
}
