/// Request payload accepted by `POST /api/v1/auth/mfa/enable-email`.
class MfaEnableEmailRequest {
  const MfaEnableEmailRequest({
    required this.identifier,
    required this.deviceId,
  });

  final String identifier;
  final String deviceId;

  Map<String, dynamic> toJson() => {
    'identifier': identifier,
    'deviceId': deviceId,
  };
}
