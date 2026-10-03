import 'package:dio/dio.dart';
import 'package:helpfundus/core/network/api_client.dart';
import 'package:helpfundus/core/network/api_endpoints.dart';
import 'package:helpfundus/features/auth/data/models/register_request.dart';
import 'package:helpfundus/features/auth/data/models/registration_result.dart';
import 'package:helpfundus/features/auth/data/models/resend_otp_request.dart';
import 'package:helpfundus/features/auth/data/models/resend_otp_result.dart';
import 'package:helpfundus/features/auth/data/models/verify_otp_request.dart';
import 'package:helpfundus/features/auth/data/models/login_request.dart';
import 'package:helpfundus/features/auth/data/models/login_result.dart';
import 'package:helpfundus/features/auth/data/models/mfa_enable_request.dart';
import 'package:helpfundus/features/auth/data/models/mfa_setup_result.dart';
import 'package:helpfundus/features/auth/data/models/mfa_enable_verify_request.dart';
import 'package:helpfundus/features/auth/data/models/login_otp_verification_request.dart';
import 'package:helpfundus/features/auth/data/models/login_otp_request.dart';
import 'package:helpfundus/features/auth/data/models/login_otp_request_result.dart';
import 'package:helpfundus/features/auth/data/models/mfa_enable_email_request.dart';
import 'package:helpfundus/features/auth/data/models/password_reset_request.dart';

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

  Future<LoginResult> login(LoginRequest request) async {
    final response = await _client.post<dynamic>(
      ApiEndpoints.login,
      data: request.toJson(),
      options: Options(contentType: Headers.jsonContentType),
    );
    return LoginResult.fromJson(response.data);
  }

  Future<void> requestPasswordReset(PasswordResetRequest request) async {
    await _client.post<dynamic>(
      ApiEndpoints.requestPasswordReset,
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

  Future<void> verifyLoginOtp(
    String id,
    LoginOtpVerificationRequest request,
  ) async {
    await _client.post<dynamic>(
      ApiEndpoints.verifyLoginOtp(id),
      data: request.toJson(),
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  Future<LoginOtpRequestResult> requestLoginOtp(LoginOtpRequest request) async {
    final response = await _client.post<dynamic>(
      ApiEndpoints.requestLoginOtp,
      data: request.toJson(),
      options: Options(contentType: Headers.jsonContentType),
    );
    return LoginOtpRequestResult.fromJson(response.data);
  }

  Future<ResendOtpResult> resendOtp(ResendOtpRequest request) async {
    final response = await _client.post<dynamic>(
      ApiEndpoints.resendOtp,
      data: request.toJson(),
      options: Options(contentType: Headers.jsonContentType),
    );
    return ResendOtpResult.fromJson(response.data);
  }

  Future<MfaSetupResult> enableMfa(MfaEnableRequest request) async {
    final response = await _client.post<dynamic>(
      ApiEndpoints.enableMfa,
      data: request.toJson(),
      options: Options(contentType: Headers.jsonContentType),
    );
    return MfaSetupResult.fromJson(response.data);
  }

  Future<void> enableEmailMfa(MfaEnableEmailRequest request) async {
    await _client.post<dynamic>(
      ApiEndpoints.enableEmailMfa,
      data: request.toJson(),
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  Future<void> verifyMfaEnable(MfaEnableVerifyRequest request) async {
    await _client.post<dynamic>(
      ApiEndpoints.verifyMfaEnable,
      data: request.toJson(),
      options: Options(contentType: Headers.jsonContentType),
    );
  }
}
