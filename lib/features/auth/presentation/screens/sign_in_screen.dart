import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/device/device_identifier.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_error_prompt.dart';
import '../../../../core/widgets/auth_scaffold.dart';
import '../../../../core/widgets/auth_text_field.dart';
import '../../../../core/widgets/google_auth_button.dart';
import '../../../account/data/datasources/profile_remote_data_source.dart';
import '../../../account/data/models/user_profile.dart';
import '../../../account/data/repositories/profile_repository.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/models/login_request.dart';
import '../../data/repositories/auth_repository.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    super.key,
    required this.onBack,
    required this.onSignedIn,
    required this.onForgotPassword,
    required this.onPasswordless,
    required this.onCreateAccount,
    required this.onAccountRestricted,
    this.onVerifyAccount,
    this.authRepository,
  });

  final VoidCallback onBack;
  final ValueChanged<UserProfile> onSignedIn;
  final VoidCallback onForgotPassword;
  final VoidCallback onPasswordless;
  final VoidCallback onCreateAccount;
  final VoidCallback onAccountRestricted;
  final ValueChanged<String>? onVerifyAccount;
  final AuthRepository? authRepository;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  _SignInPrompt? _prompt;
  bool _signingIn = false;
  late final AuthRepository _authRepository;

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
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_identifier.text.trim().isEmpty || _password.text.isEmpty) {
      _showPrompt(
        const _SignInPrompt(
          type: _SignInFailureType.missingCredentials,
          message: 'Please enter your email and password.',
        ),
      );
      return;
    }

    if (_signingIn) return;
    setState(() {
      _signingIn = true;
      _prompt = null;
    });
    try {
      final loginResult = await _authRepository.login(
        LoginRequest(
          identifier: _identifier.text.trim(),
          password: _password.text,
          deviceId: await DeviceIdentifier.getOrCreate(),
        ),
      );
      final profile = await ProfileRepository(
        ProfileRemoteDataSource(
          ApiClient(tokenProvider: () => loginResult.accessToken),
        ),
      ).fetchProfile();
      if (mounted) widget.onSignedIn(profile);
    } on ApiException catch (error) {
      if (mounted) {
        _showPrompt(_classifyFailure(error));
      }
    } catch (_) {
      if (mounted) {
        _showPrompt(
          const _SignInPrompt(
            type: _SignInFailureType.unknown,
            message: 'Unable to sign in. Please try again.',
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _signingIn = false);
    }
  }

  _SignInPrompt _classifyFailure(ApiException error) {
    // A 401 from the login endpoint is always a generic authentication
    // failure. It must be handled before any account-state response.
    if (_isInvalidCredentials(error)) {
      return const _SignInPrompt(
        type: _SignInFailureType.invalidCredentials,
        message: 'Incorrect email or password.',
      );
    }
    if (_isVerificationRequired(error)) {
      return const _SignInPrompt(
        type: _SignInFailureType.verificationRequired,
        message: 'Please verify your account first.',
      );
    }
    return _SignInPrompt(
      type: _SignInFailureType.requestFailed,
      message: error.message,
    );
  }

  /// Only the documented staging response qualifies for the Verify action.
  /// In particular, `isVerified: false` is not sufficient: generic invalid
  /// credential responses include that value too.
  bool _isVerificationRequired(ApiException error) {
    final data = error.data;
    if (data is! Map) return false;

    return error.statusCode == 403 &&
        _normalize(error.message) == 'please verify your account first' &&
        data['success'] == false &&
        data['isVerified'] == false &&
        data['isActive'] == true &&
        data['isSuspended'] == false;
  }

  bool _isInvalidCredentials(ApiException error) => error.statusCode == 401;

  String _normalize(String value) =>
      value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  void _showPrompt(_SignInPrompt prompt) {
    if (mounted) setState(() => _prompt = prompt);
  }

  void _clearPrompt() {
    if (mounted) setState(() => _prompt = null);
  }

  void _onCredentialsChanged(String _) {
    if (_prompt != null) _clearPrompt();
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
          child: _prompt != null
              ? Padding(
                  key: const ValueKey('login-error-prompt'),
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: AppErrorPrompt(
                    message: _prompt!.message,
                    actionLabel:
                        _prompt!.type == _SignInFailureType.verificationRequired
                        ? 'Verify'
                        : null,
                    onAction:
                        _prompt!.type == _SignInFailureType.verificationRequired
                        ? () {
                            final identifier = _identifier.text.trim();
                            _clearPrompt();
                            widget.onVerifyAccount?.call(identifier);
                          }
                        : null,
                    onDismiss: _clearPrompt,
                  ),
                )
              : const SizedBox(key: ValueKey('no-credentials-prompt')),
        ),
        AuthTextField(
          label: 'Email or phone number',
          controller: _identifier,
          hint: 'jane@example.com',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: _onCredentialsChanged,
        ),
        const SizedBox(height: AppSpacing.md),
        AuthTextField(
          label: 'Password',
          controller: _password,
          hint: 'Enter your password',
          togglableObscure: true,
          textInputAction: TextInputAction.done,
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
        PrimaryButton(
          label: 'Sign In',
          onPressed: _signingIn ? null : _submit,
          isLoading: _signingIn,
        ),
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

enum _SignInFailureType {
  missingCredentials,
  invalidCredentials,
  verificationRequired,
  requestFailed,
  unknown,
}

class _SignInPrompt {
  const _SignInPrompt({required this.type, required this.message});

  final _SignInFailureType type;
  final String message;
}
