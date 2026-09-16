import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';

/// Shared page chrome for the later donation steps.
class DonationPage extends StatelessWidget {
  const DonationPage({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.appBackground,
    appBar: AppBar(backgroundColor: context.appBackground, title: Text(title)),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.appSurface,
              borderRadius: BorderRadius.circular(22),
            ),
            child: child,
          ),
        ],
      ),
    ),
  );
}

class DonationSummaryRow extends StatelessWidget {
  const DonationSummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        Text(label),
        const Spacer(),
        Text(
          value,
          style: emphasized
              ? const TextStyle(fontWeight: FontWeight.w700)
              : null,
        ),
      ],
    ),
  );
}
