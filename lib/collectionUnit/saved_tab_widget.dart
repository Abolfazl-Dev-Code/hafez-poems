import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:hafez_poems/collectionUnit/collection_fal_dialog_saved.dart';
import 'package:hafez_poems/collectionUnit/favorites_list.dart';
import 'package:hafez_poems/collectionUnit/selection_mixin.dart';
import 'package:hafez_poems/core/data/contracts/i_keyed_item_storage.dart';
import 'package:hafez_poems/models/saved_item.dart';
import 'package:hafez_poems/poemsUnit/poems/persian_numbers.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_category_resolver.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_screen.dart';

class SavedTab extends StatefulWidget {
  const SavedTab({super.key});

  @override
  State<SavedTab> createState() => _SavedTabState();
}

class _SavedTabState extends State<SavedTab> with SelectionMixin {
  IKeyedItemStorage<SavedItem> get _storage =>
      Get.find<IKeyedItemStorage<SavedItem>>();

  String _keyOf(SavedItem item) => '${item.poemId}|${item.category}';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    int extractId(String id) =>
        int.tryParse(RegExp(r'\d+').firstMatch(id)?.group(0) ?? '') ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectionMode
              ? '${selectedKeys.length} مورد انتخاب شده'
              : 'اشعار ذخیره‌شده',
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
              (a, b) => extractId(b.poemId).compareTo(extractId(a.poemId)),
            );

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) pruneDeletedKeys(items.map(_keyOf));
          });

          if (items.isEmpty) {
            return const Center(
              child: Text('هنوز هیچ اشعاری را ذخیره نکرده‌اید.'),
            );
          }

          return FavoritesList(
            selectedKeys: selectedKeys,
            selectionMode: selectionMode,
            onToggleSelect: toggleSelection,
            onLongPress: selectOnly,
            items: items.map((item) {
              final isFal = item.poemId.startsWith('fal_');
              final falNumber = isFal
                  ? item.poemId.replaceFirst('fal_', '')
                  : '';
              final isValidFalId =
                  falNumber.isNotEmpty &&
                  int.tryParse(falNumber) != null &&
                  int.parse(falNumber) < 10000;
              final subtitle = isFal
                  ? (isValidFalId ? 'غزل $falNumber' : 'فال حافظ')
                        .toPersianNumbers()
                  : item.poemText
                        .split('\n')
                        .firstWhere(
                          (l) => l.trim().isNotEmpty,
                          orElse: () => item.poemText,
                        );
              return FavoriteItem(
                itemKey: _keyOf(item),
                id: item.poemId,
                title: item.poemTitle,
                subtitle: subtitle,
                icon: isFal ? Icons.auto_awesome_rounded : Icons.bookmark,
                iconColor: isFal ? Colors.green : colorScheme.primary,
                onTap: () {
                  if (isFal) {
                    final parts = item.poemText.split('\n\n📖 تفسیر:\n');

                    final poemText = parts.isNotEmpty
                        ? parts[0].trim()
                        : item.poemText;

                    final tabirText = parts.length > 1 ? parts[1].trim() : '';

                    final falNumber = item.poemId.replaceFirst('fal_', '');

                    final isValid =
                        int.tryParse(falNumber) != null &&
                        int.parse(falNumber) < 10000;

                    Get.dialog(
                      FalDialog(
                        title: item.poemTitle,
                        poemText: poemText,
                        tabirText: tabirText,
                        falNumber: isValid ? falNumber : '',
                      ),
                    );

                    return;
                  }
                  Get.to(
                    () => PoemScreen(
                      args: PoemScreenArgs(
                        id: item.poemId,
                        category: item.category,
                        title: item.poemTitle,
                        text: item.poemText,
                        fetchText: (id) async => item.poemText,
                        fetchAudioUrl: (id) {
                          return isFal
                              ? Future.value('')
                              : PoemCategoryResolver.fetchAudioUrlFor(
                                  item.category,
                                )(id);
                        },
                      ),
                    ),
                  );
                },
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
