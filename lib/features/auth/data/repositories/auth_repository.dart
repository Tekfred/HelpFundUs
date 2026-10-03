import 'package:helpfundus/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:helpfundus/features/auth/data/models/register_request.dart';
import 'package:helpfundus/features/auth/data/models/registration_result.dart';
import 'package:helpfundus/features/auth/data/models/resend_otp_request.dart';
import 'package:helpfundus/features/auth/data/models/resend_otp_result.dart';
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

/// Feature-facing authentication API. Presentation code depends on this
/// repository rather than directly on Dio or endpoint strings.
class AuthRepository {
  const AuthRepository(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  Future<RegistrationResult> register(RegisterRequest request) =>
      _remoteDataSource.register(request);

  Future<LoginResult> login(LoginRequest request) =>
      _remoteDataSource.login(request);

  Future<void> requestPasswordReset(PasswordResetRequest request) =>
      _remoteDataSource.requestPasswordReset(request);

  Future<void> verifyOtp({required String id, required String otp}) =>
      _remoteDataSource.verifyOtp(id: id, otp: otp);

  Future<void> verifyLoginOtp(String id, LoginOtpVerificationRequest request) =>
      _remoteDataSource.verifyLoginOtp(id, request);

  Future<LoginOtpRequestResult> requestLoginOtp(LoginOtpRequest request) =>
      _remoteDataSource.requestLoginOtp(request);

  Future<ResendOtpResult> resendOtp(ResendOtpRequest request) =>
      _remoteDataSource.resendOtp(request);

  Future<MfaSetupResult> enableMfa(MfaEnableRequest request) =>
      _remoteDataSource.enableMfa(request);

  Future<void> enableEmailMfa(MfaEnableEmailRequest request) =>
      _remoteDataSource.enableEmailMfa(request);

  Future<void> verifyMfaEnable(MfaEnableVerifyRequest request) =>
      _remoteDataSource.verifyMfaEnable(request);
}
