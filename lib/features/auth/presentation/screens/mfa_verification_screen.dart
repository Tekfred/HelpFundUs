import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/auth_scaffold.dart';
import '../../../../core/widgets/otp_input.dart';

enum MfaMethod { authenticator, email }

class MfaVerificationScreen extends StatefulWidget {
  const MfaVerificationScreen({
    super.key,
    required this.onBack,
    required this.onVerified,
    required this.onUseBackupCode,
  });

  final VoidCallback onBack;
  final VoidCallback onVerified;
  final VoidCallback onUseBackupCode;

  @override
  State<MfaVerificationScreen> createState() => _MfaVerificationScreenState();
}

class _MfaVerificationScreenState extends State<MfaVerificationScreen> {
  MfaMethod _method = MfaMethod.authenticator;
  bool _trustDevice = false;
  final _otpKey = GlobalKey<OtpInputState>();
  String? _error;

  void _handleSubmit(String code) {
    if (code.length < 6) return;
    setState(() => _error = code == '000000' ? 'Incorrect code. Try again.' : null);
    if (_error == null) widget.onVerified();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Two-Factor Verification',
      onBack: widget.onBack,
      children: [
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _MethodTab(
                label: 'Authenticator app',
                selected: _method == MfaMethod.authenticator,
                onTap: () => setState(() => _method = MfaMethod.authenticator),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _MethodTab(
                label: 'Email code',
                selected: _method == MfaMethod.email,
                onTap: () => setState(() => _method = MfaMethod.email),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          _method == MfaMethod.authenticator
              ? 'Enter the 6-digit code from your authenticator app.'
              : "Enter the 6-digit code we just emailed to you.",
          style: AppTextStyles.bodyMd,
        ),
        const SizedBox(height: AppSpacing.lg),
        OtpInput(key: _otpKey, hasError: _error != null, onCompleted: _handleSubmit),
        if (_error != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(Icons.error_outline, size: 16, color: AppColors.danger),
              const SizedBox(width: 6),
              Text(_error!, style: AppTextStyles.bodySm.copyWith(color: AppColors.danger)),
            ],
          ),
        ],
        if (_method == MfaMethod.email) ...[
          const SizedBox(height: AppSpacing.md),
          Align(alignment: Alignment.centerLeft, child: ResendCountdown(onResend: () => _otpKey.currentState?.clear())),
        ],
        const SizedBox(height: AppSpacing.md),
        GestureDetector(
          onTap: () => setState(() => _trustDevice = !_trustDevice),
          child: Row(
            children: [
              AnimatedContainer(
                duration: AppMotion.fast,
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: _trustDevice ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: _trustDevice ? AppColors.primary : AppColors.borderStrong, width: 1.4),
                ),
                child: _trustDevice ? const Icon(Icons.check, size: 15, color: AppColors.surface) : null,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text('Trust this device for 30 days', style: AppTextStyles.bodyMd)),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(label: 'Verify', onPressed: () => _handleSubmit(_otpKey.currentState?.value ?? '')),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: GestureDetector(
            onTap: widget.onUseBackupCode,
            child: Text('Use a backup code instead', style: AppTextStyles.buttonMd.copyWith(color: AppColors.primary)),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Center(
          child: Text('Having trouble? Contact security support', style: AppTextStyles.bodySm),
        ),
      ],
    );
  }
}

class _MethodTab extends StatelessWidget {
  const _MethodTab({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.fast,
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: selected ? AppColors.primary : AppColors.borderStrong),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.buttonMd.copyWith(color: selected ? AppColors.surface : AppColors.textPrimary),
        ),
      ),
    );
  }
}
