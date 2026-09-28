import 'package:helpfundus/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:helpfundus/features/auth/data/models/register_request.dart';
import 'package:helpfundus/features/auth/data/models/registration_result.dart';
import 'package:helpfundus/features/auth/data/models/resend_otp_request.dart';
import 'package:helpfundus/features/auth/data/models/resend_otp_result.dart';
import 'package:helpfundus/features/auth/data/models/login_request.dart';
import 'package:helpfundus/features/auth/data/models/login_result.dart';

/// Feature-facing authentication API. Presentation code depends on this
/// repository rather than directly on Dio or endpoint strings.
class AuthRepository {
  const AuthRepository(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  Future<RegistrationResult> register(RegisterRequest request) =>
      _remoteDataSource.register(request);

  Future<LoginResult> login(LoginRequest request) =>
      _remoteDataSource.login(request);

  Future<void> verifyOtp({required String id, required String otp}) =>
      _remoteDataSource.verifyOtp(id: id, otp: otp);

  Future<ResendOtpResult> resendOtp(ResendOtpRequest request) =>
      _remoteDataSource.resendOtp(request);
}
