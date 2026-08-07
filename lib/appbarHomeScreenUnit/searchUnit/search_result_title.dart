import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/searchUnit/search_result_category_mapper.dart';
import 'package:hafez_poems/models/search_result.dart';
import 'package:hafez_poems/poemsUnit/poems/poemScreenCacheService/poem_cache_services.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_screen.dart';

class SearchResultTitle extends StatelessWidget {
  final SearchResult item;
  final String query;
  const SearchResultTitle({super.key, required this.item, required this.query});

  List<TextSpan> _highlight(
    String text,
    String query,
    TextStyle? base,
    Color highlightColor,
  ) {
    if (query.isEmpty) return [TextSpan(text: text, style: base)];

    final spans = <TextSpan>[];
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    int start = 0;

    while (true) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index == -1) {
        spans.add(TextSpan(text: text.substring(start), style: base));
        break;
      }
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index), style: base));
      }
      spans.add(
        TextSpan(
          text: text.substring(index, index + query.length),
          style: base?.copyWith(
            color: highlightColor,
            fontWeight: FontWeight.w900,
            backgroundColor: highlightColor.withValues(alpha: 0.15),
          ),
        ),
      );
      start = index + query.length;
    }
    return spans;
  }

  String _findMatchingLine(String text, String query) {
    if (query.isEmpty) return '';
    final lines = text
        .split('\n')
        .expand((l) => l.contains(' / ') ? l.split(' / ') : [l])
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    final lowerQuery = query.toLowerCase();
    return lines.firstWhere(
      (l) => l.toLowerCase().contains(lowerQuery),
      orElse: () => lines.isNotEmpty ? lines.first : '',
    );
  }

  Future<String> Function(String id) _fetchAudioUrlFor(SearchResultType type) {
    switch (type) {
      case SearchResultType.ghazal:
        return (id) => Get.find<GhazalCacheService>().getAudioUrl(id);
      case SearchResultType.ghataat:
        return (id) => Get.find<GhataatCacheService>().getAudioUrl(id);
      case SearchResultType.qasaid:
        return (id) => Get.find<GhasayedCacheService>().getAudioUrl(id);
      case SearchResultType.robaeyat:
        return (id) => Get.find<RobaeyatCacheService>().getAudioUrl(id);
      case SearchResultType.montasab:
        return (id) => Get.find<MontasabCacheService>().getAudioUrl(id);
      case SearchResultType.other:
        return (id) => Get.find<OtherPoemCacheService>().getAudioUrl(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      elevation: theme.brightness == Brightness.dark ? 0 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lgRadius,
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.3)),
      ),
      child: InkWell(
        borderRadius: AppRadius.lgRadius,
        onTap: () {
          Get.to(
            () => PoemScreen(
              args: PoemScreenArgs(
                id: item.id,
                category: poemCategoryFor(item.type),
                title: item.title,
                text: item.text,
                audioUrl: item.audioUrl,
                fetchText: (_) async => item.text,
                fetchAudioUrl: _fetchAudioUrlFor(item.type),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (item.text.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: _highlight(
                            _findMatchingLine(item.text, query),
                            query,
                            theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_left_rounded, color: colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}
