import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/auth_scaffold.dart';
import '../../../../core/widgets/auth_text_field.dart';
import '../../../../core/widgets/country_code_selector.dart';
import '../../../../core/widgets/google_auth_button.dart';
import '../../../../core/widgets/password_strength_meter.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({
    super.key,
    required this.onBack,
    required this.onCreated,
    required this.onSignIn,
  });
  final VoidCallback onBack;
  final VoidCallback onCreated;
  final VoidCallback onSignIn;

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  Country _country = kCountries.first;
  bool _agreed = false;
  String _passwordValue = '';

  bool get _canSubmit =>
      _firstName.text.isNotEmpty &&
      _lastName.text.isNotEmpty &&
      _email.text.isNotEmpty &&
      _phone.text.isNotEmpty &&
      scorePassword(_passwordValue) != PasswordStrength.empty &&
      _agreed;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Create Account',
      onBack: widget.onBack,
      children: [
        Row(
          children: [
            Expanded(
              child: AuthTextField(
                label: 'First name',
                controller: _firstName,
                hint: 'Jane',
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: AuthTextField(
                label: 'Last name',
                controller: _lastName,
                hint: 'Doe',
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        AuthTextField(
          label: 'Email address',
          controller: _email,
          hint: 'jane@example.com',
          keyboardType: TextInputType.emailAddress,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Phone number', style: AppTextStyles.buttonMd),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            CountryCodeSelector(
              selected: _country,
              onChanged: (c) => setState(() => _country = c),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: AuthTextField(
                label: '',
                controller: _phone,
                hint: '(555) 000-0000',
                keyboardType: TextInputType.phone,
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        AuthTextField(
          label: 'Password',
          controller: _password,
          hint: 'Create a strong password',
          togglableObscure: true,
          onChanged: (v) => setState(() => _passwordValue = v),
        ),
        const SizedBox(height: AppSpacing.sm),
        PasswordStrengthMeter(password: _passwordValue),
        const SizedBox(height: AppSpacing.md),
        GestureDetector(
          onTap: () => setState(() => _agreed = !_agreed),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: AppMotion.fast,
                width: 22,
                height: 22,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: _agreed ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: _agreed ? AppColors.primary : AppColors.borderStrong,
                    width: 1.4,
                  ),
                ),
                child: _agreed
                    ? const Icon(
                        Icons.check,
                        size: 15,
                        color: AppColors.surface,
                      )
                    : null,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: AppTextStyles.bodyMd,
                    children: [
                      const TextSpan(text: 'I agree to the '),
                      TextSpan(
                        text: 'Terms of Service',
                        style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          label: 'Create Account',
          onPressed: _canSubmit ? widget.onCreated : null,
        ),
        const SizedBox(height: AppSpacing.md),
        const OrDivider(),
        const SizedBox(height: AppSpacing.md),
        GoogleAuthButton(label: 'Continue with Google', onPressed: () {}),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              Text('Already have an account? ', style: AppTextStyles.bodyMd),
              GestureDetector(
                onTap: widget.onSignIn,
                child: Text(
                  'Sign In',
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
