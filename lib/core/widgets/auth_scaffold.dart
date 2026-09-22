import 'package:flutter/material.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme_colors.dart';
import 'circular_back_button.dart';

/// Common chrome for every auth screen: back chevron on the left, an
/// optional centered title, scrollable body, and consistent side padding.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    this.title,
    this.onBack,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.bodyMainAxisAlignment = MainAxisAlignment.start,
  });

  final String? title;
  final VoidCallback? onBack;
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment bodyMainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: 44,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (onBack != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CircularBackButton(onPressed: onBack),
                      ),
                    if (title != null)
                      Text(
                        title!,
                        style: AppTextStyles.h3.copyWith(
                          color: context.appTextPrimary,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Column(
                          mainAxisAlignment: bodyMainAxisAlignment,
                          crossAxisAlignment: crossAxisAlignment,
                          children: children,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
