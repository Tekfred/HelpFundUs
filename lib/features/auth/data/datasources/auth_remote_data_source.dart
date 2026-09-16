import 'package:dio/dio.dart';
import 'package:helpfundus/core/network/api_client.dart';
import 'package:helpfundus/core/network/api_endpoints.dart';
import 'package:helpfundus/features/auth/data/models/register_request.dart';

/// Performs authentication HTTP requests. It deliberately contains no UI
/// concerns, which makes it straightforward to replace with a fake in tests.
class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._client);

  final ApiClient _client;

  Future<void> register(RegisterRequest request) async {
    await _client.post<dynamic>(
      ApiEndpoints.register,
      data: request.toJson(),
      options: Options(contentType: Headers.jsonContentType),
    );
  }
}
