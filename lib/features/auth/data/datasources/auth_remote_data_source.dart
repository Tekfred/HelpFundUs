import 'package:dio/dio.dart';
import 'package:helpfundus/core/network/api_client.dart';
import 'package:helpfundus/core/network/api_endpoints.dart';
import 'package:helpfundus/features/auth/data/models/register_request.dart';
import 'package:helpfundus/features/auth/data/models/registration_result.dart';
import 'package:helpfundus/features/auth/data/models/resend_otp_request.dart';
import 'package:helpfundus/features/auth/data/models/verify_otp_request.dart';
import 'package:helpfundus/features/auth/data/models/login_request.dart';

/// Performs authentication HTTP requests. It deliberately contains no UI
/// concerns, which makes it straightforward to replace with a fake in tests.
class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._client);

  final ApiClient _client;

  Future<RegistrationResult> register(RegisterRequest request) async {
    final response = await _client.post<dynamic>(
      ApiEndpoints.register,
      data: request.toJson(),
      options: Options(contentType: Headers.jsonContentType),
    );
    return RegistrationResult.fromJson(response.data);
  }

  Future<void> login(LoginRequest request) async {
    await _client.post<dynamic>(
      ApiEndpoints.login,
      data: request.toJson(),
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  Future<void> verifyOtp({required String id, required String otp}) async {
    await _client.post<dynamic>(
      ApiEndpoints.verifyOtp(id),
      data: VerifyOtpRequest(otp: otp).toJson(),
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  Future<void> resendOtp(ResendOtpRequest request) async {
    await _client.post<dynamic>(
      ApiEndpoints.resendOtp,
      data: request.toJson(),
      options: Options(contentType: Headers.jsonContentType),
    );
  }
}
