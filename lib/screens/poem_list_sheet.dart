import 'package:flutter/material.dart';
import 'package:hafez_poems/models/base_poem_model.dart';
import 'package:hafez_poems/screens/poem_screen.dart';
import 'package:get/get.dart';

class PoemListConfig {
  final String headerTitle;
  final String loadingText;
  final String emptyText;
  final String? tilePrefix;
  final RxList items;
  final RxBool isIndexing;
  final RxDouble loadingProgress;
  final Future<void> Function(String id) prefetch;
  final PoemScreenArgs Function(BasePoem item) buildArgs;
  final VoidCallback onRetry;

  const PoemListConfig({
    required this.headerTitle,
    required this.loadingText,
    required this.emptyText,
    required this.items,
    required this.isIndexing,
    required this.loadingProgress,
    required this.prefetch,
    required this.buildArgs,
    required this.onRetry,
    this.tilePrefix,
  });
}

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

  void _navigate(BasePoem item) {
    Get.back();
    Get.to(() => PoemScreen(args: _cfg.buildArgs(item)));
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
                        mainAxisSize: MainAxisSize.min,
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
                          ? _buildLoading(colorScheme, textTheme)
                          : _buildEmpty(colorScheme, textTheme);
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _PoemListTile(
                              title: tileTitle,
                              hasFullText: item.hasFullText,
                              onTap: () => _navigate(item),
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

  Widget _buildLoading(ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            _cfg.loadingText,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 48,
            color: colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 12),
          Text(
            _cfg.emptyText,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: _cfg.onRetry,
            child: const Text('تلاش مجدد'),
          ),
        ],
      ),
    );
  }
}

class _PoemListTile extends StatelessWidget {
  const _PoemListTile({
    required this.title,
    required this.hasFullText,
    required this.onTap,
  });

  final String title;
  final bool hasFullText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.book_rounded, color: colorScheme.primary, size: 22),
      ),
      title: Text(
        title,
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: hasFullText
          ? null
          : Text(
              'در حال دریافت...',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.35),
              ),
            ),
      trailing: Icon(
        Icons.chevron_left_rounded,
        color: colorScheme.onSurface.withValues(alpha: 0.45),
      ),
      onTap: onTap,
    );
  }
}
