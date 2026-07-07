import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:funky_icons/funky_icons.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/profileUnit/profile_screen.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/searchUnit/search_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, this.title = "اشعار حافظ"});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
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
        child: Row(
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: IconButton(
                splashRadius: 24,
                icon: _ThemedFunkyIcon(
                  icon: FunkyIcons.search03,
                  color: colorScheme.onSurface,
                  height: 22,
                ),
                onPressed: () => Get.to(
                  () => SearchScreen(),
                  transition: Transition.downToUp,
                ),
              ),
            ),
            Expanded(
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
            SizedBox(
              width: 48,
              height: 48,
              child: IconButton(
                splashRadius: 24,
                icon: Icon(
                  CupertinoIcons.person,
                  color: colorScheme.onSurface,
                  size: 25,
                ),
                onPressed: () => Get.to(() => const ProfileScreen()),
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

class _ThemedFunkyIcon extends StatelessWidget {
  final FunkyIcons icon;
  final Color color;
  final double height;

  const _ThemedFunkyIcon({
    required this.icon,
    required this.color,
    this.height = 22,
  });

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      child: FunkyIcon(icon, height: height),
    );
  }
}
