/// Request payload accepted by `POST /api/v1/auth/resend-otp`.
class ResendOtpRequest {
  const ResendOtpRequest({
    required this.identifier,
    required this.email,
    required this.phone,
  });

  final String identifier;
  final String email;
  final String phone;

  Map<String, dynamic> toJson() => {
    'identifier': identifier,
    'email': email,
    'phone': phone,
  };
}
