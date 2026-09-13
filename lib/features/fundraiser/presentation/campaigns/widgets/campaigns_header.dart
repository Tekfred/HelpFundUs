import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';

class CampaignsHeader extends StatelessWidget {
  const CampaignsHeader({super.key, required this.onCreate});
  final VoidCallback onCreate;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text('My Campaigns', style: AppTextStyles.h1.copyWith(fontSize: 27)),
      const Spacer(),
      SizedBox(
        height: 52,
        child: FilledButton.icon(
          onPressed: onCreate,
          icon: const Icon(Icons.add),
          label: const Text('Create'),
        ),
      ),
    ],
  );
}
