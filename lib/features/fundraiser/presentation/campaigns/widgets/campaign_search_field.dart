import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';

class CampaignSearchField extends StatelessWidget {
  const CampaignSearchField({super.key, required this.onChanged});
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) => TextField(
    onChanged: onChanged,
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.search, color: Color(0xFF9AA4B5)),
      hintText: 'Search your campaigns...',
      filled: true,
      fillColor: context.appInput,
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
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
