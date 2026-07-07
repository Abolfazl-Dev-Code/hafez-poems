import 'package:flutter/material.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/app_snackbar_service.dart';
import 'package:hafez_poems/poemsUnit/poemsActionBarUnit/poem_action_bar_button.dart';
import 'package:hafez_poems/theme/color_style.dart';

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
