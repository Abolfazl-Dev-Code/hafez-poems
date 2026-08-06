import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:hafez_poems/theme/app_radius.dart';

class AudioTabsBar extends StatelessWidget {
  final TabController tabController;
  final ColorScheme cs;

  const AudioTabsBar({super.key, required this.tabController, required this.cs});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: tabController.animation!,
      builder: (context, child) {
        final animationValue = tabController.animation!.value;

        return Container(
          height: 45,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Stack(
            children: [
              Align(
                alignment: Alignment(1 - (animationValue * 2), 0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 2 - 24,
                  height: 38,
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.12),
                    borderRadius: AppRadius.mdRadius,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => tabController.animateTo(0),
                      child: Center(
                        child: Text(
                          'خوانندگان',
                          style: TextStyle(
                            color: animationValue < 0.5
                                ? cs.primary
                                : cs.onSurface.withValues(alpha: 0.5),
                            fontWeight: animationValue < 0.5
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => tabController.animateTo(1),
                      child: Center(
                        child: Text(
                          'دانلودها',
                          style: TextStyle(
                            color: animationValue > 0.5
                                ? cs.primary
                                : cs.onSurface.withValues(alpha: 0.5),
                            fontWeight: animationValue > 0.5
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
