import 'package:flutter/material.dart';
import 'package:helpfundus/core/theme/app_colors.dart';
import 'package:helpfundus/core/theme/app_theme_colors.dart';
import 'package:helpfundus/core/theme/app_text_styles.dart';

class PerformanceRecentDonations extends StatelessWidget {
  const PerformanceRecentDonations({super.key});

  @override
  Widget build(BuildContext context) {
    const donors = [
      _Donor('MT', 'Marcus T. 🇳🇬', '2 min ago', '\$50', Color(0xFF8255F3)),
      _Donor('PS', 'Priya S. 🇮🇳', '18 min ago', '\$25', Color(0xFF397FF0)),
      _Donor('A', 'Anonymous 🌍', '1 hr ago', '\$100', Color(0xFF6D7587)),
      _Donor('AK', 'Aisha K. 🇬🇭', '3 hrs ago', '\$10', Color(0xFFE5484D)),
    ];
    return Container(
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          for (var index = 0; index < donors.length; index++) ...[
            _row(context, donors[index]),
            if (index < donors.length - 1)
              Divider(height: 1, color: context.appDivider),
          ],
        ],
      ),
    );
  }

  Widget _row(BuildContext context, _Donor donor) {
    return SizedBox(
      height: 58,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: donor.color,
              child: Text(
                donor.initials,
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    donor.name,
                    style: AppTextStyles.buttonMd.copyWith(
                      fontSize: 12,
                      color: context.appTextPrimary,
                    ),
                  ),
                  Text(
                    donor.time,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 10,
                      color: context.appTextMuted,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              donor.amount,
              style: AppTextStyles.buttonMd.copyWith(
                fontSize: 13,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Donor {
  const _Donor(this.initials, this.name, this.time, this.amount, this.color);
  final String initials;
  final String name;
  final String time;
  final String amount;
  final Color color;
}
