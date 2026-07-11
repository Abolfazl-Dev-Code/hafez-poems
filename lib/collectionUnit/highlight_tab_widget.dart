import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:hafez_poems/collectionUnit/favorites_list.dart';
import 'package:hafez_poems/collectionUnit/selection_mixin.dart';
import 'package:hafez_poems/core/data/contracts/i_keyed_item_storage.dart';
import 'package:hafez_poems/models/highlight_item.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/bottomNavBar/user_actions_saver.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_cache_services.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_local_services.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_screen.dart';

class HighlightsTab extends StatefulWidget {
  const HighlightsTab({super.key});

  @override
  State<HighlightsTab> createState() => _HighlightsTabState();
}

class _HighlightsTabState extends State<HighlightsTab> with SelectionMixin {
  IKeyedItemStorage<HighlightItem> get _storage =>
      Get.find<IKeyedItemStorage<HighlightItem>>();

  String _keyOf(HighlightItem item) =>
      UserActionsSaver.highlightKey(item.poemId, item.lineIndex);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectionMode
              ? '${selectedKeys.length} مورد انتخاب شده'
              : 'برگزیده‌‌ها',
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
            if (mounted) pruneDeletedKeys(items.map(_keyOf));
          });

          if (items.isEmpty) {
            return const Center(
              child: Text('هنوز هیچ مصرعی را برگزیده‌ نکرده‌اید.'),
            );
          }

          return FavoritesList(
            selectedKeys: selectedKeys,
            selectionMode: selectionMode,
            onToggleSelect: toggleSelection,
            onLongPress: selectOnly,
            items: items
                .map(
                  (item) => FavoriteItem(
                    itemKey: _keyOf(item),
                    id: item.poemId,
                    title: item.poemTitle,
                    subtitle: item.highlightedLine,
                    badge: 'مصرع ${item.lineIndex + 1}',
                    icon: Icons.highlight,
                    iconColor: Colors.amber.shade700,
                    highlightBg: Color(item.colorValue),
                    onTap: () => Get.to(
                      () => PoemScreen(
                        args: PoemScreenArgs(
                          id: item.poemId,
                          title: item.poemTitle,
                          text: item.poemText,
                          audioUrl: item.audioUrl,
                          highlightLineIndex: item.lineIndex,
                          fetchText: (id) => GhazalLocalService.instance
                              .fetchGhazalById(id)
                              .then((g) => g.text),
                          fetchAudioUrl: (id) =>
                              Get.find<GhazalCacheService>().getAudioUrl(id),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return StreamBuilder<void>(
      stream: _storage.watch(),
      builder: (context, _) {
        final allKeys = _storage.values().map(_keyOf);
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
