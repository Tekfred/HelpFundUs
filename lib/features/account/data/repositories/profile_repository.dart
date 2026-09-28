import 'package:helpfundus/features/account/data/datasources/profile_remote_data_source.dart';
import 'package:helpfundus/features/account/data/models/user_profile.dart';

class ProfileRepository {
  const ProfileRepository(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  Future<UserProfile> fetchProfile() => _remoteDataSource.fetchProfile();
}
