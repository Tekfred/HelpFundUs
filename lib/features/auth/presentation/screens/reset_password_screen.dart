import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/auth_scaffold.dart';
import '../../../../core/widgets/auth_text_field.dart';
import '../../../../core/widgets/password_strength_meter.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    super.key,
    required this.onBack,
    required this.onReset,
  });
  final VoidCallback onBack;
  final VoidCallback onReset;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _tokenExpiredDemo = false;
  bool _done = false;

  String get _passwordValue => _password.text;
  String? get _confirmError {
    if (_confirm.text.isEmpty) return null;
    return _confirm.text == _password.text ? null : "Passwords don't match";
  }

  bool get _canSubmit =>
      scorePassword(_passwordValue) != PasswordStrength.empty &&
      _confirm.text.isNotEmpty &&
      _confirmError == null;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_tokenExpiredDemo) {
      return AuthScaffold(
        title: 'Reset Password',
        onBack: widget.onBack,
        children: [
          const SizedBox(height: AppSpacing.xl),
          const Icon(Icons.link_off, size: 48, color: AppColors.danger),
          const SizedBox(height: AppSpacing.md),
          Text(
            'This link has expired',
            style: AppTextStyles.h2.copyWith(color: context.appTextPrimary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Password reset links are only valid for a short time. Request a new one to continue.',
            style: AppTextStyles.bodyMd.copyWith(
              color: context.appTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(label: 'Request a New Link', onPressed: widget.onBack),
        ],
      );
    }

    if (_done) {
      return AuthScaffold(
        title: 'Reset Password',
        onBack: widget.onBack,
        children: [
          const SizedBox(height: AppSpacing.xl),
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: AppColors.surface, size: 30),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Password updated',
            style: AppTextStyles.h2.copyWith(color: context.appTextPrimary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Your password has been reset. Sign in with your new password to continue.',
            style: AppTextStyles.bodyMd.copyWith(
              color: context.appTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(label: 'Sign In', onPressed: widget.onReset),
        ],
      );
    }

    return AuthScaffold(
      title: 'Reset Password',
      onBack: widget.onBack,
      children: [
        const SizedBox(height: AppSpacing.sm),
        AuthTextField(
          label: 'New password',
          controller: _password,
          hint: 'Create a strong password',
          togglableObscure: true,
          textInputAction: TextInputAction.next,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: AppSpacing.sm),
        PasswordStrengthMeter(password: _passwordValue),
        const SizedBox(height: AppSpacing.md),
        AuthTextField(
          label: 'Confirm new password',
          controller: _confirm,
          hint: 'Re-enter your password',
          togglableObscure: true,
          textInputAction: TextInputAction.done,
          errorText: _confirmError,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          label: 'Reset Password',
          onPressed: _canSubmit ? () => setState(() => _done = true) : null,
        ),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: GestureDetector(
            // Demo affordance to preview the expired/invalid-token state.
            onTap: () => setState(() => _tokenExpiredDemo = true),
            child: Text(
              'Demo: preview expired-link state',
              style: AppTextStyles.bodySm.copyWith(color: context.appTextMuted),
            ),
          ),
        ),
      ],
    );
  }
}
