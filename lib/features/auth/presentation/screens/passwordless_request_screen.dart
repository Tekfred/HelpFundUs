import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/auth_scaffold.dart';
import '../../../../core/widgets/auth_text_field.dart';
import '../../../../core/widgets/otp_input.dart';

class PasswordlessRequestScreen extends StatefulWidget {
  const PasswordlessRequestScreen({
    super.key,
    required this.onBack,
    required this.onCodeSent,
    required this.onBackToPassword,
  });

  final VoidCallback onBack;
  final ValueChanged<String> onCodeSent;
  final VoidCallback onBackToPassword;

  @override
  State<PasswordlessRequestScreen> createState() => _PasswordlessRequestScreenState();
}

class _PasswordlessRequestScreenState extends State<PasswordlessRequestScreen> {
  final _identifier = TextEditingController();
  bool _sent = false;
  String? _error;

  void _send() {
    if (_identifier.text.trim().isEmpty) {
      setState(() => _error = 'Enter the email or phone number on your account.');
      return;
    }
    if (_identifier.text.trim() == 'unknown@example.com') {
      setState(() => _error = "We couldn't find an account matching that.");
      return;
    }
    setState(() {
      _error = null;
      _sent = true;
    });
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
      children: [
        if (!_sent) ...[
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.sms_outlined, color: AppColors.primary, size: 28),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            "We'll text or email you a one-time code — no password needed. "
            'The code expires a few minutes after it\'s sent.',
            style: AppTextStyles.bodyMd,
          ),
          const SizedBox(height: AppSpacing.lg),
          AuthTextField(
            label: 'Email or phone number',
            controller: _identifier,
            hint: 'jane@example.com',
            keyboardType: TextInputType.emailAddress,
            errorText: _error,
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(label: 'Request Code', onPressed: _send),
        ] else ...[
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.mark_email_read_outlined, color: AppColors.primary, size: 28),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Code sent to', style: AppTextStyles.bodyMd),
          Text(_identifier.text, style: AppTextStyles.h3),
          const SizedBox(height: AppSpacing.lg),
          Center(child: ResendCountdown(seconds: 45, onResend: () {})),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(label: 'Continue', onPressed: () => widget.onCodeSent(_identifier.text)),
        ],
        const SizedBox(height: AppSpacing.md),
        Center(
          child: GestureDetector(
            onTap: widget.onBackToPassword,
            child: Text('Use password instead', style: AppTextStyles.buttonMd.copyWith(color: AppColors.primary)),
          ),
        ),
      ],
    );
  }
}
