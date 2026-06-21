import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:hafez_poems/controllers/user_actions_controller.dart';
import 'package:hafez_poems/models/liked_item.dart';
import 'package:hafez_poems/screens/favorites_list.dart';
import 'package:hafez_poems/screens/poem_screen.dart';
import 'package:hafez_poems/services/poem_cache_services.dart';
import 'package:hafez_poems/services/poem_local_services.dart';
import 'package:hafez_poems/widgets/selection_mixin.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LikedTab extends StatefulWidget {
  const LikedTab({super.key});

  @override
  State<LikedTab> createState() => _LikedTabState();
}

class _LikedTabState extends State<LikedTab> with SelectionMixin {
  @override
  Widget build(BuildContext context) {
    final box = Hive.box<LikedItem>(UserActionsController.likedBoxName);
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
        actions: selectionMode ? [_buildActions(context, box)] : null,
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<LikedItem> b, _) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) pruneDeletedKeys(b.values.map((e) => e.key));
          });

          if (b.isEmpty) {
            return const Center(
              child: Text('هنوز هیچ اشعاری را علاقه‌مندی‌ نکرده‌اید.'),
            );
          }

          final items = b.values.toList()
            ..sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));

          return FavoritesList(
            selectedKeys: selectedKeys,
            selectionMode: selectionMode,
            onToggleSelect: toggleSelection,
            onLongPress: selectOnly,
            items: items.map((ghazal) {
              final firstLine = ghazal.text
                  .split('\n')
                  .firstWhere(
                    (l) => l.trim().isNotEmpty,
                    orElse: () => ghazal.text,
                  );
              return FavoriteItem(
                hiveKey: ghazal.key,
                id: ghazal.id,
                title: ghazal.title,
                subtitle: firstLine,
                icon: Icons.favorite,
                iconColor: colorScheme.error,
                onTap: () => Get.to(
                  () => PoemScreen(
                    args: PoemScreenArgs(
                      id: ghazal.id,
                      title: ghazal.title,
                      text: ghazal.text,
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

  Widget _buildActions(BuildContext context, Box<LikedItem> box) {
    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box<LikedItem> b, _) {
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
