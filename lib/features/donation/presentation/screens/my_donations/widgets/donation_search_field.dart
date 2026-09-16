import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';

class DonationSearchField extends StatelessWidget {
  const DonationSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    onChanged: onChanged,
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.search, color: Color(0xFF9AA4B5), size: 22),
      hintText: 'Search donations...',
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 15),
      filled: true,
      fillColor: context.appInput,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: context.appBorderStrong),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: context.appBorderStrong),
      ),
    ),
  );
}
