import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';

class RegistrationSuccessScreen extends StatefulWidget {
  const RegistrationSuccessScreen({
    super.key,
    required this.onContinue,
    required this.onCompleteProfile,
    required this.onEnableSecurity,
  });

  final VoidCallback onContinue;
  final VoidCallback onCompleteProfile;
  final VoidCallback onEnableSecurity;

  @override
  State<RegistrationSuccessScreen> createState() => _RegistrationSuccessScreenState();
}

class _RegistrationSuccessScreenState extends State<RegistrationSuccessScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const Spacer(),
              SizedBox(
                width: 160,
                height: 160,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        ..._sparklePositions.map((pos) {
                          final t = ((_controller.value - 0.2) / 0.6).clamp(0.0, 1.0);
                          return Transform.translate(
                            offset: pos * (t * 46),
                            child: Opacity(
                              opacity: (1 - t).clamp(0.0, 1.0),
                              child: const Icon(Icons.auto_awesome, size: 16, color: AppColors.gold),
                            ),
                          );
                        }),
                        Transform.scale(
                          scale: Curves.elasticOut.transform(_controller.value.clamp(0.0, 1.0)),
                          child: Container(
                            width: 110,
                            height: 110,
                            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                            child: const Icon(Icons.check_rounded, color: AppColors.surface, size: 56),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text("You're all set!", style: AppTextStyles.h1, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Your account has been verified. Welcome to a community that funds what matters.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMd,
              ),
              const SizedBox(height: AppSpacing.xl),
              _PromptCard(
                icon: Icons.person_outline,
                title: 'Complete your profile',
                subtitle: 'Add a photo and a short bio so donors know who you are.',
                onTap: widget.onCompleteProfile,
              ),
              const SizedBox(height: AppSpacing.sm),
              _PromptCard(
                icon: Icons.shield_outlined,
                title: 'Enable stronger security',
                subtitle: 'Turn on two-factor authentication to protect your account.',
                onTap: widget.onEnableSecurity,
              ),
              const Spacer(),
              PrimaryButton(label: 'Continue', onPressed: widget.onContinue),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  static final _sparklePositions = List.generate(6, (i) {
    final angle = (i / 6) * 2 * pi;
    return Offset(cos(angle), sin(angle));
  });
}

class _PromptCard extends StatelessWidget {
  const _PromptCard({required this.icon, required this.title, required this.subtitle, required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.borderStrong),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.12), shape: BoxShape.circle),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.buttonMd),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.bodySm),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
