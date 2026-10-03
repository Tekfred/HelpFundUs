import 'package:helpfundus/core/network/api_exception.dart';

/// Identifier returned when the backend creates a passwordless login OTP.
class LoginOtpRequestResult {
  const LoginOtpRequestResult({required this.verificationId});

  final String verificationId;

  factory LoginOtpRequestResult.fromJson(Object? responseData) {
    final id = _findId(responseData);
    if (id == null || id.isEmpty) {
      throw const ApiException(
        type: ApiErrorType.invalidResponse,
        message: 'The server did not return a login verification ID.',
      );
    }
    return LoginOtpRequestResult(verificationId: id);
  }

  static String? _findId(Object? value) {
    if (value is! Map) return null;
    for (final key in const ['id', 'userId', 'verificationId', 'requestId']) {
      final id = value[key];
      if (id is String && id.trim().isNotEmpty) return id.trim();
      if (id is num) return id.toString();
    }
    for (final key in const ['data', 'result', 'user']) {
      final nestedId = _findId(value[key]);
      if (nestedId != null) return nestedId;
    }
    return null;
  }
}
