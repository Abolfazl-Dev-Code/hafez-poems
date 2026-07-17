import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:hafez_poems/collectionUnit/favorites_list.dart';
import 'package:hafez_poems/collectionUnit/selection_mixin.dart';
import 'package:hafez_poems/core/data/contracts/i_keyed_item_storage.dart';
import 'package:hafez_poems/models/liked_item.dart';
import 'package:hafez_poems/poemsUnit/poems/persian_numbers.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_category_resolver.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_screen.dart';

class LikedTab extends StatefulWidget {
  const LikedTab({super.key});

  @override
  State<LikedTab> createState() => _LikedTabState();
}

class _LikedTabState extends State<LikedTab> with SelectionMixin {
  IKeyedItemStorage<LikedItem> get _storage =>
      Get.find<IKeyedItemStorage<LikedItem>>();

  String _keyOf(LikedItem item) => '${item.poemId}|${item.category}';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectionMode
              ? '${selectedKeys.length} مورد انتخاب شده'.toPersianNumbers()
              : 'اشعار علاقه‌مندی‌‌شده',
        ),
        centerTitle: !selectionMode,
        actions: selectionMode ? [_buildActions(context)] : null,
      ),
      body: StreamBuilder<void>(
        stream: _storage.watch(),
        builder: (context, _) {
          final items = _storage.values().toList()
            ..sort(
              (a, b) => int.parse(a.poemId).compareTo(int.parse(b.poemId)),
            );

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) pruneDeletedKeys(items.map(_keyOf));
          });
          if (items.isEmpty) {
            return const Center(
              child: Text('هنوز هیچ اشعاری را علاقه‌مندی‌ نکرده‌اید.'),
            );
          }

          return FavoritesList(
            selectedKeys: selectedKeys,
            selectionMode: selectionMode,
            onToggleSelect: toggleSelection,
            onLongPress: selectOnly,
            items: items.map((ghazal) {
              final firstLine = ghazal.poemText
                  .split('\n')
                  .firstWhere(
                    (l) => l.trim().isNotEmpty,
                    orElse: () => ghazal.poemText,
                  );
              return FavoriteItem(
                itemKey: _keyOf(ghazal),
                id: ghazal.poemId,
                title: ghazal.poemTitle,
                subtitle: firstLine,
                icon: Icons.favorite,
                iconColor: colorScheme.error,
                onTap: () => Get.to(
                  () => PoemScreen(
                    args: PoemScreenArgs(
                      id: ghazal.poemId,
                      category: ghazal.category,
                      title: ghazal.poemTitle,
                      text: ghazal.poemText,
                      audioUrl: ghazal.audioUrl,
                      fetchText: PoemCategoryResolver.fetchTextFor(
                        ghazal.category,
                      ),
                      fetchAudioUrl: PoemCategoryResolver.fetchAudioUrlFor(
                        ghazal.category,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return StreamBuilder<void>(
      stream: _storage.watch(),
      builder: (context, _) {
        final allKeys = _storage.values().map(_keyOf).toList();

        final allSelected =
            allKeys.isNotEmpty && selectedKeys.length == allKeys.length;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                if (allSelected) {
                  clearSelection();
                } else {
                  selectAll(allKeys);
                }
              },
              child: Text(allSelected ? 'لغو همه' : 'انتخاب همه'),
            ),
            IconButton(
              onPressed: selectedKeys.isEmpty
                  ? null
                  : () => deleteSelected(context, _storage),
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        );
      },
    );
  }
}
