/// Request payload accepted by `POST /api/v1/auth/mfa/enable`.
class MfaEnableRequest {
  const MfaEnableRequest({required this.password});

  final String password;

  Map<String, dynamic> toJson() => {'password': password};
}
