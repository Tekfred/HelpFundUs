import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';

class SuggestedAmounts extends StatelessWidget {
  const SuggestedAmounts({
    super.key,
    required this.selectedAmount,
    required this.onSelected,
    this.expanded = false,
  });

  final double selectedAmount;
  final ValueChanged<int> onSelected;
  final bool expanded;

  @override
  Widget build(BuildContext context) => GridView.count(
    crossAxisCount: 3,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    mainAxisSpacing: expanded ? 10 : 9,
    crossAxisSpacing: expanded ? 10 : 9,
    childAspectRatio: expanded ? 2.58 : 3.05,
    children: [5, 10, 25, 50, 100, 250].map((amount) {
      final selected = selectedAmount == amount;
      return Material(
        color: selected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(expanded ? 17 : 15),
        child: InkWell(
          onTap: () => onSelected(amount),
          borderRadius: BorderRadius.circular(expanded ? 17 : 15),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.borderStrong,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(expanded ? 17 : 15),
            ),
            child: Text(
              '\$$amount',
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textPrimary,
                fontSize: expanded ? 20 : 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      );
    }).toList(),
  );
}
