import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/text_style.dart';

class CarouselCategoryLabel extends StatelessWidget {
  final String categoryLabel;
  final String ghazalNumber;

  const CarouselCategoryLabel({
    super.key,
    required this.categoryLabel,
    required this.ghazalNumber,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 320),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        final slide = Tween<Offset>(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(animation);
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: slide, child: child),
        );
      },
      child: Column(
        key: ValueKey('$categoryLabel$ghazalNumber'),
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'دیوان حافظ',
            textAlign: TextAlign.right,
            style: AppTextStyles.bodyMedium.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '$categoryLabel $ghazalNumber',
            textAlign: TextAlign.right,
            style: AppTextStyles.bodyMedium.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.55),
              fontWeight: FontWeight.w400,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}
