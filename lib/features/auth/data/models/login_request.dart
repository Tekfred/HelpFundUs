/// Request payload accepted by `POST /api/v1/auth/login`.
class LoginRequest {
  const LoginRequest({
    required this.identifier,
    required this.password,
    required this.deviceId,
  });

  final String identifier;
  final String password;
  final String deviceId;

  Map<String, dynamic> toJson() => {
    'identifier': identifier,
    'password': password,
    'deviceId': deviceId,
  };
}
