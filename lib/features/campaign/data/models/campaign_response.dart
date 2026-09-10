/// Placeholder API DTO namespace.
///
/// Keep backend JSON parsing/mapping here when campaign endpoints are added;
/// do not expose DTOs to domain or presentation layers.
class CampaignResponse {
  const CampaignResponse(this.values);

  final Map<String, Object?> values;
}
