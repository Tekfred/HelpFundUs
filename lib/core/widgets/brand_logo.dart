import 'package:flutter/material.dart';

/// Shared application mark used during onboarding and loading states.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 88});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/adaptive-foreground.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      semanticLabel: 'HelpFundUs',
    );
  }
}
