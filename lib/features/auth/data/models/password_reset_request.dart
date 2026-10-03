class PasswordResetRequest {
  const PasswordResetRequest({required this.email});

  final String email;

  Map<String, String> toJson() => {'email': email};
}
