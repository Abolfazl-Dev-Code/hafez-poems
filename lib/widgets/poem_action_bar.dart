import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/color_style.dart';
import '../services/app_snackbar_service.dart';

class PoemActionBar extends StatelessWidget {
  final bool isLiked;
  final bool isSaved;
  final bool isHighlightActive;
  final bool canHighlight;

  final VoidCallback onLikeTap;
  final VoidCallback onSaveTap;
  final VoidCallback onHighlightTap;

  final BuildContext scaffoldContext;

  const PoemActionBar({
    super.key,
    required this.isLiked,
    required this.isSaved,
    required this.isHighlightActive,
    required this.canHighlight,
    required this.onLikeTap,
    required this.onSaveTap,
    required this.onHighlightTap,
    required this.scaffoldContext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.primary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ActionButton(
            icon: isLiked ? Icons.favorite : Icons.favorite_border,
            label: 'علاقه‌مندی‌',
            isActive: isLiked,
            activeColor: Colors.red.shade400,
            onTap: onLikeTap,
          ),

          ActionButton(
            icon: isSaved ? Icons.bookmark : Icons.bookmark_border,
            label: 'ذخیره',
            isActive: isSaved,
            activeColor: Colors.greenAccent,
            onTap: onSaveTap,
          ),

          ActionButton(
            icon: isHighlightActive ? Icons.highlight : Icons.highlight,
            label: 'برگزیده‌',
            isDimmed: !canHighlight,
            isActive: isHighlightActive,
            activeColor: Colors.yellowAccent,
            onTap: () {
              if (!canHighlight) {
                AppSnackBarService.warning(
                  scaffoldContext,
                  'لطفاً ابتدا یک مصرع را انتخاب کنید',
                );
                return;
              }

              onHighlightTap();
            },
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;
  final bool isDimmed;

  const ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
    this.isDimmed = false,
  });

  @override
  Widget build(BuildContext context) {
    Theme.of(context);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isDimmed ? 0.8 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              color: isActive
                  ? activeColor.withValues(alpha: 0.14)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isActive ? activeColor : Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: isActive ? activeColor : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
