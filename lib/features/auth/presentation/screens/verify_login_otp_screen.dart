import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/auth_scaffold.dart';
import '../../../../core/widgets/otp_input.dart';

class VerifyLoginOtpScreen extends StatefulWidget {
  const VerifyLoginOtpScreen({
    super.key,
    required this.destination,
    required this.onBack,
    required this.onVerified,
    required this.onNeedsMfa,
    required this.onChangeAccount,
  });

  final String destination;
  final VoidCallback onBack;
  final VoidCallback onVerified;
  final VoidCallback onNeedsMfa;
  final VoidCallback onChangeAccount;

  @override
  State<VerifyLoginOtpScreen> createState() => _VerifyLoginOtpScreenState();
}

class _VerifyLoginOtpScreenState extends State<VerifyLoginOtpScreen> {
  final _otpKey = GlobalKey<OtpInputState>();
  String? _error;
  bool _requireMfaDemo = false;

  void _handleSubmit(String code) {
    if (code.length < 6) return;
    if (code == '000000') {
      setState(() => _error = 'That code has expired. Request a new one.');
      return;
    }
    setState(() => _error = null);
    if (_requireMfaDemo) {
      widget.onNeedsMfa();
    } else {
      widget.onVerified();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Enter Your Code',
      onBack: widget.onBack,
      children: [
        const SizedBox(height: AppSpacing.md),
        Text('We sent a login code to', style: AppTextStyles.bodyMd),
        const SizedBox(height: 2),
        Text(widget.destination, style: AppTextStyles.h3),
        const SizedBox(height: AppSpacing.xl),
        OtpInput(
          key: _otpKey,
          hasError: _error != null,
          onCompleted: _handleSubmit,
        ),
        if (_error != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(
                Icons.error_outline,
                size: 16,
                color: AppColors.danger,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _error!,
                  style: AppTextStyles.bodySm.copyWith(color: AppColors.danger),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          label: 'Verify',
          onPressed: () => _handleSubmit(_otpKey.currentState?.value ?? ''),
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
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: GestureDetector(
            // Demo affordance for previewing the MFA-required redirect.
            onTap: () => setState(() => _requireMfaDemo = !_requireMfaDemo),
            child: Text(
              _requireMfaDemo
                  ? 'Demo: will redirect to MFA next'
                  : 'This account requires extra verification?',
              style: AppTextStyles.bodySm,
            ),
          ),
        ),
      ],
    );
  }
}
