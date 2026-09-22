/// Request payload accepted by `POST /api/v1/auth/verify-otp/{id}`.
class VerifyOtpRequest {
  const VerifyOtpRequest({required this.otp});

  final String otp;

  Map<String, dynamic> toJson() => {'otp': otp};
}
