import 'package:helpfundus/core/network/api_exception.dart';

/// Authentication details returned by `POST /api/v1/auth/login`.
class LoginResult {
  const LoginResult({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.mfaRequired,
  });

  final String accessToken;
  final String? refreshToken;
  final String? userId;
  final bool mfaRequired;

  factory LoginResult.fromJson(Object? responseData) {
    if (responseData is! Map) {
      throw const ApiException(
        type: ApiErrorType.invalidResponse,
        message: 'The server returned an invalid login response.',
      );
    }

    final accessToken = responseData['accessToken'];
    if (accessToken is! String || accessToken.trim().isEmpty) {
      throw const ApiException(
        type: ApiErrorType.invalidResponse,
        message: 'The server did not return an access token.',
      );
    }

    final refreshToken = responseData['refreshToken'];
    final userId = responseData['userId'];
    return LoginResult(
      accessToken: accessToken.trim(),
      refreshToken: refreshToken is String && refreshToken.trim().isNotEmpty
          ? refreshToken.trim()
          : null,
      userId: userId is String && userId.trim().isNotEmpty
          ? userId.trim()
          : userId is num
          ? userId.toString()
          : null,
      mfaRequired: responseData['mfaRequired'] == true,
    );
  }
}
