import 'dart:async';

import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_dimens.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/features/donation/state/donation_controller.dart';

class PaymentProcessingScreen extends StatefulWidget {
  const PaymentProcessingScreen({super.key, required this.controller});

  final DonationController controller;

  @override
  State<PaymentProcessingScreen> createState() =>
      _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState extends State<PaymentProcessingScreen>
    with SingleTickerProviderStateMixin {
  static const _reference = 'HF-A3F8B2';

  late final AnimationController _spinnerController;
  Timer? _elapsedTimer;
  int _elapsedSeconds = 0;

  String get _displayMethod => switch (widget.controller.paymentMethod) {
    'Card' => 'Credit / Debit Card',
    final method => method,
  };

  @override
  void initState() {
    super.initState();
    _spinnerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsedSeconds++);
    });
  }

  @override
  void dispose() {
    _elapsedTimer?.cancel();
    _spinnerController.dispose();
    super.dispose();
  }

  void _checkStatus() {
    _spinnerController.forward(from: 0).then((_) {
      if (mounted) _spinnerController.repeat();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final background = isDark ? colorScheme.surface : AppColors.background;
    final surface = colorScheme.surface;
    final primaryText = colorScheme.onSurface;
    final secondaryText = colorScheme.onSurfaceVariant;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxHeight < 700;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    SizedBox(height: isCompact ? 88 : 124),
                    _ProcessingIndicator(controller: _spinnerController),
                    SizedBox(height: isCompact ? 28 : 34),
                    Text(
                      'Processing payment...',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.h3.copyWith(
                        color: primaryText,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 360),
                      child: Text(
                        'Your payment is being verified with $_displayMethod. '
                        'This usually takes a few seconds but may occasionally '
                        'take up to 2 minutes.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMd.copyWith(
                          color: secondaryText,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: isCompact ? 26 : 34),
                    _TransactionReferenceCard(
                      reference: _reference,
                      amount: widget.controller.amount,
                      method: _displayMethod,
                      surface: surface,
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Elapsed: ${_elapsedSeconds}s',
                      style: AppTextStyles.label.copyWith(color: secondaryText),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    OutlinedButton.icon(
                      onPressed: _checkStatus,
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text('Check status'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: secondaryText,
                        minimumSize: const Size(0, 48),
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        side: BorderSide(
                          color: secondaryText.withValues(alpha: 0.35),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        textStyle: AppTextStyles.buttonMd,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    TextButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_rounded, size: 17),
                      label: const Text('Back to secure payment'),
                      style: TextButton.styleFrom(
                        foregroundColor: secondaryText,
                        textStyle: AppTextStyles.buttonMd.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(height: isCompact ? 32 : 52),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProcessingIndicator extends StatelessWidget {
  const _ProcessingIndicator({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 80,
    height: 80,
    child: Stack(
      fit: StackFit.expand,
      children: [
        CircularProgressIndicator(
          value: 1,
          strokeWidth: 5,
          color: AppColors.primary.withValues(alpha: 0.08),
        ),
        RotationTransition(
          turns: controller,
          child: const CircularProgressIndicator(
            value: 0.23,
            strokeWidth: 5,
            strokeCap: StrokeCap.round,
            color: AppColors.primary,
          ),
        ),
      ],
    ),
  );
}

class _TransactionReferenceCard extends StatelessWidget {
  const _TransactionReferenceCard({
    required this.reference,
    required this.amount,
    required this.method,
    required this.surface,
    required this.primaryText,
    required this.secondaryText,
  });

  final String reference;
  final double amount;
  final String method;
  final Color surface;
  final Color primaryText;
  final Color secondaryText;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    constraints: const BoxConstraints(maxWidth: 392),
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: 18,
    ),
    decoration: BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.06),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      children: [
        Text(
          'Transaction reference',
          style: AppTextStyles.label.copyWith(color: secondaryText),
        ),
        const SizedBox(height: 4),
        Text(
          reference,
          style: AppTextStyles.buttonMd.copyWith(color: primaryText),
        ),
        const SizedBox(height: 10),
        Text(
          '\$${amount.toStringAsFixed(2)} USD via $method',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMd.copyWith(color: secondaryText),
        ),
      ],
    ),
  );
}
