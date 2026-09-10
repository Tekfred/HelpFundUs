import '../domain/entities/campaign.dart';

/// Future boundary for the remote campaign service.
///
/// No networking is configured yet. An HTTP/Dio implementation can implement
/// this contract without requiring presentation code to change.
abstract interface class CampaignApi {
  Future<List<Campaign>> fetchCampaigns();
  Future<Campaign?> fetchCampaignById(String id);
}
