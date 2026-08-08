import 'package:hafez_poems/theme/app_icons.dart';
import 'package:hafez_poems/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:hafez_poems/poemsUnit/poemContextMenuUnit/menu_item_data.dart';
import 'package:hafez_poems/theme/color_style.dart';
import 'package:lottie/lottie.dart';

class ActionMenu extends StatelessWidget {
  const ActionMenu({
    super.key,
    required this.isHighlighted,
    required this.isReadMarker,
    required this.fadeValue,
    required this.isDark,
    required this.onCopy,
    required this.onToggleHighlight,
    required this.onToggleReadMarker,
    required this.onShareAsImage,
    required this.onPlayFromHere,
  });

  final bool isHighlighted;
  final bool isReadMarker;
  final double fadeValue;
  final bool isDark;
  final VoidCallback onCopy;
  final VoidCallback onToggleHighlight;
  final VoidCallback onToggleReadMarker;
  final VoidCallback onShareAsImage;
  final VoidCallback onPlayFromHere;

  static const int itemCount = 5;
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
      MenuItemData(
        iconBuilder: (color) =>
            Icon(Icons.content_copy_rounded, size: 18, color: color),
        label: 'کپی مصرع',
        onTap: onCopy,
      ),
      MenuItemData(
        iconBuilder: (color) => ClipRect(
          child: SizedBox(
            width: 20,
            height: 20,
            child: Stack(
              children: [
                for (final offset in const [
                  Offset(0, 0),
                  Offset(0.6, 0),
                  Offset(0, 0),
                  Offset(0.6, 0),
                ])
                  Transform.translate(
                    offset: offset,
                    child: Transform.scale(
                      scale: 2.6,
                      child: Lottie.asset(
                        AppIcons.highlight,
                        fit: BoxFit.contain,
                        animate: false,
                        repeat: false,
                        delegates: LottieDelegates(
                          values: [
                            ValueDelegate.color(const ['**'], value: color),
                            ValueDelegate.strokeWidth(const [
                              '**',
                            ], value: 54.0),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        label: isHighlighted ? 'حذف برگزیده' : 'برگزیدن مصرع',
        onTap: onToggleHighlight,
      ),
      MenuItemData(
        iconBuilder: (color) => Icon(
          isReadMarker
              ? Icons.bookmark_remove_outlined
              : Icons.bookmark_add_outlined,
          size: 18,
          color: color,
        ),
        label: isReadMarker ? 'حذف خوانده شده' : 'تا اینجا خوانده‌ام',
        onTap: onToggleReadMarker,
      ),
      MenuItemData(
        iconBuilder: (color) =>
            Icon(Icons.share_outlined, size: 18, color: color),
        label: 'اشتراک گذاری مصرع دلخواه',
        onTap: onShareAsImage,
      ),
      MenuItemData(
        iconBuilder: (color) =>
            Icon(Icons.play_circle_outline_outlined, size: 18, color: color),
        label: 'از این مصرع بخوان',
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
                          item.iconBuilder(iconColor),
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
