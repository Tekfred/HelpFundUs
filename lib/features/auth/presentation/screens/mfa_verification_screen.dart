import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_error_prompt.dart';
import '../../../../core/widgets/auth_scaffold.dart';
import '../../../../core/widgets/otp_input.dart';

enum MfaMethod { authenticator, email }

/// MFA challenge UI. Verification stays unconnected until the backend provides
/// a post-login MFA challenge verification contract.
class MfaVerificationScreen extends StatefulWidget {
  const MfaVerificationScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  State<MfaVerificationScreen> createState() => _MfaVerificationScreenState();
}

class _MfaVerificationScreenState extends State<MfaVerificationScreen> {
  MfaMethod _method = MfaMethod.authenticator;
  bool _trustDevice = false;
  bool _isComplete = false;
  final _otpKey = GlobalKey<OtpInputState>();
  String? _error;

  void _selectMethod(MfaMethod method) {
    if (_method == method) return;
    setState(() {
      _method = method;
      _error = null;
      _isComplete = false;
    });
    _otpKey.currentState?.clear();
  }

  void _handleVerify() {
    if (!_isComplete) return;
    setState(() {
      _error =
          'Two-step verification is not connected yet. Please try again later.';
    });
  }

  void _showUnavailable(String feature) {
    setState(() => _error = '$feature is not available yet.');
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Two-step verification',
      onBack: widget.onBack,
      bodyMainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            const SizedBox(height: AppSpacing.xl),
            Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.055),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.shield_outlined,
                color: AppColors.primary,
                size: 48,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              "Verify it's you",
              textAlign: TextAlign.center,
              style: AppTextStyles.h1.copyWith(color: context.appTextPrimary),
            ),
            const SizedBox(height: AppSpacing.sm),
            AnimatedSwitcher(
              duration: AppMotion.fast,
              child: Text(
                _method == MfaMethod.authenticator
                    ? 'Enter the 6-digit code from your authenticator app.'
                    : 'Enter the 6-digit code sent to your email.',
                key: ValueKey(_method),
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLg.copyWith(
                  color: context.appTextSecondary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _MethodTab(
                  label: 'Authenticator app',
                  selected: _method == MfaMethod.authenticator,
                  onTap: () => _selectMethod(MfaMethod.authenticator),
                ),
                const SizedBox(width: AppSpacing.sm),
                _MethodTab(
                  label: 'Email code',
                  selected: _method == MfaMethod.email,
                  onTap: () => _selectMethod(MfaMethod.email),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            OtpInput(
              key: _otpKey,
              hasError: _error != null,
              onChanged: (code) {
                final complete = code.length == 6;
                if (_isComplete != complete || _error != null) {
                  setState(() {
                    _isComplete = complete;
                    _error = null;
                  });
                }
              },
              onCompleted: (_) {},
            ),
            const SizedBox(height: AppSpacing.lg),
            Semantics(
              checked: _trustDevice,
              label: 'Trust this device for 30 days',
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                onTap: () => setState(() => _trustDevice = !_trustDevice),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: AppMotion.fast,
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: _trustDevice
                              ? AppColors.primary
                              : context.appSurface,
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(
                            color: _trustDevice
                                ? AppColors.primary
                                : context.appBorderStrong,
                            width: 1.5,
                          ),
                        ),
                        child: _trustDevice
                            ? const Icon(
                                Icons.check,
                                size: 17,
                                color: AppColors.surface,
                              )
                            : null,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        'Trust this device for 30 days',
                        style: AppTextStyles.bodyMd.copyWith(
                          color: context.appTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TextAction(
                  label: 'Use backup code',
                  onTap: () => _showUnavailable('Backup-code verification'),
                ),
                Container(width: 1, height: 24, color: context.appDivider),
                _TextAction(
                  label: 'Security help',
                  onTap: () => _showUnavailable('Security help'),
                ),
              ],
            ),
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.md),
              AppErrorPrompt(
                message: _error!,
                onDismiss: () => setState(() => _error = null),
              ),
            ],
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.xl,
            bottom: AppSpacing.md,
          ),
          child: PrimaryButton(
            label: 'Verify',
            onPressed: _isComplete ? _handleVerify : null,
          ),
        ),
      ],
    );
  }
}

class _MethodTab extends StatelessWidget {
  const _MethodTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '$label${selected ? ', selected' : ''}',
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : context.appSurface,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: selected ? AppColors.primary : context.appBorderStrong,
              width: 1.3,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.buttonMd.copyWith(
              color: selected ? AppColors.surface : context.appTextSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _TextAction extends StatelessWidget {
  const _TextAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: AppTextStyles.buttonMd.copyWith(color: context.appTextSecondary),
      ),
    );
  }
}
