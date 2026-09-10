import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/auth_scaffold.dart';
import '../../../../core/widgets/auth_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    super.key,
    required this.onBack,
    required this.onBackToSignIn,
  });
  final VoidCallback onBack;
  final VoidCallback onBackToSignIn;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _identifier = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _identifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Reset Password',
      onBack: widget.onBack,
      children: [
        const SizedBox(height: AppSpacing.lg),
        if (!_sent) ...[
          Text('Forgot your password?', style: AppTextStyles.h1),
          const SizedBox(height: AppSpacing.sm),
          Text(
            "Enter your email or phone number and we'll send instructions to reset your password.",
            style: AppTextStyles.bodyMd,
          ),
          const SizedBox(height: AppSpacing.lg),
          AuthTextField(
            label: 'Email or phone number',
            controller: _identifier,
            hint: 'jane@example.com',
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: 'Send Reset Instructions',
            onPressed: _identifier.text.trim().isEmpty
                ? null
                : () => setState(() => _sent = true),
          ),
        ] else ...[
          Container(
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
          const SizedBox(height: AppSpacing.md),
          Text('Check your inbox', style: AppTextStyles.h1),
          const SizedBox(height: AppSpacing.sm),
          Text(
            "If an account matches ${_identifier.text.isEmpty ? 'what you entered' : _identifier.text}, "
            "we've sent instructions to reset the password. It can take a few minutes to arrive.",
            style: AppTextStyles.bodyMd,
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        Center(
          child: GestureDetector(
            onTap: widget.onBackToSignIn,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.arrow_back,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Back to Sign In',
                  style: AppTextStyles.buttonMd.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
