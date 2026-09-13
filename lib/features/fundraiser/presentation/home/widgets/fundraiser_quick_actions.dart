import 'package:flutter/material.dart';

class FundraiserQuickActions extends StatelessWidget {
  const FundraiserQuickActions({
    super.key,
    required this.onNewCampaign,
    required this.onAllCampaigns,
  });

  final VoidCallback onNewCampaign;
  final VoidCallback onAllCampaigns;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 54,
            child: FilledButton.icon(
              onPressed: onNewCampaign,
              icon: const Icon(Icons.add, size: 22),
              label: const Text(
                'New Campaign',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 54,
            child: OutlinedButton.icon(
              onPressed: onAllCampaigns,
              icon: const Icon(Icons.grid_view_outlined, size: 21),
              label: const Text(
                'All Campaigns',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
