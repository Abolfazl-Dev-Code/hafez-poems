import 'package:flutter/material.dart';
import 'package:hafez_poems/screens/favorites_list.dart';
import 'package:hafez_poems/services/poem_cache_services.dart';
import 'package:hafez_poems/services/poem_local_services.dart';
import 'package:hafez_poems/widgets/persian_numbers.dart';
import 'package:hafez_poems/widgets/selection_mixin.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hafez_poems/controllers/ghazal_action_controller.dart';
import 'package:hafez_poems/models/highlight_item.dart';
import 'package:hafez_poems/models/liked_item.dart';
import 'package:hafez_poems/models/saved_item.dart';
import 'package:hafez_poems/screens/poem_screen.dart';

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
                hiveKey: item.key,
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
                      _FalDialog(
                        title: item.title,
                        poemText: poemText,
                        tabirText: tabirText,
                        falNumber: isValid ? falNumber : '',
                      ),
                    );
                    return;
                  }
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
              child: Text('هنوز هیچ مصرعی را هایلایت نکرده‌اید.'),
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

class _FalDialog extends StatefulWidget {
  final String title;
  final String poemText;
  final String tabirText;
  final String falNumber; // ← اضافه
  const _FalDialog({
    required this.title,
    required this.poemText,
    required this.tabirText,
    required this.falNumber, // ← اضافه
  });

  @override
  State<_FalDialog> createState() => _FalDialogState();
}

class _FalDialogState extends State<_FalDialog> {
  late final ScrollController _scrollController;
  bool _showScrollHint = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_scrollController.position.maxScrollExtent > 0) {
        setState(() => _showScrollHint = true);
      }
      _scrollController.addListener(() {
        if (!mounted) return;
        final atBottom =
            _scrollController.offset >=
            _scrollController.position.maxScrollExtent - 16;
        setState(() => _showScrollHint = !atBottom);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(24),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header ──
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(
                        context,
                      ).dividerColor.withValues(alpha: 0.4),
                    ),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // غزل و شماره — وسط
                    if (widget.falNumber.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'غزل ${widget.falNumber}'.toPersianNumbers(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    // فال حافظ — گوشه راست
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'فال حافظ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1FA855),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Scrollable body + fade ──
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            widget.poemText,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(height: 2.2, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          if (widget.tabirText.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Icon(
                                  Icons.auto_awesome_rounded,
                                  size: 14,
                                  color: Color(0xFFA0783A),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'تفسیر',
                                  style: Theme.of(context).textTheme.labelMedium
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Divider(
                                    height: 1,
                                    color: Theme.of(
                                      context,
                                    ).dividerColor.withValues(alpha: 0.35),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.15),
                                ),
                              ),
                              child: Text(
                                widget.tabirText,
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.9,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ],
                      ),
                    ),

                    // ── fade + arrow ──
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: AnimatedOpacity(
                        opacity: _showScrollHint ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 250),
                        child: IgnorePointer(
                          child: Container(
                            height: 64,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Theme.of(context).scaffoldBackgroundColor
                                      .withValues(alpha: 0.0),
                                  Theme.of(context).scaffoldBackgroundColor
                                      .withValues(alpha: 0.95),
                                ],
                              ),
                            ),
                            alignment: Alignment.bottomCenter,
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.7),
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Footer ──
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(
                        context,
                      ).dividerColor.withValues(alpha: 0.4),
                    ),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: TextButton(
                    onPressed: Get.back,
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('بستن'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
