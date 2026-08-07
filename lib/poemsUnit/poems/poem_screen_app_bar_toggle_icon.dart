import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_radius.dart';

class AppBarToggleIcon extends StatelessWidget {
  final bool isActive;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const AppBarToggleIcon({
    super.key,
    required this.isActive,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.smRadius,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isActive
                ? activeColor.withValues(alpha: 0.14)
                : Colors.transparent,
            borderRadius: AppRadius.smRadius,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Icon(
              isActive ? activeIcon : inactiveIcon,
              key: ValueKey(isActive),
              size: 22,
              color: isActive ? activeColor : inactiveColor,
            ),
          ),
        ),
      ),
    );
  }
}
