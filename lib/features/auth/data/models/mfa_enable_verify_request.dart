/// Request payload accepted by `POST /api/v1/auth/mfa/enable/verify`.
class MfaEnableVerifyRequest {
  const MfaEnableVerifyRequest({required this.code});

  final String code;

  Map<String, dynamic> toJson() => {'code': code};
}
