import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/auth_scaffold.dart';
import '../../../../core/widgets/auth_text_field.dart';
import '../../../../core/widgets/google_auth_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    super.key,
    required this.onBack,
    required this.onSignedIn,
    required this.onForgotPassword,
    required this.onPasswordless,
    required this.onCreateAccount,
    required this.onAccountRestricted,
  });

  final VoidCallback onBack;
  final VoidCallback onSignedIn;
  final VoidCallback onForgotPassword;
  final VoidCallback onPasswordless;
  final VoidCallback onCreateAccount;
  final VoidCallback onAccountRestricted;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  bool _simulateSuspended = false;

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (_simulateSuspended) {
      widget.onAccountRestricted();
    } else {
      widget.onSignedIn();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Sign In',
      onBack: widget.onBack,
      children: [
        AuthTextField(
          label: 'Email or phone number',
          controller: _identifier,
          hint: 'jane@example.com',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppSpacing.md),
        AuthTextField(
          label: 'Password',
          controller: _password,
          hint: 'Enter your password',
          togglableObscure: true,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: widget.onForgotPassword,
            child: Text('Forgot password?', style: AppTextStyles.buttonMd.copyWith(color: AppColors.primary)),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        PrimaryButton(label: 'Sign In', onPressed: _submit),
        const SizedBox(height: AppSpacing.md),
        Center(
          child: TextButton(
            onPressed: widget.onPasswordless,
            child: Text('Sign in with a one-time code instead', style: AppTextStyles.bodyMd),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        const OrDivider(),
        const SizedBox(height: AppSpacing.md),
        GoogleAuthButton(label: 'Sign in with Google', onPressed: () {}),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              Text('New to HelpFundUs? ', style: AppTextStyles.bodyMd),
              GestureDetector(
                onTap: widget.onCreateAccount,
                child: Text('Create account', style: AppTextStyles.buttonMd.copyWith(color: AppColors.primary)),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderStrong, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            children: [
              Text('Demo:', style: AppTextStyles.bodySm),
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() => _simulateSuspended = !_simulateSuspended),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
                  decoration: BoxDecoration(
                    color: _simulateSuspended ? AppColors.danger.withValues(alpha: 0.1) : AppColors.background,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(color: _simulateSuspended ? AppColors.danger : AppColors.border),
                  ),
                  child: Text(
                    _simulateSuspended ? 'Suspended account' : 'Normal account',
                    style: AppTextStyles.bodySm.copyWith(color: _simulateSuspended ? AppColors.danger : AppColors.textSecondary),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
