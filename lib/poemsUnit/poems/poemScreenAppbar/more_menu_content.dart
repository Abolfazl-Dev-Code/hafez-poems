import 'package:flutter/material.dart';
import 'more_menu_item.dart';
import 'staggered_menu_item.dart';

class MoreMenuContent extends StatelessWidget {
  final ValueNotifier<bool> isLiked;
  final ValueNotifier<bool> isSaved;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback onLike;
  final VoidCallback onSave;
  final VoidCallback onShare;

  const MoreMenuContent({
    super.key,
    required this.isLiked,
    required this.isSaved,
    required this.colorScheme,
    required this.textTheme,
    required this.onLike,
    required this.onSave,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StaggeredMenuItem(
            delay: 40,
            child: MoreMenuItem(
              icon: Icons.share_outlined,
              label: 'اشتراک‌گذاری شعر',
              isActive: false,
              colorScheme: colorScheme,
              textTheme: textTheme,
              onTap: onShare,
            ),
          ),

          Divider(
            height: 0.5,
            thickness: 0.5,
            indent: 10,
            endIndent: 10,
            color: colorScheme.outlineVariant,
          ),

          ValueListenableBuilder<bool>(
            valueListenable: isLiked,
            builder: (context, liked, _) {
              return StaggeredMenuItem(
                delay: 85,
                child: MoreMenuItem(
                  icon: liked ? Icons.favorite : Icons.favorite_border,
                  label: liked
                      ? 'حذف از علاقه‌مندی‌ها'
                      : 'افزودن به علاقه‌مندی‌ها',
                  isActive: liked,
                  activeColor: Colors.red.shade400,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                  onTap: onLike,
                ),
              );
            },
          ),

          Divider(
            height: 0.5,
            thickness: 0.5,
            indent: 10,
            endIndent: 10,
            color: colorScheme.outlineVariant,
          ),

          ValueListenableBuilder<bool>(
            valueListenable: isSaved,
            builder: (context, saved, _) {
              return StaggeredMenuItem(
                delay: 130,
                child: MoreMenuItem(
                  icon: saved ? Icons.bookmark : Icons.bookmark_border,
                  label: saved ? 'حذف از ذخیره' : 'ذخیره برای بعد',
                  isActive: saved,
                  activeColor: Colors.greenAccent.shade400,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                  onTap: onSave,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
