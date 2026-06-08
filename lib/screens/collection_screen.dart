import 'package:flutter/material.dart';
import 'package:hafez_poems/screens/favorites_list.dart';
import 'package:hafez_poems/services/ghazal_cache_service_offline.dart';
import 'package:hafez_poems/widgets/selection_mixin.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hafez_poems/controllers/ghazal_action_controller.dart';
import 'package:hafez_poems/models/highlight_item.dart';
import 'package:hafez_poems/models/liked_item.dart';
import 'package:hafez_poems/models/saved_item.dart';
import 'package:hafez_poems/screens/poem_screen.dart';
import 'package:hafez_poems/services/ghazal_local_service.dart';

class CollectionScreen extends StatefulWidget {
  final int initialTab;
  final bool showTabs;

  const CollectionScreen({
    super.key,
    this.initialTab = 0,
    this.showTabs = true,
  });

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _currentTab = 0;

  static const List<String> _tabTitles = [
    'اشعار لایک‌شده',
    'اشعار ذخیره‌شده',
    'هایلایت‌ها',
  ];

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTab;
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTab,
    );
    _tabController.addListener(() {
      if (_tabController.index != _currentTab) {
        setState(() => _currentTab = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: widget.showTabs
            ? AppBar(
                title: Text(_tabTitles[_currentTab]), // ← title تب فعلی
                centerTitle: true,
                bottom: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(icon: Icon(Icons.favorite_outline), text: 'لایک‌ها'),
                    Tab(icon: Icon(Icons.bookmark_outline), text: 'ذخیره‌شده'),
                    Tab(icon: Icon(Icons.highlight), text: 'هایلایت‌ها'),
                  ],
                ),
              )
            : null,
        body: widget.showTabs
            ? IndexedStack(
                index: _currentTab,
                children: const [_LikedTab(), _SavedTab(), _HighlightsTab()],
              )
            : switch (widget.initialTab) {
                0 => const _LikedTab(),
                1 => const _SavedTab(),
                _ => const _HighlightsTab(),
              },
      ),
    );
  }
}

class _LikedTab extends StatefulWidget {
  const _LikedTab();

  @override
  State<_LikedTab> createState() => _LikedTabState();
}

class _LikedTabState extends State<_LikedTab> with SelectionMixin {
  @override
  Widget build(BuildContext context) {
    final box = Hive.box<LikedItem>(GhazalActionController.likedBoxName);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectionMode
              ? '${selectedKeys.length} مورد انتخاب شده'
              : 'اشعار لایک‌شده',
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
              child: Text('هنوز هیچ اشعاری را لایک نکرده‌اید.'),
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
                onIconTap: () => box.delete(ghazal.key),
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
              child: const Text('همه'),
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

class _SavedTab extends StatefulWidget {
  const _SavedTab();

  @override
  State<_SavedTab> createState() => _SavedTabState();
}

class _SavedTabState extends State<_SavedTab> with SelectionMixin {
  @override
  Widget build(BuildContext context) {
    final box = Hive.box<SavedItem>(GhazalActionController.savedBoxName);
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
              final firstLine = item.text
                  .split('\n')
                  .firstWhere(
                    (l) => l.trim().isNotEmpty,
                    orElse: () => item.text,
                  );
              return FavoriteItem(
                hiveKey: item.key,
                id: item.id,
                title: item.title,
                subtitle: firstLine,
                icon: isFal ? Icons.auto_awesome_rounded : Icons.bookmark,
                iconColor: isFal ? Colors.green : colorScheme.primary,
                onIconTap: () => box.delete(item.key),
                onTap: () {
                  if (isFal) {
                    Get.dialog(
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: AlertDialog(
                          title: Text(item.title),
                          content: SingleChildScrollView(
                            child: Text(
                              item.text,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(height: 1.8),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: Get.back,
                              child: const Text('بستن'),
                            ),
                          ],
                        ),
                      ),
                    );
                    return;
                  }
                  Get.to(
                    () => PoemScreen(
                      args: PoemScreenArgs(
                        id: item.id,
                        title: item.title,
                        text: item.text,
                        audioUrl: item.audioUrl,
                        fetchText: (id) => GhazalLocalService.instance
                            .fetchGhazalById(id)
                            .then((g) => g.text),
                        fetchAudioUrl: (id) =>
                            Get.find<GhazalCacheService>().getAudioUrl(id),
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
              child: const Text('همه'),
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

class _HighlightsTab extends StatefulWidget {
  const _HighlightsTab();

  @override
  State<_HighlightsTab> createState() => _HighlightsTabState();
}

class _HighlightsTabState extends State<_HighlightsTab> with SelectionMixin {
  @override
  Widget build(BuildContext context) {
    final box = Hive.box<HighlightItem>(
      GhazalActionController.highlightBoxName,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectionMode
              ? '${selectedKeys.length} مورد انتخاب شده'
              : 'هایلایت‌ها',
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
              child: Text('هنوز هیچ بیتی را هایلایت نکرده‌اید.'),
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
                    badge: 'بیت ${item.lineIndex + 1}',
                    icon: Icons.highlight,
                    iconColor: Colors.amber.shade700,
                    highlightBg: Color(item.colorValue),
                    onIconTap: () => box.delete(item.key),
                    onTap: () => Get.to(
                      () => PoemScreen(
                        args: PoemScreenArgs(
                          id: item.ghazalId,
                          title: item.ghazalTitle,
                          text: item.ghazalText,
                          audioUrl: item.audioUrl,
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
              child: const Text('همه'),
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
