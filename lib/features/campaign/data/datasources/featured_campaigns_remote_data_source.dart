import 'package:helpfundus/core/network/api_client.dart';
import 'package:helpfundus/core/network/api_endpoints.dart';

/// Fetches the server's featured-campaign payload. Parsing is intentionally
/// deferred until the backend response contract is confirmed.
class FeaturedCampaignsRemoteDataSource {
  const FeaturedCampaignsRemoteDataSource(this._client);

  final ApiClient _client;

  Future<Object?> fetchFeaturedCampaigns() async {
    final response = await _client.get<dynamic>(ApiEndpoints.featuredCampaigns);
    return response.data;
  }
}
