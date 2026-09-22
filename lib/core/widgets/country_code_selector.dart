import 'package:flutter/material.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme_colors.dart';

class Country {
  const Country(this.flag, this.dialCode, this.name);
  final String flag;
  final String dialCode;
  final String name;
}

const kCountries = [
  Country('🇬🇭', '+233', 'Ghana'),
  Country('🇺🇸', '+1', 'United States'),
  Country('🇬🇧', '+44', 'United Kingdom'),
  Country('🇳🇬', '+234', 'Nigeria'),
  Country('🇰🇪', '+254', 'Kenya'),
  Country('🇿🇦', '+27', 'South Africa'),
];

/// Compact "🇬🇭 +233 ▾" control that opens a bottom sheet list — sits to
/// the left of the phone number field.
class CountryCodeSelector extends StatelessWidget {
  const CountryCodeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });
  final Country selected;
  final ValueChanged<Country> onChanged;

  Future<void> _openPicker(BuildContext context) async {
    final choice = await showModalBottomSheet<Country>(
      context: context,
      backgroundColor: context.appSurfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.appBorder,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              for (final c in kCountries)
                ListTile(
                  leading: Text(c.flag, style: const TextStyle(fontSize: 22)),
                  title: Text(
                    c.name,
                    style: AppTextStyles.bodyLg.copyWith(
                      color: context.appTextPrimary,
                    ),
                  ),
                  trailing: Text(
                    c.dialCode,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: context.appTextSecondary,
                    ),
                  ),
                  onTap: () => Navigator.of(context).pop(c),
                ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        );
      },
    );
    if (choice != null) onChanged(choice);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openPicker(context),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          color: context.appInput,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: context.appBorderStrong),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(selected.flag, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Text(
              selected.dialCode,
              style: AppTextStyles.buttonMd.copyWith(
                color: context.appTextPrimary,
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: context.appTextMuted,
            ),
          ],
        ),
      ),
    );
  }
}
