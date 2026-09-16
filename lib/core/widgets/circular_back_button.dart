import 'package:flutter/material.dart';
import '../theme/app_theme_colors.dart';

class CircularBackButton extends StatelessWidget {
  const CircularBackButton({super.key, this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.appSurface,
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Icon(
            Icons.chevron_left,
            color: context.appTextPrimary,
            size: 22,
          ),
        ),
      ),
    );
  }
}
