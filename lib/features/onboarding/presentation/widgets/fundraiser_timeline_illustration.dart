import 'package:flutter/material.dart';
import '../../../../core/animation/reveal_on_enter.dart';
import 'timeline_step.dart';

class FundraiserTimelineIllustration extends StatelessWidget {
  const FundraiserTimelineIllustration({super.key});

  static const _steps = [
    ('Create your story', 'Write your campaign and set a fundraising goal'),
    ('Verify your identity', 'Quick ID check to build trust with donors'),
    ('24 h review process', 'Our team reviews your campaign for approval'),
    (
      'Launch and receive funds',
      'Go live and receive donations directly to you',
    ),
  ];

  static final revealCount = _steps.length;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        width: constraints.maxWidth.clamp(280.0, 344.0).toDouble(),
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .06),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: List.generate(_steps.length, (index) {
            final (title, description) = _steps[index];
            return RevealOnEnter(
              index: index + 1,
              child: TimelineStep(
                number: index + 1,
                title: title,
                description: description,
                isLast: index == _steps.length - 1,
              ),
            );
          }),
        ),
      ),
    );
  }
}
