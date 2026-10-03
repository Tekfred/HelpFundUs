/// Request payload accepted by `POST /api/v1/auth/login/request-otp`.
class LoginOtpRequest {
  const LoginOtpRequest({required this.identifier, required this.deviceId});

  final String identifier;
  final String deviceId;

  Map<String, dynamic> toJson() => {
    'identifier': identifier,
    'deviceId': deviceId,
  };
}
