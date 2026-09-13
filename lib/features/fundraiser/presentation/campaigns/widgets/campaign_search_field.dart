import 'package:flutter/material.dart';

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
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFCBD1DB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFCBD1DB)),
      ),
    ),
  );
}
