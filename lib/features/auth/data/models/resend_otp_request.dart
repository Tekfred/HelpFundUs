/// Request payload accepted by `POST /api/v1/auth/resend-otp`.
class ResendOtpRequest {
  const ResendOtpRequest({required this.identifier, required this.email});

  final String identifier;
  final String email;

  Map<String, dynamic> toJson() => {'identifier': identifier, 'email': email};
}
