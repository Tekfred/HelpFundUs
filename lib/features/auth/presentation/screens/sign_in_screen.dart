import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_error_prompt.dart';
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
  bool _showEmptyCredentialsPrompt = false;
  Timer? _credentialsPromptTimer;

  @override
  void dispose() {
    _credentialsPromptTimer?.cancel();
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (_identifier.text.trim().isEmpty || _password.text.isEmpty) {
      _showIncompleteCredentialsPrompt();
      return;
    }

    widget.onSignedIn();
  }

  void _showIncompleteCredentialsPrompt() {
    _credentialsPromptTimer?.cancel();

    if (!_showEmptyCredentialsPrompt) {
      setState(() => _showEmptyCredentialsPrompt = true);
    }

    _credentialsPromptTimer = Timer(const Duration(seconds: 8), () {
      if (mounted) {
        setState(() => _showEmptyCredentialsPrompt = false);
      }
    });
  }

  void _onCredentialsChanged(String _) {
    final hasBothCredentials =
        _identifier.text.trim().isNotEmpty && _password.text.isNotEmpty;
    if (hasBothCredentials && _showEmptyCredentialsPrompt) {
      _credentialsPromptTimer?.cancel();
      setState(() => _showEmptyCredentialsPrompt = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Sign In',
      onBack: widget.onBack,
      children: [
        AnimatedSwitcher(
          duration: AppMotion.fast,
          reverseDuration: AppMotion.fast,
          transitionBuilder: (child, animation) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );
            return SizeTransition(
              sizeFactor: curvedAnimation,
              alignment: Alignment.topCenter,
              child: FadeTransition(
                opacity: curvedAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.04),
                    end: Offset.zero,
                  ).animate(curvedAnimation),
                  child: child,
                ),
              ),
            );
          },
          child: _showEmptyCredentialsPrompt
              ? Column(
                  key: ValueKey('incomplete-credentials-prompt'),
                  children: [
                    _EmptyCredentialsPrompt(
                      onDismiss: () {
                        _credentialsPromptTimer?.cancel();
                        setState(() => _showEmptyCredentialsPrompt = false);
                      },
                    ),
                    SizedBox(height: AppSpacing.lg),
                  ],
                )
              : const SizedBox(key: ValueKey('no-credentials-prompt')),
        ),
        AuthTextField(
          label: 'Email or phone number',
          controller: _identifier,
          hint: 'jane@example.com',
          keyboardType: TextInputType.emailAddress,
          onChanged: _onCredentialsChanged,
        ),
        const SizedBox(height: AppSpacing.md),
        AuthTextField(
          label: 'Password',
          controller: _password,
          hint: 'Enter your password',
          togglableObscure: true,
          onChanged: _onCredentialsChanged,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: widget.onForgotPassword,
            child: Text(
              'Forgot password?',
              style: AppTextStyles.buttonMd.copyWith(color: AppColors.primary),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        PrimaryButton(label: 'Sign In', onPressed: _submit),
        const SizedBox(height: AppSpacing.md),
        Center(
          child: TextButton(
            onPressed: widget.onPasswordless,
            child: Text(
              'Sign in with a one-time code instead',
              style: AppTextStyles.bodyMd.copyWith(
                color: context.appTextSecondary,
              ),
            ),
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
              Text(
                'New to HelpFundUs? ',
                style: AppTextStyles.bodyMd.copyWith(
                  color: context.appTextSecondary,
                ),
              ),
              GestureDetector(
                onTap: widget.onCreateAccount,
                child: Text(
                  'Create account',
                  style: AppTextStyles.buttonMd.copyWith(
                    color: AppColors.primary,
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

class _EmptyCredentialsPrompt extends StatelessWidget {
  const _EmptyCredentialsPrompt({required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return AppErrorPrompt(
      message: 'Please enter your email and password.',
      onDismiss: onDismiss,
    );
  }
}
