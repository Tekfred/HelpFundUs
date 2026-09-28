import 'package:helpfundus/core/network/api_exception.dart';

/// The identifier returned after a successful OTP resend. It is required by
/// `POST /api/v1/auth/verify-otp/{id}` for accounts resuming verification.
class ResendOtpResult {
  const ResendOtpResult({required this.userId});

  final String userId;

  factory ResendOtpResult.fromJson(Object? responseData) {
    final userId = _findUserId(responseData);
    if (userId == null || userId.isEmpty) {
      throw const ApiException(
        type: ApiErrorType.invalidResponse,
        message:
            'We resent your code, but the server did not return a verification ID.',
      );
    }
    return ResendOtpResult(userId: userId);
  }

  static String? _findUserId(Object? value) {
    if (value is! Map) return null;

    final userId = value['userId'];
    if (userId is String && userId.trim().isNotEmpty) return userId.trim();
    if (userId is num) return userId.toString();

    for (final key in const ['data', 'user', 'result']) {
      final nestedId = _findUserId(value[key]);
      if (nestedId != null) return nestedId;
    }
    return null;
  }
}
