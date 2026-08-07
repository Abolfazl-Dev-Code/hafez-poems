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

part 'poem_list_read_filter.dart';
part 'poem_list_filter_ui.dart';
part 'poem_list_sheet_builders.dart';

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

  void _applyFilter(_ReadFilter filter) {
    setState(() {
      _filter = filter;
      _visibleCount = 30;
    });
  }

  void _resetFilterToAll() {
    setState(() => _filter = _ReadFilter.all);
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
                _buildHeader(theme, cs, textTheme),

                const SizedBox(height: 8),

                // ── لیست ──
                Expanded(child: _buildList(theme)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
