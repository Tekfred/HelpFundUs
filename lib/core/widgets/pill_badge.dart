import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

/// Rounded pill with optional leading emoji/icon glyph — used for
/// "⚡ Fast setup", "100+ categories", "✓ Verified", etc.
class PillBadge extends StatelessWidget {
  const PillBadge({
    super.key,
    required this.label,
    this.leading,
    this.background = AppColors.surface,
    this.foreground = AppColors.textPrimary,
    this.dense = false,
  });

  final String label;
  final Widget? leading;
  final Color background;
  final Color foreground;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 10 : 14,
        vertical: dense ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 6)],
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// A pill badge that floats in with a spring pop + gentle up/down bob —
/// used for the "+$500 🎉" / "💚 Just donated!" / "🌍 12K+ donors" chips.
class FloatingNotificationChip extends StatefulWidget {
  const FloatingNotificationChip({
    super.key,
    required this.label,
    this.delay = Duration.zero,
    this.background = AppColors.surface,
  });

  final String label;
  final Duration delay;
  final Color background;

  @override
  State<FloatingNotificationChip> createState() =>
      _FloatingNotificationChipState();
}

class _FloatingNotificationChipState extends State<FloatingNotificationChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );
  late final Animation<double> _entrance = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, 0.35, curve: Curves.elasticOut),
  );
  late final Animation<double> _bob = Tween<double>(begin: -3, end: 3).animate(
    CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 1, curve: Curves.easeInOut),
    ),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) _controller.repeat();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final entranceScale = _entrance.value.clamp(0.0, 1.0);
        return Transform.translate(
          offset: Offset(0, _bob.value * entranceScale),
          child: Transform.scale(scale: entranceScale, child: child),
        );
      },
      child: PillBadge(label: widget.label, background: widget.background),
    );
  }
}
