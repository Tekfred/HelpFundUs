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
    this.onDismiss,
    this.autoDismissAfter = const Duration(seconds: 8),
  });

  final String message;
  final VoidCallback? onDismiss;
  final Duration autoDismissAfter;

  @override
  State<AppErrorPrompt> createState() => _AppErrorPromptState();
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
            child: Text(
              widget.message,
              style: AppTextStyles.bodyMd.copyWith(color: AppColors.danger),
            ),
          ),
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
