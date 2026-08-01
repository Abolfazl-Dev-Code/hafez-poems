import 'package:hafez_poems/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_radius.dart';

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
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isDimmed ? 0.8 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadius.smRadius,
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              color: isActive
                  ? activeColor.withValues(alpha: 0.14)
                  : Colors.transparent,
              borderRadius: AppRadius.smRadius,
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
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ).copyWith(color: isActive ? activeColor : Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
