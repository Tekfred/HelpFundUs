import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

/// Consistent inline error feedback for forms and authentication flows.
class AppErrorPrompt extends StatefulWidget {
  const AppErrorPrompt({
    super.key,
    required this.message,
    this.title,
    this.onDismiss,
    this.actionLabel,
    this.onAction,
    this.autoDismissAfter = const Duration(seconds: 8),
  });

  final String message;
  final String? title;
  final VoidCallback? onDismiss;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Duration autoDismissAfter;

  @override
  State<AppErrorPrompt> createState() => _AppErrorPromptState();
}

/// Shows the shared error prompt above the current screen instead of placing
/// it in a page layout. This is appropriate for temporary unavailable actions.
void showAppErrorOverlay(BuildContext context, {required String message}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      duration: const Duration(seconds: 8),
      content: AppErrorPrompt(
        message: message,
        onDismiss: messenger.hideCurrentSnackBar,
      ),
    ),
  );
}

class _AppErrorPromptState extends State<AppErrorPrompt> {
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _scheduleDismiss();
  }

  @override
  void didUpdateWidget(covariant AppErrorPrompt oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.message != widget.message) _scheduleDismiss();
  }

  void _scheduleDismiss() {
    _dismissTimer?.cancel();
    if (widget.onDismiss != null) {
      _dismissTimer = Timer(widget.autoDismissAfter, widget.onDismiss!);
    }
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: .05),
        border: Border.all(color: AppColors.danger.withValues(alpha: .35)),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.danger,
            size: 21,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.title != null) ...[
                  Text(
                    widget.title!,
                    style: AppTextStyles.buttonMd.copyWith(
                      color: AppColors.danger,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  widget.message,
                  style: AppTextStyles.bodyMd.copyWith(color: AppColors.danger),
                ),
              ],
            ),
          ),
          if (widget.actionLabel != null && widget.onAction != null) ...[
            const SizedBox(width: AppSpacing.xs),
            TextButton(
              onPressed: widget.onAction,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              ),
              child: Text(
                widget.actionLabel!,
                style: AppTextStyles.buttonMd.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
          if (widget.onDismiss != null) ...[
            const SizedBox(width: AppSpacing.xs),
            IconButton(
              onPressed: widget.onDismiss,
              icon: const Icon(Icons.close_rounded, size: 18),
              color: AppColors.danger,
              tooltip: 'Dismiss error',
              visualDensity: VisualDensity.compact,
            ),
          ],
        ],
      ),
    );
  }
}
