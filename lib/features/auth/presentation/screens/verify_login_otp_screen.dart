import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_error_prompt.dart';
import '../../../../core/widgets/auth_scaffold.dart';
import '../../../../core/widgets/otp_input.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/models/login_otp_verification_request.dart';
import '../../data/repositories/auth_repository.dart';

class VerifyLoginOtpScreen extends StatefulWidget {
  const VerifyLoginOtpScreen({
    super.key,
    required this.destination,
    required this.onBack,
    required this.onVerified,
    required this.onNeedsMfa,
    required this.onChangeAccount,
    this.verificationId,
  });

  final String destination;
  final VoidCallback onBack;
  final VoidCallback onVerified;
  final VoidCallback onNeedsMfa;
  final VoidCallback onChangeAccount;
  final String? verificationId;

  @override
  State<VerifyLoginOtpScreen> createState() => _VerifyLoginOtpScreenState();
}

class _VerifyLoginOtpScreenState extends State<VerifyLoginOtpScreen> {
  final _otpKey = GlobalKey<OtpInputState>();
  String? _error;
  bool _verifying = false;
  late final AuthRepository _authRepository;

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepository(AuthRemoteDataSource(ApiClient()));
  }

  Future<void> _handleSubmit(String code) async {
    if (code.length < 6) return;
    final verificationId = widget.verificationId;
    if (verificationId == null || verificationId.isEmpty) {
      setState(() => _error = 'Request a new login code to continue.');
      return;
    }

    if (_verifying) return;
    setState(() {
      _verifying = true;
      _error = null;
    });
    try {
      await _authRepository.verifyLoginOtp(
        verificationId,
        LoginOtpVerificationRequest(otp: code, trustedDevice: false),
      );
      if (mounted) widget.onVerified();
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Unable to verify this code. Please try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Enter Your Code',
      onBack: widget.onBack,
      children: [
        const SizedBox(height: AppSpacing.md),
        Text(
          'We sent a login code to',
          style: AppTextStyles.bodyMd.copyWith(color: context.appTextSecondary),
        ),
        const SizedBox(height: 2),
        Text(
          widget.destination,
          style: AppTextStyles.h3.copyWith(color: context.appTextPrimary),
        ),
        const SizedBox(height: AppSpacing.xl),
        OtpInput(
          key: _otpKey,
          hasError: _error != null,
          onCompleted: _handleSubmit,
        ),
        if (_error != null) ...[
          const SizedBox(height: AppSpacing.sm),
          AppErrorPrompt(
            message: _error!,
            onDismiss: () => setState(() => _error = null),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          label: 'Verify',
          onPressed: _verifying
              ? null
              : () => _handleSubmit(_otpKey.currentState?.value ?? ''),
          isLoading: _verifying,
        ),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: ResendCountdown(onResend: () => _otpKey.currentState?.clear()),
        ),
        const SizedBox(height: AppSpacing.sm),
        Center(
          child: GestureDetector(
            onTap: widget.onChangeAccount,
            child: Text(
              'Not you? Switch account',
              style: AppTextStyles.buttonMd.copyWith(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
