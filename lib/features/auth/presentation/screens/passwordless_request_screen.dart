import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_error_prompt.dart';
import '../../../../core/widgets/auth_scaffold.dart';
import '../../../../core/widgets/auth_text_field.dart';
import '../../../../core/widgets/otp_input.dart';
import '../../../../core/device/device_identifier.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/models/login_otp_request.dart';
import '../../data/repositories/auth_repository.dart';

class PasswordlessRequestScreen extends StatefulWidget {
  const PasswordlessRequestScreen({
    super.key,
    required this.onBack,
    required this.onCodeSent,
    required this.onBackToPassword,
  });

  final VoidCallback onBack;
  final void Function(String destination, String verificationId) onCodeSent;
  final VoidCallback onBackToPassword;

  @override
  State<PasswordlessRequestScreen> createState() =>
      _PasswordlessRequestScreenState();
}

class _PasswordlessRequestScreenState extends State<PasswordlessRequestScreen> {
  final _identifier = TextEditingController();
  bool _sent = false;
  String? _error;
  bool _requesting = false;
  String? _verificationId;
  late final AuthRepository _authRepository;

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepository(AuthRemoteDataSource(ApiClient()));
  }

  Future<void> _send() async {
    if (_identifier.text.trim().isEmpty) {
      setState(
        () => _error = 'Enter the email or phone number on your account.',
      );
      return;
    }
    if (_requesting) return;
    setState(() {
      _error = null;
      _requesting = true;
    });
    try {
      final result = await _authRepository.requestLoginOtp(
        LoginOtpRequest(
          identifier: _identifier.text.trim(),
          deviceId: await DeviceIdentifier.getOrCreate(),
        ),
      );
      if (mounted) {
        setState(() {
          _verificationId = result.verificationId;
          _sent = true;
        });
      }
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Unable to request a code. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _requesting = false);
    }
  }

  @override
  void dispose() {
    _identifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Sign In with a Code',
      onBack: widget.onBack,
      bodyMainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!_sent) ...[
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.sms_outlined,
                color: AppColors.primary,
                size: 28,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            "We'll text or email you a one-time code — no password needed. "
            'The code expires a few minutes after it\'s sent.',
            style: AppTextStyles.bodyMd.copyWith(
              color: context.appTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          if (_error != null) ...[
            AppErrorPrompt(
              message: _error!,
              onDismiss: () => setState(() => _error = null),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          AuthTextField(
            label: 'Email or phone number',
            controller: _identifier,
            hint: 'jane@example.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: 'Request Code',
            onPressed: _requesting ? null : _send,
            isLoading: _requesting,
          ),
        ] else ...[
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mark_email_read_outlined,
                color: AppColors.primary,
                size: 28,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Text(
              'Code sent to',
              style: AppTextStyles.bodyMd.copyWith(
                color: context.appTextSecondary,
              ),
            ),
          ),
          Center(
            child: Text(
              _identifier.text,
              style: AppTextStyles.h3.copyWith(color: context.appTextPrimary),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(child: ResendCountdown(seconds: 45, onResend: () {})),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: 'Continue',
            onPressed: _verificationId == null
                ? null
                : () => widget.onCodeSent(_identifier.text, _verificationId!),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        Center(
          child: GestureDetector(
            onTap: widget.onBackToPassword,
            child: Text(
              'Use password instead',
              style: AppTextStyles.buttonMd.copyWith(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
