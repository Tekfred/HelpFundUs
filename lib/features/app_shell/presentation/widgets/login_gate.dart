import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';

enum LoginGatePurpose { donate, campaign }

/// The guest auth boundary. Payment and campaign creation always start from
/// an authenticated session, while the rest of the public browser stays open.
Future<void> showLoginGate(
  BuildContext context, {
  required LoginGatePurpose purpose,
  required VoidCallback onSignIn,
  required VoidCallback onCreateAccount,
}) {
  final action = purpose == LoginGatePurpose.donate
      ? 'donate to this campaign'
      : 'start a fundraiser';

  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderStrong,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFFE6F7EC),
                shape: BoxShape.circle,
              ),
              child: Icon(
                purpose == LoginGatePurpose.donate
                    ? Icons.favorite_outline_rounded
                    : Icons.add_circle_outline_rounded,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Sign in to continue',
              style: AppTextStyles.h3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Create an account or sign in to $action. You can keep browsing as a guest.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMd,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Sign In',
              onPressed: () {
                Navigator.of(sheetContext).pop();
                onSignIn();
              },
            ),
            const SizedBox(height: 12),
            SecondaryButton(
              label: 'Create Free Account',
              onPressed: () {
                Navigator.of(sheetContext).pop();
                onCreateAccount();
              },
            ),
            const SizedBox(height: 8),
            TextLinkButton(
              label: 'Continue browsing as guest',
              onPressed: () => Navigator.of(sheetContext).pop(),
            ),
          ],
        ),
      ),
    ),
  );
}
