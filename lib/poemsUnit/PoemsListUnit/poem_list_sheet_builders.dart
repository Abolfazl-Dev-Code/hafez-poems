part of 'poem_list_sheet.dart';

extension _PoemListSheetBuilders on _PoemListSheetState {
  Widget _buildHeader(ThemeData theme, ColorScheme cs, TextTheme textTheme) {
    return Row(
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                style: textTheme.labelSmall?.copyWith(color: cs.primary),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildList(ThemeData theme) {
    return Obx(() {
      final entries = _visibleEntries;
      final indexing = _cfg.isIndexing.value;

      if (entries.isEmpty) {
        if (indexing) {
          return PoemListLoading(text: _cfg.loadingText);
        }
        if (_filter != _ReadFilter.all && _items.isNotEmpty) {
          return _buildEmptyFiltered(theme);
        }
        return PoemListEmpty(text: _cfg.emptyText, onRetry: _cfg.onRetry);
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
    });
  }
}
