import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';

class CampaignSearchField extends StatelessWidget {
  const CampaignSearchField({super.key, required this.onChanged});
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) => TextField(
    onChanged: onChanged,
    decoration: InputDecoration(
      prefixIcon: Icon(Icons.search, color: context.appTextMuted, size: 22),
      hintText: 'Search your campaigns...',
      hintStyle: TextStyle(color: context.appTextMuted, fontSize: 16),
      isDense: true,
      filled: true,
      fillColor: context.appInput,
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      constraints: const BoxConstraints.tightFor(height: 50),
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
