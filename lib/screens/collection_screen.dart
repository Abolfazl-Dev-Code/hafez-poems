import 'package:flutter/foundation.dart';
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
    with SelectionMixin, SingleTickerProviderStateMixin {
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
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: widget.initialTab)
          ..addListener(() {
            if (_tabController.index != _currentTab) {
              setState(() {
                _currentTab = _tabController.index;
                selectedKeys.clear();
              });
            }
          });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String get _appBarTitle {
    if (selectionMode) return '${selectedKeys.length} مورد انتخاب شده';
    if (!widget.showTabs) return _tabTitles[widget.initialTab];
    return 'مجموعه من';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: selectionMode
              ? IconButton(
                  onPressed: clearSelection,
                  icon: const Icon(Icons.close),
                )
              : null,
          title: Text(_appBarTitle),
          centerTitle: !selectionMode,
          actions: selectionMode ? [_buildSelectionActions()] : null,
          bottom: widget.showTabs
              ? TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(icon: Icon(Icons.favorite_outline), text: 'لایک‌ها'),
                    Tab(icon: Icon(Icons.bookmark_outline), text: 'ذخیره‌شده'),
                    Tab(icon: Icon(Icons.highlight), text: 'هایلایت‌ها'),
                  ],
                )
              : null,
        ),
        body: widget.showTabs
            ? TabBarView(controller: _tabController, children: _buildTabs())
            : _buildTabs()[widget.initialTab],
      ),
    );
  }

  List<Widget> _buildTabs() {
    final effectiveTab = widget.showTabs ? _currentTab : widget.initialTab;
    return [
      _LikedTab(
        selectedKeys: effectiveTab == 0 ? selectedKeys : {},
        selectionMode: effectiveTab == 0 && selectionMode,
        onToggleSelect: toggleSelection,
        onLongPress: selectOnly,
        onPrune: _safeOnPrune,
      ),
      _SavedTab(
        selectedKeys: effectiveTab == 1 ? selectedKeys : {},
        selectionMode: effectiveTab == 1 && selectionMode,
        onToggleSelect: toggleSelection,
        onLongPress: selectOnly,
        onPrune: _safeOnPrune,
      ),
      _HighlightsTab(
        selectedKeys: effectiveTab == 2 ? selectedKeys : {},
        selectionMode: effectiveTab == 2 && selectionMode,
        onToggleSelect: toggleSelection,
        onLongPress: selectOnly,
        onPrune: _safeOnPrune,
      ),
    ];
  }

  void _safeOnPrune(Iterable<dynamic> validKeys) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) pruneDeletedKeys(validKeys);
    });
  }

  Widget _buildSelectionActions() {
    return ValueListenableBuilder(
      valueListenable: _currentTabBox(),
      builder: (context, box, _) {
        final allKeys = (box as Box).values.map((e) => (e as HiveObject).key);
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

  ValueListenable _currentTabBox() {
    return switch (_currentTab) {
      0 => Hive.box<LikedItem>(
        GhazalActionController.likedBoxName,
      ).listenable(),
      1 => Hive.box<SavedItem>(
        GhazalActionController.savedBoxName,
      ).listenable(),
      _ => Hive.box<HighlightItem>(
        GhazalActionController.highlightBoxName,
      ).listenable(),
    };
  }
}

class _LikedTab extends StatelessWidget {
  final Set<dynamic> selectedKeys;
  final bool selectionMode;
  final void Function(dynamic) onToggleSelect;
  final void Function(dynamic) onLongPress;
  final void Function(Iterable<dynamic>) onPrune;

  const _LikedTab({
    required this.selectedKeys,
    required this.selectionMode,
    required this.onToggleSelect,
    required this.onLongPress,
    required this.onPrune,
  });

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<LikedItem>(GhazalActionController.likedBoxName);
    final colorScheme = Theme.of(context).colorScheme;

    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box<LikedItem> b, _) {
        onPrune(b.values.map((e) => e.key));

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
          onToggleSelect: onToggleSelect,
          onLongPress: onLongPress,
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
    );
  }
}

class _SavedTab extends StatelessWidget {
  final Set<dynamic> selectedKeys;
  final bool selectionMode;
  final void Function(dynamic) onToggleSelect;
  final void Function(dynamic) onLongPress;
  final void Function(Iterable<dynamic>) onPrune;

  const _SavedTab({
    required this.selectedKeys,
    required this.selectionMode,
    required this.onToggleSelect,
    required this.onLongPress,
    required this.onPrune,
  });

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<SavedItem>(GhazalActionController.savedBoxName);
    final colorScheme = Theme.of(context).colorScheme;

    int extractId(String id) =>
        int.tryParse(RegExp(r'\d+').firstMatch(id)?.group(0) ?? '') ?? 0;

    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box<SavedItem> b, _) {
        onPrune(b.values.map((e) => e.key));

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
          onToggleSelect: onToggleSelect,
          onLongPress: onLongPress,
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
    );
  }
}

class _HighlightsTab extends StatelessWidget {
  final Set<dynamic> selectedKeys;
  final bool selectionMode;
  final void Function(dynamic) onToggleSelect;
  final void Function(dynamic) onLongPress;
  final void Function(Iterable<dynamic>) onPrune;

  const _HighlightsTab({
    required this.selectedKeys,
    required this.selectionMode,
    required this.onToggleSelect,
    required this.onLongPress,
    required this.onPrune,
  });

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<HighlightItem>(
      GhazalActionController.highlightBoxName,
    );

    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box<HighlightItem> b, _) {
        onPrune(b.values.map((e) => e.key));
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
          onToggleSelect: onToggleSelect,
          onLongPress: onLongPress,
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
    );
  }
}
