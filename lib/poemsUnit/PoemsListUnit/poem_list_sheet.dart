import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_lucide_animated/flutter_lucide_animated.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/poemsUnit/poems/persian_numbers.dart';
import 'package:hafez_poems/poemsUnit/PoemsListUnit/poem_list_empty.dart';
import 'package:hafez_poems/poemsUnit/PoemsListUnit/poem_list_loading.dart';
import 'package:hafez_poems/poemsUnit/PoemsListUnit/poem_list_title.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_screen.dart';
import 'package:hafez_poems/models/base_poem_model.dart';
import 'package:hafez_poems/models/poem_list_config.dart';
import 'package:hafez_poems/core/data/contracts/i_read_status_storage.dart';

enum _ReadFilter { all, read, unread }

extension _ReadFilterLabel on _ReadFilter {
  String get label => switch (this) {
    _ReadFilter.all => 'همه',
    _ReadFilter.read => 'خوانده‌شده',
    _ReadFilter.unread => 'خوانده‌نشده',
  };

  IconData get icon => switch (this) {
    _ReadFilter.all => Icons.format_list_bulleted_rounded,
    _ReadFilter.read => Icons.radio_button_unchecked_rounded,
    _ReadFilter.unread => Icons.radio_button_unchecked_rounded,
  };

  IconData get activeIcon => switch (this) {
    _ReadFilter.all => Icons.format_list_bulleted_rounded,
    _ReadFilter.read => Icons.check_circle_rounded,
    _ReadFilter.unread => Icons.check_circle_rounded,
  };
}

class PoemListSheet extends StatefulWidget {
  final PoemListConfig config;

  const PoemListSheet({super.key, required this.config});

  @override
  State<PoemListSheet> createState() => _PoemListSheetState();
}

class _PoemListSheetState extends State<PoemListSheet> {
  final Set<String> _prefetching = {};
  final Set<String> _animatedIds = {};
  final ScrollController _scrollController = ScrollController();
  _ReadFilter _filter = _ReadFilter.all;
  int _visibleCount = 30;
  late final IReadStatusStorage _readStatus = Get.find<IReadStatusStorage>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (_scrollController.position.pixels <
        _scrollController.position.maxScrollExtent - 400) {
      return;
    }
    final entries = _visibleEntries;
    if (_visibleCount >= entries.length) return;
    setState(() {
      _visibleCount = (_visibleCount + 30).clamp(0, entries.length);
    });
  }

  PoemListConfig get _cfg => widget.config;
  List<BasePoem> get _items => _cfg.items.cast<BasePoem>();
  bool _isRead(String id) => _readStatus.isRead(id);

  List<MapEntry<int, BasePoem>> get _visibleEntries {
    final items = _items;
    final entries = <MapEntry<int, BasePoem>>[
      for (var i = 0; i < items.length; i++) MapEntry(i, items[i]),
    ];
    return switch (_filter) {
      _ReadFilter.all => entries,
      _ReadFilter.read =>
        entries.where((e) => _isRead(e.value.id)).toList(growable: false),
      _ReadFilter.unread =>
        entries.where((e) => !_isRead(e.value.id)).toList(growable: false),
    };
  }

  void _maybePrefetch(List<MapEntry<int, BasePoem>> entries, int currentIndex) {
    const ahead = 5;
    final end = (currentIndex + ahead + 1).clamp(0, entries.length);
    for (int i = currentIndex + 1; i < end; i++) {
      final next = entries[i].value;
      if (!next.hasFullText && !_prefetching.contains(next.id)) {
        _prefetching.add(next.id);
        _cfg
            .prefetch(next.id)
            .then((_) => _prefetching.remove(next.id))
            .catchError((_) => _prefetching.remove(next.id));
      }
    }
  }

  void _navigate(BasePoem item, String displayTitle) {
    Get.back();
    final baseArgs = _cfg.buildArgs(item);
    final args = _cfg.tilePrefix != null
        ? PoemScreenArgs(
            id: baseArgs.id,
            category: baseArgs.category,
            title: displayTitle.toPersianNumbers(),
            text: baseArgs.text.toPersianNumbers(),
            audioUrl: baseArgs.audioUrl,
            fetchText: baseArgs.fetchText,
            fetchAudioUrl: baseArgs.fetchAudioUrl,
            highlightLineIndex: baseArgs.highlightLineIndex,
          )
        : baseArgs;
    Get.to(() => PoemScreen(args: args));
  }

  void _showFilterDropdown(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final currentFilter = _filter;

    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;

    final Offset buttonOffset = button.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );
    final Size buttonSize = button.size;
    final Size overlaySize = overlay.size;
    final RelativeRect position = RelativeRect.fromLTRB(
      buttonOffset.dx,
      buttonOffset.dy + buttonSize.height + 4,
      overlaySize.width - buttonOffset.dx - buttonSize.width,
      overlaySize.height - buttonOffset.dy - buttonSize.height,
    );

    showMenu<_ReadFilter>(
      context: context,
      position: position,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
      color: cs.surface,
      items: _ReadFilter.values.map((f) {
        final isActive = currentFilter == f;
        return PopupMenuItem<_ReadFilter>(
          value: f,
          padding: EdgeInsets.only(left: AppSpacing.md),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: 150,
            padding: const EdgeInsets.only(
              left: 10,
              right: 4,
              top: 10,
              bottom: 10,
            ),
            decoration: BoxDecoration(
              color: isActive
                  ? cs.primary.withValues(alpha: 0.08)
                  : Colors.transparent,
              borderRadius: AppRadius.smRadius,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  f.label,
                  textAlign: TextAlign.right,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isActive ? cs.primary : cs.onSurface,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  isActive ? f.activeIcon : f.icon,
                  size: 18,
                  color: isActive
                      ? cs.primary
                      : cs.onSurface.withValues(alpha: 0.55),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    ).then((selected) {
      if (selected != null && selected != _filter) {
        setState(() {
          _filter = selected;
          _visibleCount = 30;
        });
      }
    });
  }

  Widget _buildEmptyFiltered(ThemeData theme) {
    final cs = theme.colorScheme;
    final (icon, title, subtitle) = switch (_filter) {
      _ReadFilter.read => (
        Icons.menu_book_rounded,
        'هنوز شعری نخوانده‌اید',
        'اشعاری که باز کنید اینجا نمایش داده می‌شوند',
      ),
      _ReadFilter.unread => (
        Icons.task_alt_rounded,
        'همه‌ی موارد را خوانده‌اید',
        'تمام اشعار این بخش را مطالعه کرده‌اید',
      ),
      _ReadFilter.all => (Icons.library_books_outlined, 'موردی یافت نشد', ''),
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 44, color: cs.primary.withValues(alpha: 0.55)),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.85),
                fontWeight: FontWeight.w600,
              ),
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.45),
                ),
              ),
            ],
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => setState(() => _filter = _ReadFilter.all),
              child: const Text('نمایش همه'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              children: [
                // ── هندل ──
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: cs.onSurface.withValues(alpha: 0.25),
                    borderRadius: AppRadius.pillRadius,
                  ),
                ),

                const SizedBox(height: 12),

                // ── هدر ──
                Row(
                  children: [
                    SizedBox(width: 10),
                    LucideAnimatedIcon(
                      icon: arrow_right,
                      color: cs.onSurface,
                      size: 20,
                      onTap: Get.back,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        _cfg.headerTitle,
                        style: textTheme.titleMedium?.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Builder(
                      builder: (btnCtx) => InkWell(
                        onTap: () => _showFilterDropdown(btnCtx),
                        borderRadius: AppRadius.smRadius,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _filter != _ReadFilter.all
                                ? cs.primary.withValues(alpha: 0.1)
                                : Colors.transparent,
                            borderRadius: AppRadius.smRadius,
                            border: Border.all(
                              color: _filter != _ReadFilter.all
                                  ? cs.primary.withValues(alpha: 0.3)
                                  : cs.onSurface.withValues(alpha: 0.15),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.filter_list_rounded,
                                size: 16,
                                color: _filter != _ReadFilter.all
                                    ? cs.primary
                                    : cs.onSurface.withValues(alpha: 0.6),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                _filter.label,
                                style: textTheme.labelSmall?.copyWith(
                                  color: _filter != _ReadFilter.all
                                      ? cs.primary
                                      : cs.onSurface.withValues(alpha: 0.6),
                                  fontWeight: _filter != _ReadFilter.all
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              const SizedBox(width: 3),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 14,
                                color: _filter != _ReadFilter.all
                                    ? cs.primary
                                    : cs.onSurface.withValues(alpha: 0.45),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Obx(() {
                      final indexing = _cfg.isIndexing.value;
                      final progress = _cfg.loadingProgress.value;
                      if (!indexing) return const SizedBox.shrink();
                      return Row(
                        children: [
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              value: progress == 0 ? null : progress,
                              color: cs.primary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${(progress * 100).toInt()}٪',
                            style: textTheme.labelSmall?.copyWith(
                              color: cs.primary,
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),

                const SizedBox(height: 8),

                // ── لیست ──
                Expanded(
                  child: Obx(() {
                    final entries = _visibleEntries;
                    final indexing = _cfg.isIndexing.value;

                    if (entries.isEmpty) {
                      if (indexing) {
                        return PoemListLoading(text: _cfg.loadingText);
                      }
                      if (_filter != _ReadFilter.all && _items.isNotEmpty) {
                        return _buildEmptyFiltered(theme);
                      }
                      return PoemListEmpty(
                        text: _cfg.emptyText,
                        onRetry: _cfg.onRetry,
                      );
                    }

                    final visibleCount = _visibleCount.clamp(0, entries.length);

                    return ListView.builder(
                      controller: _scrollController,
                      scrollCacheExtent: ScrollCacheExtent.pixels(69 * 5),
                      itemCount: visibleCount,
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        final item = entry.value;
                        final read = _isRead(item.id);

                        _maybePrefetch(entries, index);

                        final tileTitle = _cfg.tilePrefix != null
                            ? '${_cfg.tilePrefix} ${entry.key + 1}'
                            : item.title;

                        final tile = PoemListTitle(
                          title: tileTitle.toPersianNumbers(),
                          hasFullText: item.hasFullText,
                          isRead: read,
                          onTap: () => _navigate(item, tileTitle),
                        );

                        if (_animatedIds.contains(item.id)) return tile;
                        _animatedIds.add(item.id);

                        return TweenAnimationBuilder<double>(
                          key: ValueKey(item.id),
                          tween: Tween(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 320),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, (1 - value) * 16),
                                child: child,
                              ),
                            );
                          },
                          child: tile,
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
