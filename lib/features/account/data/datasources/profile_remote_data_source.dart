import 'package:helpfundus/core/network/api_client.dart';
import 'package:helpfundus/core/network/api_endpoints.dart';
import 'package:helpfundus/features/account/data/models/user_profile.dart';

class ProfileRemoteDataSource {
  const ProfileRemoteDataSource(this._client);

  final ApiClient _client;

  Future<UserProfile> fetchProfile() async {
    final response = await _client.get<dynamic>(ApiEndpoints.profile);
    return UserProfile.fromJson(response.data);
  }
}
