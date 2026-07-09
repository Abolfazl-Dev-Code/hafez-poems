import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:hafez_poems/collectionUnit/collection_fal_dialog_saved.dart';
import 'package:hafez_poems/collectionUnit/favorites_list.dart';
import 'package:hafez_poems/collectionUnit/selection_mixin.dart';
import 'package:hafez_poems/models/saved_item.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/bottomNavBar/user_actions_saver.dart';
import 'package:hafez_poems/poemsUnit/poems/persian_numbers.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_cache_services.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SavedTab extends StatefulWidget {
  const SavedTab({super.key});

  @override
  State<SavedTab> createState() => _SavedTabState();
}

class _SavedTabState extends State<SavedTab> with SelectionMixin {
  @override
  Widget build(BuildContext context) {
    final box = Hive.box<SavedItem>(UserActionsSaver.savedBoxName);
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
        actions: selectionMode ? [_buildActions(context, box)] : null,
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<SavedItem> b, _) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) pruneDeletedKeys(b.values.map((e) => e.key));
          });

          if (b.isEmpty) {
            return const Center(
              child: Text('هنوز هیچ اشعاری را ذخیره نکرده‌اید.'),
            );
          }

          final items = b.values.toList()
            ..sort((a, b) => extractId(b.id).compareTo(extractId(a.id)));

          return FavoritesList(
            selectedKeys: selectedKeys,
            selectionMode: selectionMode,
            onToggleSelect: toggleSelection,
            onLongPress: selectOnly,
            items: items.map((item) {
              final isFal = item.id.startsWith('fal_');
              final falNumber = isFal ? item.id.replaceFirst('fal_', '') : '';
              final isValidFalId =
                  falNumber.isNotEmpty &&
                  int.tryParse(falNumber) != null &&
                  int.parse(falNumber) < 10000;
              final subtitle = isFal
                  ? (isValidFalId ? 'غزل $falNumber' : 'فال حافظ')
                        .toPersianNumbers()
                  : item.text
                        .split('\n')
                        .firstWhere(
                          (l) => l.trim().isNotEmpty,
                          orElse: () => item.text,
                        );
              return FavoriteItem(
                itemKey: item.key,
                id: item.id,
                title: item.title,
                subtitle: subtitle,
                icon: isFal ? Icons.auto_awesome_rounded : Icons.bookmark,
                iconColor: isFal ? Colors.green : colorScheme.primary,
                onTap: () {
                  if (isFal) {
                    final parts = item.text.split('\n\n📖 تفسیر:\n');

                    final poemText = parts.isNotEmpty
                        ? parts[0].trim()
                        : item.text;

                    final tabirText = parts.length > 1 ? parts[1].trim() : '';

                    final falNumber = item.id.replaceFirst('fal_', '');

                    final isValid =
                        int.tryParse(falNumber) != null &&
                        int.parse(falNumber) < 10000;

                    Get.dialog(
                      FalDialog(
                        title: item.title,
                        poemText: poemText,
                        tabirText: tabirText,
                        falNumber: isValid ? falNumber : '',
                      ),
                    );

                    return;
                  }

                  // غزل معمولی
                  Get.to(
                    () => PoemScreen(
                      args: PoemScreenArgs(
                        id: item.id,
                        title: item.title,
                        text: item.text,
                        fetchText: (id) async {
                          return item.text;
                        },
                        fetchAudioUrl: (id) {
                          return isFal
                              ? Future.value('')
                              : Get.find<GhazalCacheService>().getAudioUrl(id);
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

  Widget _buildActions(BuildContext context, Box<SavedItem> box) {
    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box<SavedItem> b, _) {
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
