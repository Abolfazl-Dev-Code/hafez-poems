import 'package:flutter/material.dart';
import 'package:hafez_poems/poemsUnit/poemsActionBarUnit/poem_favorites_list_card_selector.dart';

class FavoriteItem {
  final dynamic hiveKey;
  final String id;
  final String title;
  final String subtitle;
  final String? badge;
  final IconData icon;
  final Color iconColor;
  final Color? highlightBg;
  final VoidCallback onTap;

  const FavoriteItem({
    required this.hiveKey,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.badge,
    this.highlightBg,
  });
}

class FavoritesList extends StatelessWidget {
  final List<FavoriteItem> items;
  final Set<dynamic> selectedKeys;
  final bool selectionMode;
  final void Function(dynamic key) onToggleSelect;
  final void Function(dynamic key) onLongPress;

  const FavoritesList({
    super.key,
    required this.items,
    required this.selectedKeys,
    required this.selectionMode,
    required this.onToggleSelect,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 2, 12, 65),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = selectedKeys.contains(item.hiveKey);
        return _FavoriteCard(
          item: item,
          isSelected: isSelected,
          selectionMode: selectionMode,
          onToggleSelect: () => onToggleSelect(item.hiveKey),
          onLongPress: () => onLongPress(item.hiveKey),
        );
      },
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final FavoriteItem item;
  final bool isSelected;
  final bool selectionMode;
  final VoidCallback onToggleSelect;
  final VoidCallback onLongPress;

  const _FavoriteCard({
    required this.item,
    required this.isSelected,
    required this.selectionMode,
    required this.onToggleSelect,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;

    final cardColor = isLight
        ? Colors.white
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.7);
    final borderColor = isSelected
        ? colorScheme.primary
        : isLight
        ? Colors.grey.shade300
        : colorScheme.outlineVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: selectionMode ? onToggleSelect : item.onTap,
        onLongPress: onLongPress,
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 1.6 : 0.8,
            ),
            boxShadow: [
              if (isLight)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              if (selectionMode) ...[
                PoemFavoritesListCardSelector(
                  isSelected: isSelected,
                  colorScheme: colorScheme,
                ),
                const SizedBox(width: 8),
              ],
              Icon(item.icon, color: item.iconColor),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.badge != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.badge!,
                        style: textTheme.labelSmall?.copyWith(
                          color: isLight
                              ? Colors.grey.shade600
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    if (item.highlightBg != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: item.highlightBg!.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.subtitle,
                          style: textTheme.bodyMedium?.copyWith(
                            color: isLight
                                ? Colors.black87
                                : colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    else
                      Text(
                        item.subtitle,
                        style: textTheme.bodyMedium?.copyWith(
                          color: isLight
                              ? Colors.black87
                              : colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_left_rounded, color: colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}
