import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_spacing.dart';

class FalDialogScrollHint extends StatelessWidget {
  final bool visible;

  const FalDialogScrollHint({super.key, required this.visible});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: IgnorePointer(
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.0),
                  Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.95),
                ],
              ),
            ),
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
