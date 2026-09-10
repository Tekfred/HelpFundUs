import 'package:flutter/material.dart';

class CustomAmountInput extends StatelessWidget {
  const CustomAmountInput({
    super.key,
    required this.controller,
    required this.hasValidationError,
    required this.onChanged,
  });

  final TextEditingController controller;
  final bool hasValidationError;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    onChanged: onChanged,
    style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
    decoration: InputDecoration(
      prefixText: '\$  ',
      prefixStyle: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
      suffixText: 'USD',
      suffixStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      hintText: '0.00',
      hintStyle: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
      errorText: hasValidationError
          ? 'Enter an amount from \$5 to \$10,000'
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(17)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(color: Color(0xFFD2D6DF), width: 2),
      ),
    ),
  );
}
