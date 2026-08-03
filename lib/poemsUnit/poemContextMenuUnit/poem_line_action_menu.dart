import 'package:hafez_poems/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:hafez_poems/poemsUnit/poemContextMenuUnit/menu_item_data.dart';
import 'package:hafez_poems/theme/color_style.dart';

class ActionMenu extends StatelessWidget {
  const ActionMenu({
    super.key,
    required this.isHighlighted,
    required this.fadeValue,
    required this.isDark,
    required this.onCopy,
    required this.onToggleHighlight,
    required this.onShareAsImage,
    required this.onPlayFromHere,
  });

  final bool isHighlighted;
  final double fadeValue;
  final bool isDark;
  final VoidCallback onCopy;
  final VoidCallback onToggleHighlight;
  final VoidCallback onShareAsImage;
  final VoidCallback onPlayFromHere;

  static const int itemCount = 4;
  static const double itemHeight = 46;
  static const double dividerHeight = 1;

  static double estimatedHeight() =>
      itemCount * itemHeight + (itemCount - 1) * dividerHeight;

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.darkSurface : AppColors.surface;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final iconColor = isDark ? AppColors.darkIcon : AppColors.icon;
    final shadow = isDark ? AppColors.darkShadow : AppColors.shadow;

    final items = <MenuItemData>[
      MenuItemData(icon: Icons.copy_rounded, label: 'کپی مصرع', onTap: onCopy),
      MenuItemData(
        icon: isHighlighted
            ? Icons.highlight_remove_rounded
            : Icons.highlight_rounded,
        label: isHighlighted ? 'حذف برگزیده' : 'برگزیدن مصرع',
        onTap: onToggleHighlight,
      ),
      MenuItemData(
        icon: Icons.image_rounded,
        label: 'اشتراک گذاری مصرع دلخواه',
        onTap: onShareAsImage,
      ),
      MenuItemData(
        icon: Icons.play_circle_fill_rounded,
        label: 'از اینجا بخوان',
        onTap: onPlayFromHere,
      ),
    ];

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 230,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: AppRadius.lgRadius,
          border: Border.all(color: border.withValues(alpha: 0.75), width: 1),
          boxShadow: [
            BoxShadow(
              color: shadow,
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(items.length, (i) {
            final item = items[i];

            final start = i * 0.08;
            final t = ((fadeValue - start) / (1 - start)).clamp(0.0, 1.0);

            return Opacity(
              opacity: t,
              child: Column(
                children: [
                  if (i > 0)
                    Divider(
                      height: 0.75,
                      color: border.withValues(alpha: 0.5),
                      indent: 10,
                      endIndent: 10,
                    ),
                  InkWell(
                    onTap: item.onTap,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 13,
                      ),
                      child: Row(
                        children: [
                          Icon(item.icon, size: 20, color: iconColor),
                          const SizedBox(width: 12),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
