import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_error_prompt.dart';
import '../../../../core/widgets/auth_scaffold.dart';
import '../../../../core/widgets/auth_text_field.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/models/password_reset_request.dart';
import '../../data/repositories/auth_repository.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    super.key,
    required this.onBack,
    required this.onBackToSignIn,
    this.authRepository,
  });
  final VoidCallback onBack;
  final VoidCallback onBackToSignIn;
  final AuthRepository? authRepository;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _identifier = TextEditingController();
  bool _sent = false;
  bool _sending = false;
  String? _error;
  late final AuthRepository _authRepository;

  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  @override
  void initState() {
    super.initState();
    _authRepository =
        widget.authRepository ??
        AuthRepository(AuthRemoteDataSource(ApiClient()));
  }

  @override
  void dispose() {
    _identifier.dispose();
    super.dispose();
  }

  Future<void> _sendResetInstructions() async {
    final email = _identifier.text.trim();
    if (!_emailPattern.hasMatch(email)) {
      setState(() => _error = 'Please enter a valid email address.');
      return;
    }
    if (_sending) return;

    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      await _authRepository.requestPasswordReset(
        PasswordResetRequest(email: email),
      );
      if (mounted) setState(() => _sent = true);
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Unable to send reset instructions. Try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Reset password',
      onBack: widget.onBack,
      bodyMainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!_sent) ...[
          Text(
            'Forgot your password?',
            style: AppTextStyles.h2.copyWith(
              fontSize: 26,
              color: context.appTextPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            "Enter your email and we'll send instructions to reset your password.",
            style: AppTextStyles.bodyMd.copyWith(
              fontSize: 16,
              height: 1.42,
              color: context.appTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          if (_error != null) ...[
            AppErrorPrompt(
              message: _error!,
              onDismiss: () => setState(() => _error = null),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          AuthTextField(
            label: 'Email address',
            controller: _identifier,
            hint: 'jane@example.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
              setState(() {});
            },
            onSubmitted: (_) => _sendResetInstructions(),
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            label: 'Send Reset Instructions',
            isLoading: _sending,
            onPressed: _identifier.text.trim().isEmpty
                ? null
                : _sendResetInstructions,
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
          Text(
            'Check your inbox',
            style: AppTextStyles.h2.copyWith(
              fontSize: 26,
              color: context.appTextPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            "If an account matches ${_identifier.text.isEmpty ? 'what you entered' : _identifier.text}, "
            "we've sent instructions to reset the password. It can take a few minutes to arrive.",
            style: AppTextStyles.bodyMd.copyWith(
              fontSize: 16,
              height: 1.42,
              color: context.appTextSecondary,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: GestureDetector(
            onTap: widget.onBackToSignIn,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_back,
                  size: 16,
                  color: context.appTextSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Back to Sign In',
                  style: AppTextStyles.buttonMd.copyWith(
                    color: context.appTextSecondary,
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
