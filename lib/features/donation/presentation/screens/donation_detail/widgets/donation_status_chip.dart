import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';
import 'package:helpfundus/features/donation/domain/entities/donation_record.dart';

class DonationStatusChip extends StatelessWidget {
  const DonationStatusChip({super.key, required this.status});

  final DonationStatus status;

  Color get _color => switch (status) {
    DonationStatus.completed => AppColors.primary,
    DonationStatus.pending => const Color(0xFFE17A00),
    DonationStatus.failed => AppColors.danger,
  };

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
    decoration: BoxDecoration(
      color: _color.withValues(alpha: .11),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 11, color: _color),
        const SizedBox(width: 7),
        Text(
          status.label,
          style: AppTextStyles.buttonMd.copyWith(fontSize: 14, color: _color),
        ),
      ],
    ),
  );
}
