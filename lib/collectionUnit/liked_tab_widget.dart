import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:hafez_poems/collectionUnit/favorites_list.dart';
import 'package:hafez_poems/collectionUnit/selection_mixin.dart';
import 'package:hafez_poems/core/data/contracts/i_keyed_item_storage.dart';
import 'package:hafez_poems/models/liked_item.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_cache_services.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_local_services.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_screen.dart';

class LikedTab extends StatefulWidget {
  const LikedTab({super.key});

  @override
  State<LikedTab> createState() => _LikedTabState();
}

class _LikedTabState extends State<LikedTab> with SelectionMixin {
  IKeyedItemStorage<LikedItem> get _storage =>
      Get.find<IKeyedItemStorage<LikedItem>>();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectionMode
              ? '${selectedKeys.length} مورد انتخاب شده'
              : 'اشعار علاقه‌مندی‌‌شده',
        ),
        centerTitle: !selectionMode,
        leading: selectionMode
            ? IconButton(
                onPressed: clearSelection,
                icon: const Icon(Icons.close),
              )
            : null,
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
            if (mounted) pruneDeletedKeys(items.map((e) => e.poemId));
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
                itemKey: ghazal.poemId,
                id: ghazal.poemId,
                title: ghazal.poemTitle,
                subtitle: firstLine,
                icon: Icons.favorite,
                iconColor: colorScheme.error,
                onTap: () => Get.to(
                  () => PoemScreen(
                    args: PoemScreenArgs(
                      id: ghazal.poemId,
                      title: ghazal.poemTitle,
                      text: ghazal.poemText,
                      audioUrl: ghazal.audioUrl,
                      fetchText: (id) => GhazalLocalService.instance
                          .fetchGhazalById(id)
                          .then((g) => g.text),
                      fetchAudioUrl: (id) =>
                          Get.find<GhazalCacheService>().getAudioUrl(id),
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
        final allKeys = _storage.values().map((e) => e.poemId);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => selectAll(allKeys),
              child: const Text('انتخاب همه'),
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
