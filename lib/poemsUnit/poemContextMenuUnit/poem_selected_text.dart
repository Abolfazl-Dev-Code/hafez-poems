import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:hafez_poems/theme/color_style.dart';

class PoemSelectedText extends StatelessWidget {
  const PoemSelectedText({
    super.key,
    required this.text,
    required this.isSelected,
    required this.isHighlighted,
    required this.fontSize,
    required this.lineHeight,
    required this.fontFamily,
    required this.fontColor,
    required this.onTap,
    required this.isFlashing,
    this.onLongPress,
  });

  final String text;
  final bool isSelected;
  final bool isHighlighted;
  final double fontSize;
  final double lineHeight;
  final String fontFamily;
  final Color fontColor;
  final VoidCallback onTap;
  final bool isFlashing;
  final ValueChanged<LongPressStartDetails>? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color bg = Colors.transparent;
    Color border = Colors.transparent;
    Color textColor = colorScheme.onSurface;

    if (isFlashing) {
      bg = Colors.amber.withValues(alpha: 0.45);
      border = Colors.amber;
    } else if (isHighlighted) {
      bg = const Color(0xFFFFF3B0);
      border = AppColors.accent;
      textColor = Colors.black87;
    } else if (isSelected) {
      bg = colorScheme.primary.withValues(alpha: 0.08);
      border = colorScheme.primary.withValues(alpha: 0.45);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.mdRadius,
        border: Border.all(color: border),
      ),
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onLongPressStart: onLongPress,
          child: InkWell(
            borderRadius: AppRadius.mdRadius,
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: fontSize,
                  height: lineHeight,
                  fontFamily: fontFamily,
                  color: isHighlighted ? textColor : fontColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
