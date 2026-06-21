import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/models/base_poem_model.dart';
import 'package:hafez_poems/models/poem_list_config.dart';
import 'package:hafez_poems/screens/poem_screen.dart';
import 'package:hafez_poems/widgets/poem_list_empty.dart';
import 'package:hafez_poems/widgets/poem_list_loading.dart';
import 'package:hafez_poems/widgets/poem_list_title.dart';

class PoemListSheet extends StatefulWidget {
  final PoemListConfig config;

  const PoemListSheet({super.key, required this.config});

  @override
  State<PoemListSheet> createState() => _PoemListSheetState();
}

class _PoemListSheetState extends State<PoemListSheet> {
  final Set<String> _prefetching = {};

  PoemListConfig get _cfg => widget.config;

  List<BasePoem> get _items => _cfg.items.cast<BasePoem>();

  void _maybePrefetch(int currentIndex) {
    const ahead = 5;

    final items = _items;

    final end = (currentIndex + ahead + 1).clamp(0, items.length);

    for (int i = currentIndex + 1; i < end; i++) {
      final next = items[i];

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
            title: displayTitle,
            text: baseArgs.text,
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
    final colorScheme = theme.colorScheme;
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
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    IconButton(
                      onPressed: Get.back,
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: colorScheme.onSurface,
                      ),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      _cfg.headerTitle,
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const Spacer(),

                    Obx(() {
                      final indexing = _cfg.isIndexing.value;
                      final progress = _cfg.loadingProgress.value;

                      if (!indexing) return const SizedBox.shrink();

                      return Row(
                        children: [
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              value: progress == 0 ? null : progress,
                              color: colorScheme.primary,
                            ),
                          ),

                          const SizedBox(width: 6),

                          Text(
                            '${(progress * 100).toInt()}٪',
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),

                const SizedBox(height: 8),

                Expanded(
                  child: Obx(() {
                    final items = _items;
                    final indexing = _cfg.isIndexing.value;

                    if (items.isEmpty) {
                      return indexing
                          ? PoemListLoading(text: _cfg.loadingText)
                          : PoemListEmpty(
                              text: _cfg.emptyText,
                              onRetry: _cfg.onRetry,
                            );
                    }

                    return ListView.builder(
                      cacheExtent: 69 * 5,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];

                        _maybePrefetch(index);

                        final tileTitle = _cfg.tilePrefix != null
                            ? '${_cfg.tilePrefix} ${index + 1}'
                            : item.title;

                        return Column(
                          children: [
                            PoemListTitle(
                              title: tileTitle,
                              hasFullText: item.hasFullText,
                              onTap: () => _navigate(
                                item,
                                tileTitle,
                              ), // ← پاس دادن tileTitle
                            ),
                            if (index < items.length - 1)
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: theme.dividerColor.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                          ],
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
