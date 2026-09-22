import 'package:helpfundus/core/network/api_exception.dart';

/// Extracts the identifier returned by registration for OTP verification.
///
/// The staging API response has not been formally documented, so common API
/// envelope shapes are supported while still failing clearly if no identifier
/// is returned.
class RegistrationResult {
  const RegistrationResult({required this.verificationId});

  final String verificationId;

  factory RegistrationResult.fromJson(Object? responseData) {
    final id = _findId(responseData);
    if (id == null || id.isEmpty) {
      throw const ApiException(
        type: ApiErrorType.invalidResponse,
        message:
            'Your account was created, but the server did not return a verification ID.',
        data: null,
      );
    }
    return RegistrationResult(verificationId: id);
  }

  static String? _findId(Object? value) {
    if (value is! Map) return null;

    for (final key in const ['id', 'userId', 'verificationId']) {
      final id = value[key];
      if (id is String && id.trim().isNotEmpty) return id.trim();
      if (id is num) return id.toString();
    }

    for (final key in const ['data', 'user', 'result']) {
      final nestedId = _findId(value[key]);
      if (nestedId != null) return nestedId;
    }
    return null;
  }
}
