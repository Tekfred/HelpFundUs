import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/auth/auth_session_provider.dart';
import '../../../core/network/api_client.dart';
import '../data/datasources/profile_remote_data_source.dart';
import '../data/models/user_profile.dart';
import '../data/repositories/profile_repository.dart';

final currentUserProfileProvider =
    AsyncNotifierProvider<CurrentUserProfileNotifier, UserProfile?>(
      CurrentUserProfileNotifier.new,
    );

class CurrentUserProfileNotifier extends AsyncNotifier<UserProfile?> {
  @override
  Future<UserProfile?> build() async => null;

  Future<UserProfile> fetchProfile() async {
    state = const AsyncLoading();
    try {
      final profile = await ProfileRepository(
        ProfileRemoteDataSource(
          ApiClient(
            tokenProvider: () => ref.read(authSessionProvider).accessToken,
          ),
        ),
      ).fetchProfile();
      state = AsyncData(profile);
      return profile;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  void clear() => state = const AsyncData(null);
}
