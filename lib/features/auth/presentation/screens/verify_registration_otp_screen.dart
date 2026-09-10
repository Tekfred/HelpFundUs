import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/auth_scaffold.dart';
import '../../../../core/widgets/otp_input.dart';

class VerifyRegistrationOtpScreen extends StatefulWidget {
  const VerifyRegistrationOtpScreen({
    super.key,
    required this.destination,
    required this.onBack,
    required this.onVerified,
    required this.onChangeDestination,
  });

  /// Already-masked value, e.g. "j•••e@example.com" or "+233 •• •• 4821".
  final String destination;
  final VoidCallback onBack;
  final VoidCallback onVerified;
  final VoidCallback onChangeDestination;

  @override
  State<VerifyRegistrationOtpScreen> createState() =>
      _VerifyRegistrationOtpScreenState();
}

class _VerifyRegistrationOtpScreenState
    extends State<VerifyRegistrationOtpScreen> {
  final _otpKey = GlobalKey<OtpInputState>();
  String? _error;
  bool _expiredDemo = false;

  void _handleSubmit(String code) {
    setState(() {
      if (_expiredDemo) {
        _error = 'This code has expired. Request a new one to continue.';
      } else if (code != '123456') {
        _error = "That code doesn't match. Check it and try again.";
      } else {
        _error = null;
      }
    });
    if (_error == null) widget.onVerified();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Verify Your Account',
      onBack: widget.onBack,
      children: [
        const SizedBox(height: AppSpacing.md),
        Text('We sent a 6-digit code to', style: AppTextStyles.bodyMd),
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
          child: ResendCountdown(
            onResend: () {
              _otpKey.currentState?.clear();
              setState(() {
                _error = null;
                _expiredDemo = false;
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
          child: GestureDetector(
            // Demo affordance only — lets you preview the expired-code state
            // without wiring a real backend yet.
            onTap: () => setState(() => _expiredDemo = !_expiredDemo),
            child: Text(
              _expiredDemo
                  ? 'Demo: expired-code state ON — enter any code'
                  : 'Need help? Contact support',
              style: AppTextStyles.bodySm,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}
