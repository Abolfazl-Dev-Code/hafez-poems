import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/profileUnit/profile_screen.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/searchUnit/search_screen.dart';
import 'package:hafez_poems/theme/animated_app_icons.dart';
import 'package:hafez_poems/theme/app_icons.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, this.title = "اشعار حافظ"});
  static const Duration _navTapDelay = Duration(milliseconds: 150);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: AppRadius.xlRadius,
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.35)),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(
                alpha: theme.brightness == Brightness.dark ? 0.22 : 0.08,
              ),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 11),
                child: AnimatedAppIcon(
                  asset: AppIcons.search,
                  size: 27,
                  color: colorScheme.onSurface,
                  strokeWidth: 15,
                  tapDelay: _navTapDelay,
                  onTap: () {
                    Get.to(
                      () => SearchScreen(),
                      transition: Transition.downToUp,
                    );
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsetsGeometry.only(left: 9),
                child: AnimatedAppIcon(
                  asset: AppIcons.person,
                  size: 28,
                  color: colorScheme.onSurface,
                  strokeWidth: 15,
                  tapDelay: _navTapDelay,
                  onTap: () {
                    Get.to(
                      () => ProfileScreen(),
                      transition: Transition.downToUp,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}
