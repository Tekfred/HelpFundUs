import 'package:helpfundus/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:helpfundus/features/auth/data/models/register_request.dart';

/// Feature-facing authentication API. Presentation code depends on this
/// repository rather than directly on Dio or endpoint strings.
class AuthRepository {
  const AuthRepository(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  Future<void> register(RegisterRequest request) =>
      _remoteDataSource.register(request);
}
