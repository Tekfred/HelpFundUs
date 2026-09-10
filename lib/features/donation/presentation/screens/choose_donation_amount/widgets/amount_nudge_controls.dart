import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';

class AmountNudgeControls extends StatelessWidget {
  const AmountNudgeControls({super.key, required this.onAdd});

  final ValueChanged<int> onAdd;

  @override
  Widget build(BuildContext context) => Row(
    children: [1, 5, 10]
        .map(
          (amount) => Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: amount == 10 ? 0 : 10),
              child: OutlinedButton(
                onPressed: () => onAdd(amount),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  side: const BorderSide(color: Color(0xFFD2D6DF)),
                ),
                child: Text(
                  ' +\$$amount',
                  style: AppTextStyles.buttonMd.copyWith(fontSize: 17),
                ),
              ),
            ),
          ),
        )
        .toList(),
  );
}
