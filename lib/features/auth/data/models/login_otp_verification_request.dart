/// Request payload accepted by `POST /api/v1/auth/login/verify-otp/{id}`.
class LoginOtpVerificationRequest {
  const LoginOtpVerificationRequest({
    required this.otp,
    required this.trustedDevice,
  });

  final String otp;
  final bool trustedDevice;

  Map<String, dynamic> toJson() => {'otp': otp, 'trustedDevice': trustedDevice};
}
