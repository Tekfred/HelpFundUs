import 'package:flutter/material.dart';

class DonorRequirementNotice extends StatelessWidget {
  const DonorRequirementNotice({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFE2F7EA),
      borderRadius: BorderRadius.circular(14),
    ),
    child: const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.lock_outline_rounded, color: Color(0xFF1DB954), size: 21),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            'Donations require a verified HelpFundUs account.\nYou are signed in as Jane Doe.',
          ),
        ),
      ],
    ),
  );
}
