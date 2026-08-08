import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_radius.dart';

class FalLoadingOverlay extends StatelessWidget {
  const FalLoadingOverlay({super.key, required this.isVisible});

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: !isVisible,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          opacity: isVisible ? 1 : 0,
          child: ClipRRect(
            borderRadius: AppRadius.xxlRadius,
            child: Container(
              color: theme.scaffoldBackgroundColor.withValues(alpha: 0.8),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'حافظ در حال انتخاب غزل است...',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
