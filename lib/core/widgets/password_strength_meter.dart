import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

enum PasswordStrength { empty, weak, fair, strong }

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

/// Three-segment animated bar + label + a small checklist of requirements —
/// used on Create Account and Reset Password.
class PasswordStrengthMeter extends StatelessWidget {
  const PasswordStrengthMeter({super.key, required this.password, this.showChecklist = true});
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
                  color: active ? _colorFor(strength) : AppColors.border,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            );
          }),
        ),
        if (strength != PasswordStrength.empty) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(_labelFor(strength), style: AppTextStyles.bodySm.copyWith(color: _colorFor(strength))),
        ],
        if (showChecklist) ...[
          const SizedBox(height: AppSpacing.sm),
          ..._requirements.map((r) {
            final met = r.$2(password);
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(met ? Icons.check_circle : Icons.circle_outlined,
                      size: 14, color: met ? AppColors.primary : AppColors.textMuted),
                  const SizedBox(width: 6),
                  Text(r.$1, style: AppTextStyles.bodySm.copyWith(color: met ? AppColors.textSecondary : AppColors.textMuted)),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }
}
