import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';

/// NOTE: the product brief also mentions the splash being a short video
/// clip. If/when that asset exists, swap this screen's body for a
/// `VideoPlayer` (add the `video_player` package + the asset in
/// pubspec.yaml) and call [onFinished] from the controller's completion
/// listener instead of the Timer below — everything else here
/// (auto-advance contract, route wiring) stays the same.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onFinished});
  final VoidCallback onFinished;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _logoController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  late final Animation<double> _logoScale = CurvedAnimation(
    parent: _logoController,
    curve: Curves.elasticOut,
  );
  late final Animation<double> _textOpacity = CurvedAnimation(
    parent: _logoController,
    curve: const Interval(0.45, 1, curve: Curves.easeOut),
  );
  late final Animation<Offset> _textOffset = Tween<Offset>(
    begin: const Offset(0, 0.25),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _logoController, curve: const Interval(0.45, 1, curve: Curves.easeOut)));

  late final AnimationController _dotsController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void initState() {
    super.initState();
    _logoController.forward();
    Future.delayed(AppMotion.splashHold, widget.onFinished);
  }

  @override
  void dispose() {
    _logoController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _logoScale,
              child: Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: const Icon(Icons.favorite, color: AppColors.surface, size: 44),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FadeTransition(
              opacity: _textOpacity,
              child: SlideTransition(
                position: _textOffset,
                child: Column(
                  children: [
                    Text('HelpFundUs', style: AppTextStyles.brand),
                    const SizedBox(height: AppSpacing.xs),
                    Text('Crowdfunding that cares', style: AppTextStyles.tagline),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            AnimatedBuilder(
              animation: _dotsController,
              builder: (context, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    final t = (_dotsController.value - (i * 0.2)) % 1.0;
                    final pulse = (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);
                    final scale = 0.6 + pulse * 0.6;
                    final opacity = 0.35 + pulse * 0.65;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Opacity(
                        opacity: opacity,
                        child: Transform.scale(
                          scale: scale,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
