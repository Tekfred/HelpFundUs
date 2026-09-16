/// Request payload accepted by `POST /api/v1/auth/register`.
class RegisterRequest {
  const RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    this.role = 'USER',
    this.accountType = 'INDIVIDUAL',
  });

  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String role;
  final String accountType;

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'phone': phone,
    'password': password,
    'role': role,
    'accountType': accountType,
  };
}
