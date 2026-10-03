import 'package:flutter/gestures.dart';
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
import '../../../../core/widgets/country_code_selector.dart';
import '../../../../core/widgets/google_auth_button.dart';
import '../../../../core/widgets/password_strength_meter.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/models/register_request.dart';
import '../../data/repositories/auth_repository.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({
    super.key,
    required this.onBack,
    required this.onCreated,
    required this.onSignIn,
    this.authRepository,
  });
  final VoidCallback onBack;
  final void Function(String email, String phone, String verificationId)
  onCreated;
  final VoidCallback onSignIn;
  final AuthRepository? authRepository;

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
  _AccountType _accountType = _AccountType.individual;
  bool _agreed = false;
  String _passwordValue = '';
  late final AuthRepository _authRepository;
  bool _submitting = false;
  String? _requestError;

  static final RegExp _emailAddressPattern = RegExp(
    r"^[A-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?(?:\.[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?)+$",
    caseSensitive: false,
  );

  bool get _hasValidEmail => _emailAddressPattern.hasMatch(_email.text.trim());

  String? get _emailError {
    if (_email.text.isEmpty || _hasValidEmail) return null;
    return 'Enter a valid email address.';
  }

  bool get _canSubmit =>
      _firstName.text.isNotEmpty &&
      _lastName.text.isNotEmpty &&
      _hasValidEmail &&
      _phone.text.isNotEmpty &&
      _accountType.apiValue != null &&
      scorePassword(_passwordValue) != PasswordStrength.empty &&
      _agreed;

  @override
  void initState() {
    super.initState();
    _authRepository =
        widget.authRepository ??
        AuthRepository(AuthRemoteDataSource(ApiClient()));
  }

  Future<void> _submit() async {
    if (!_canSubmit || _submitting) return;

    setState(() => _submitting = true);
    try {
      final result = await _authRepository.register(
        RegisterRequest(
          firstName: _firstName.text.trim(),
          lastName: _lastName.text.trim(),
          email: _email.text.trim(),
          phone: '${_country.dialCode}${_phone.text.trim()}'.replaceAll(
            RegExp(r'\s+'),
            '',
          ),
          password: _password.text,
          accountType: _accountType.apiValue!,
        ),
      );
      if (mounted) {
        widget.onCreated(
          _email.text.trim(),
          '${_country.dialCode}${_phone.text.trim()}'.replaceAll(
            RegExp(r'\s+'),
            '',
          ),
          result.verificationId,
        );
      }
    } on ApiException catch (error) {
      if (mounted) _showRequestError(error.message);
    } catch (_) {
      if (mounted) {
        _showRequestError('Unable to create your account. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showRequestError(String message) {
    setState(() => _requestError = message);
  }

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
        AnimatedSwitcher(
          duration: AppMotion.fast,
          child: _requestError == null
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: AppErrorPrompt(
                    key: const ValueKey('registration-error'),
                    message: _requestError!,
                    onDismiss: () => setState(() => _requestError = null),
                  ),
                ),
        ),
        Row(
          children: [
            Expanded(
              child: AuthTextField(
                label: 'First name',
                controller: _firstName,
                hint: 'Jane',
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                onChanged: (_) => setState(() => _requestError = null),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: AuthTextField(
                label: 'Last name',
                controller: _lastName,
                hint: 'Doe',
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                onChanged: (_) => setState(() => _requestError = null),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _AccountTypeSelector(
          selected: _accountType,
          onChanged: (accountType) => setState(() {
            _accountType = accountType;
            _requestError = accountType.apiValue == null
                ? 'Organization registration is not available yet.'
                : null;
          }),
        ),
        const SizedBox(height: AppSpacing.md),
        AuthTextField(
          label: 'Email address',
          controller: _email,
          hint: 'jane@example.com',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          errorText: _emailError,
          onChanged: (_) => setState(() => _requestError = null),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Phone number',
          style: AppTextStyles.buttonMd.copyWith(color: context.appTextPrimary),
        ),
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
                textInputAction: TextInputAction.next,
                onChanged: (_) => setState(() => _requestError = null),
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
          textInputAction: TextInputAction.done,
          onChanged: (v) => setState(() {
            _passwordValue = v;
            _requestError = null;
          }),
        ),
        const SizedBox(height: AppSpacing.sm),
        PasswordCreationFeedback(password: _passwordValue),
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
                  color: _agreed ? AppColors.primary : context.appSurface,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: _agreed
                        ? AppColors.primary
                        : context.appBorderStrong,
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
                    style: AppTextStyles.bodyMd.copyWith(
                      color: context.appTextSecondary,
                    ),
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
          onPressed: _canSubmit ? _submit : null,
          isLoading: _submitting,
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
              Text(
                'Already have an account? ',
                style: AppTextStyles.bodyMd.copyWith(
                  color: context.appTextSecondary,
                ),
              ),
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

enum _AccountType {
  individual('Individual', 'INDIVIDUAL'),
  // The backend contract currently documents only INDIVIDUAL. Keep this UI
  // option ready, but do not send a guessed API value for Organization.
  organization('Organization', null);

  const _AccountType(this.label, this.apiValue);

  final String label;
  final String? apiValue;
}

class _AccountTypeSelector extends StatelessWidget {
  const _AccountTypeSelector({required this.selected, required this.onChanged});

  final _AccountType selected;
  final ValueChanged<_AccountType> onChanged;

  Future<void> _openPicker(BuildContext context) async {
    final choice = await showModalBottomSheet<_AccountType>(
      context: context,
      backgroundColor: context.appSurfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: sheetContext.appBorder,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Select account type',
                style: AppTextStyles.h3.copyWith(
                  color: sheetContext.appTextPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final accountType in _AccountType.values)
                Semantics(
                  selected: selected == accountType,
                  label:
                      '${accountType.label}${selected == accountType ? ', selected' : ''}',
                  child: ListTile(
                    leading: Icon(
                      selected == accountType
                          ? Icons.check_circle_rounded
                          : Icons.circle_outlined,
                      color: selected == accountType
                          ? AppColors.primary
                          : sheetContext.appTextMuted,
                    ),
                    title: Text(
                      accountType.label,
                      style: AppTextStyles.bodyLg.copyWith(
                        color: sheetContext.appTextPrimary,
                        fontWeight: selected == accountType
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                    onTap: () => Navigator.of(sheetContext).pop(accountType),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    if (choice != null) onChanged(choice);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Account type, ${selected.label}',
      hint: 'Tap to change account type',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account type',
            style: AppTextStyles.buttonMd.copyWith(
              color: context.appTextPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _openPicker(context),
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Container(
                height: 56,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                decoration: BoxDecoration(
                  color: context.appInput,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: context.appBorderStrong),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selected.label,
                        style: AppTextStyles.bodyLg.copyWith(
                          color: context.appTextPrimary,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: context.appTextMuted,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
