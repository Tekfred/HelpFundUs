import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme_colors.dart';

enum PasswordStrength { empty, weak, fair, strong }

/// The compact Create Account feedback has one level per quality evaluated by
/// the existing password meter. It reads the password only; it never formats
/// or otherwise changes the text the user is entering.
enum PasswordFeedbackStrength { empty, weak, fair, good, strong }

class PasswordFeedbackResult {
  const PasswordFeedbackResult({
    required this.strength,
    required this.score,
    required this.nextSuggestion,
  });

  final PasswordFeedbackStrength strength;
  final int score;
  final String nextSuggestion;
}

/// Evaluates the same four password qualities that the existing strength
/// meter uses. This is intentionally separate from submit validation.
PasswordFeedbackResult evaluatePasswordFeedback(String password) {
  if (password.isEmpty) {
    return const PasswordFeedbackResult(
      strength: PasswordFeedbackStrength.empty,
      score: 0,
      nextSuggestion: '',
    );
  }

  final hasMinLength = password.length >= 8;
  final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
  final hasNumber = RegExp(r'[0-9]').hasMatch(password);
  final hasSymbol = RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password);
  final score = [
    hasMinLength,
    hasUppercase,
    hasNumber,
    hasSymbol,
  ].where((met) => met).length;

  final suggestion = !hasMinLength
      ? 'Add ${8 - password.length} more ${8 - password.length == 1 ? 'character' : 'characters'}'
      : !hasUppercase
      ? 'Add an uppercase letter'
      : !hasNumber
      ? 'Add a number'
      : !hasSymbol
      ? 'Add a symbol'
      : 'Password looks strong';

  final strength = switch (score) {
    0 || 1 => PasswordFeedbackStrength.weak,
    2 => PasswordFeedbackStrength.fair,
    3 => PasswordFeedbackStrength.good,
    _ => PasswordFeedbackStrength.strong,
  };

  return PasswordFeedbackResult(
    strength: strength,
    score: score,
    nextSuggestion: suggestion,
  );
}

PasswordStrength scorePassword(String value) {
  if (value.isEmpty) return PasswordStrength.empty;
  var score = 0;
  if (value.length >= 8) score++;
  if (RegExp(r'[A-Z]').hasMatch(value)) score++;
  if (RegExp(r'[0-9]').hasMatch(value)) score++;
  if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) score++;
  if (score <= 1) return PasswordStrength.weak;
  if (score <= 2) return PasswordStrength.fair;
  return PasswordStrength.strong;
}

/// A compact, real-time password-strength indicator for password creation.
/// It deliberately consumes a String value so it cannot alter controller text
/// or the current cursor/selection state.
class PasswordCreationFeedback extends StatelessWidget {
  const PasswordCreationFeedback({super.key, required this.password});

  final String password;

  Color _colorFor(PasswordFeedbackStrength strength) => switch (strength) {
    PasswordFeedbackStrength.empty => AppColors.border,
    PasswordFeedbackStrength.weak => AppColors.danger,
    PasswordFeedbackStrength.fair => AppColors.warning,
    PasswordFeedbackStrength.good => AppColors.gold,
    PasswordFeedbackStrength.strong => AppColors.primary,
  };

  String _labelFor(PasswordFeedbackStrength strength) => switch (strength) {
    PasswordFeedbackStrength.empty => '',
    PasswordFeedbackStrength.weak => 'Weak',
    PasswordFeedbackStrength.fair => 'Fair',
    PasswordFeedbackStrength.good => 'Good',
    PasswordFeedbackStrength.strong => 'Strong',
  };

  @override
  Widget build(BuildContext context) {
    final result = evaluatePasswordFeedback(password);
    final color = _colorFor(result.strength);
    final label = _labelFor(result.strength);
    final activeSegments = switch (result.strength) {
      PasswordFeedbackStrength.empty => 0,
      PasswordFeedbackStrength.weak => 1,
      PasswordFeedbackStrength.fair => 2,
      PasswordFeedbackStrength.good => 3,
      PasswordFeedbackStrength.strong => 4,
    };

    return Semantics(
      label: result.strength == PasswordFeedbackStrength.empty
          ? 'Password strength not yet evaluated'
          : 'Password strength: $label. ${result.nextSuggestion}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(4, (index) {
              final active = index < activeSegments;
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  margin: EdgeInsets.only(right: index < 3 ? 6 : 0),
                  height: 4,
                  decoration: BoxDecoration(
                    color: active ? color : context.appBorder,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.xs),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: result.strength == PasswordFeedbackStrength.empty
                ? const SizedBox(key: ValueKey('empty-password-feedback'))
                : Row(
                    key: ValueKey(result.strength),
                    children: [
                      Flexible(
                        child: Text(
                          label,
                          style: AppTextStyles.bodySm.copyWith(
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          result.nextSuggestion,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: AppTextStyles.bodySm.copyWith(
                            color: context.appTextSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

/// Three-segment animated bar + label + a small checklist of requirements —
/// used on Create Account and Reset Password.
class PasswordStrengthMeter extends StatelessWidget {
  const PasswordStrengthMeter({
    super.key,
    required this.password,
    this.showChecklist = true,
  });
  final String password;
  final bool showChecklist;

  static const _requirements = [
    ('At least 8 characters', _hasMinLength),
    ('One uppercase letter', _hasUppercase),
    ('One number', _hasNumber),
  ];

  static bool _hasMinLength(String v) => v.length >= 8;
  static bool _hasUppercase(String v) => RegExp(r'[A-Z]').hasMatch(v);
  static bool _hasNumber(String v) => RegExp(r'[0-9]').hasMatch(v);

  Color _colorFor(PasswordStrength s) => switch (s) {
    PasswordStrength.empty => AppColors.border,
    PasswordStrength.weak => AppColors.danger,
    PasswordStrength.fair => AppColors.warning,
    PasswordStrength.strong => AppColors.primary,
  };

  String _labelFor(PasswordStrength s) => switch (s) {
    PasswordStrength.empty => '',
    PasswordStrength.weak => 'Weak password',
    PasswordStrength.fair => 'Fair password',
    PasswordStrength.strong => 'Strong password',
  };

  @override
  Widget build(BuildContext context) {
    final strength = scorePassword(password);
    final activeSegments = switch (strength) {
      PasswordStrength.empty => 0,
      PasswordStrength.weak => 1,
      PasswordStrength.fair => 2,
      PasswordStrength.strong => 3,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(3, (i) {
            final active = i < activeSegments;
            return Expanded(
              child: AnimatedContainer(
                duration: AppMotion.fast,
                margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                height: 5,
                decoration: BoxDecoration(
                  color: active ? _colorFor(strength) : context.appBorder,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            );
          }),
        ),
        if (strength != PasswordStrength.empty) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            _labelFor(strength),
            style: AppTextStyles.bodySm.copyWith(color: _colorFor(strength)),
          ),
        ],
        if (showChecklist) ...[
          const SizedBox(height: AppSpacing.sm),
          ..._requirements.map((r) {
            final met = r.$2(password);
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(
                    met ? Icons.check_circle : Icons.circle_outlined,
                    size: 14,
                    color: met ? AppColors.primary : context.appTextMuted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    r.$1,
                    style: AppTextStyles.bodySm.copyWith(
                      color: met
                          ? context.appTextSecondary
                          : context.appTextMuted,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }
}
