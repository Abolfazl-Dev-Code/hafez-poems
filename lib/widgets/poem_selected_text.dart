// ── کاشی مصراع — دست نخورده نسبت به نسخه اصلی ────────────────────────────

import 'package:flutter/material.dart';

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
    required this.isFlashing, // ← اضافه
    this.onLongPress, // ← اضافه
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
  final VoidCallback? onLongPress; // ← اضافه

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
      border = const Color(0xFFFFC107);
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
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          onLongPress: onLongPress, // ← اضافه
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
    );
  }
}
