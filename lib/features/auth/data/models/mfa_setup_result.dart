import 'package:helpfundus/core/network/api_exception.dart';

/// TOTP setup information returned after MFA is enabled.
class MfaSetupResult {
  const MfaSetupResult({required this.qrCode, required this.manualEntryKey});

  final String qrCode;
  final String manualEntryKey;

  factory MfaSetupResult.fromJson(Object? responseData) {
    final data = _dataMap(responseData);
    final qrCode = _firstString(data, const [
      'qrCode',
      'qrCodeUrl',
      'qrCodeDataUrl',
      'otpauthUrl',
      'otpAuthUrl',
    ]);
    final manualEntryKey = _firstString(data, const [
      'secret',
      'secretKey',
      'manualEntryKey',
      'textKey',
    ]);

    if (qrCode == null || manualEntryKey == null) {
      throw const ApiException(
        type: ApiErrorType.invalidResponse,
        message: 'The server did not return the MFA setup details.',
      );
    }
    return MfaSetupResult(qrCode: qrCode, manualEntryKey: manualEntryKey);
  }

  static Map _dataMap(Object? value) {
    if (value is! Map) return const <Object?, Object?>{};
    for (final key in const ['data', 'result']) {
      final nested = value[key];
      if (nested is Map) return _dataMap(nested);
    }
    return value;
  }

  static String? _firstString(Map data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    return null;
  }
}
