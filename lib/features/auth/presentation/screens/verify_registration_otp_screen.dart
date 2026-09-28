import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_error_prompt.dart';
import '../../../../core/widgets/auth_scaffold.dart';
import '../../../../core/widgets/otp_input.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/models/resend_otp_request.dart';
import '../../data/repositories/auth_repository.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception.dart';

class VerifyRegistrationOtpScreen extends StatefulWidget {
  const VerifyRegistrationOtpScreen({
    super.key,
    required this.destination,
    required this.phone,
    this.verificationId,
    required this.onBack,
    required this.onVerified,
    required this.onChangeDestination,
    this.allowImmediateResend = false,
  });

  /// Registration email address used to receive the verification code.
  final String destination;
  final String phone;

  /// Provided by registration. The unverified-login response currently does
  /// not expose this backend identifier.
  final String? verificationId;
  final VoidCallback onBack;
  final VoidCallback onVerified;
  final VoidCallback onChangeDestination;
  final bool allowImmediateResend;

  @override
  State<VerifyRegistrationOtpScreen> createState() =>
      _VerifyRegistrationOtpScreenState();
}

class _VerifyRegistrationOtpScreenState
    extends State<VerifyRegistrationOtpScreen> {
  final _otpKey = GlobalKey<OtpInputState>();
  String? _error;
  String _code = '';
  String? _verificationId;
  bool _verifying = false;
  late final AuthRepository _authRepository;

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepository(AuthRemoteDataSource(ApiClient()));
    _verificationId = widget.verificationId;
  }

  Future<void> _handleSubmit(String code) async {
    if (code.length != 6 || _verifying) return;

    final verificationId = _verificationId;
    if (verificationId == null || verificationId.isEmpty) {
      setState(() {
        _error =
            'Request a new code to continue. Verification will be available once the account identifier is provided.';
      });
      return;
    }

    setState(() {
      _verifying = true;
      _error = null;
    });
    try {
      await _authRepository.verifyOtp(id: verificationId, otp: code);
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

  Future<bool> _resendOtp() async {
    try {
      final result = await _authRepository.resendOtp(
        ResendOtpRequest(
          identifier: widget.destination,
          email: widget.destination,
        ),
      );
      if (mounted) setState(() => _verificationId = result.userId);
      return true;
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
      return false;
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Unable to resend the code. Please try again.');
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Verify Your Account',
      onBack: widget.onBack,
      children: [
        const SizedBox(height: AppSpacing.md),
        Text(
          'We sent a 6-digit code to',
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
          onChanged: (code) {
            if (_code != code || _error != null) {
              setState(() {
                _code = code;
                _error = null;
              });
            }
          },
          onCompleted: (_) {},
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
          onPressed: _code.length == 6 && !_verifying
              ? () => _handleSubmit(_code)
              : null,
          isLoading: _verifying,
        ),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: ResendCountdown(
            seconds: widget.allowImmediateResend ? 0 : 60,
            onResendAsync: _resendOtp,
            onResend: () {
              _otpKey.currentState?.clear();
              setState(() {
                _code = '';
                _error = null;
              });
            },
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Center(
          child: GestureDetector(
            onTap: widget.onChangeDestination,
            child: Text(
              'Change email or phone number',
              style: AppTextStyles.buttonMd.copyWith(color: AppColors.primary),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Center(
          child: Text(
            'Need help? Contact support',
            style: AppTextStyles.bodySm.copyWith(color: context.appTextMuted),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}
