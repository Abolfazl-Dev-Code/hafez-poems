import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:hafez_poems/collectionUnit/favorites_list.dart';
import 'package:hafez_poems/collectionUnit/selection_mixin.dart';
import 'package:hafez_poems/models/highlight_item.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/bottomNavBar/user_actions_saver.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_cache_services.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_local_services.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HighlightsTab extends StatefulWidget {
  const HighlightsTab({super.key});

  @override
  State<HighlightsTab> createState() => _HighlightsTabState();
}

class _HighlightsTabState extends State<HighlightsTab> with SelectionMixin {
  @override
  Widget build(BuildContext context) {
    final box = Hive.box<HighlightItem>(UserActionsSaver.highlightBoxName);

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
        actions: selectionMode ? [_buildActions(context, box)] : null,
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<HighlightItem> b, _) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) pruneDeletedKeys(b.values.map((e) => e.key));
          });

          if (b.isEmpty) {
            return const Center(
              child: Text('هنوز هیچ مصرعی را برگزیده‌ نکرده‌اید.'),
            );
          }

          final items = b.values.toList()
            ..sort(
              (a, b) => int.parse(a.ghazalId).compareTo(int.parse(b.ghazalId)),
            );

          return FavoritesList(
            selectedKeys: selectedKeys,
            selectionMode: selectionMode,
            onToggleSelect: toggleSelection,
            onLongPress: selectOnly,
            items: items
                .map(
                  (item) => FavoriteItem(
                    hiveKey: item.key,
                    id: item.ghazalId,
                    title: item.ghazalTitle,
                    subtitle: item.highlightedLine,
                    badge: 'مصرع ${item.lineIndex + 1}',
                    icon: Icons.highlight,
                    iconColor: Colors.amber.shade700,
                    highlightBg: Color(item.colorValue),
                    onTap: () => Get.to(
                      () => PoemScreen(
                        args: PoemScreenArgs(
                          id: item.ghazalId,
                          title: item.ghazalTitle,
                          text: item.ghazalText,
                          audioUrl: item.audioUrl,
                          highlightLineIndex: item.lineIndex, // ← اضافه
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

  Widget _buildActions(BuildContext context, Box<HighlightItem> box) {
    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box<HighlightItem> b, _) {
        final allKeys = b.values.map((e) => e.key);
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
                  : () => deleteSelected(context, box as Box<HiveObject>),
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        );
      },
    );
  }
}
