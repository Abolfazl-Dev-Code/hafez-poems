import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hafez_poems/models/search_result.dart';
import 'package:hafez_poems/screens/poem_screen.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/services/poem_cache_services.dart';
import 'package:hafez_poems/services/poem_local_services.dart';

String normalize(String text) {
  return text
      .replaceAll('\u064a', '\u06cc')
      .replaceAll('\u0643', '\u06a9')
      .replaceAll('\u200c', ' ')
      .replaceAll('\n', ' ')
      .replaceAll('\r', ' ')
      .replaceAll('\t', ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim()
      .toLowerCase();
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final GhazalCacheService _ghazalCache = Get.find<GhazalCacheService>();
  final GhataatCacheService _ghataatCache = Get.find<GhataatCacheService>();
  final GhasayedCacheService _ghasayedCache = Get.find<GhasayedCacheService>();
  final RobaeyatCacheService _robaeyatCache = Get.find<RobaeyatCacheService>();
  final MontasabCacheService _montasabCache = Get.find<MontasabCacheService>();

  List<SearchResult> _searchResults = [];
  Timer? _debounce;
  bool _isIndexing = false;
  double _loadingProgress = 0;
  int _cachedCount = 0;
  Worker? _indexingWorker;
  Worker? _progressWorker;
  Worker? _countWorker;
  SearchResultType? _selectedType;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
    _searchController.addListener(_onSearchChanged);

    _isIndexing = _ghazalCache.isIndexing.value;
    _loadingProgress = _ghazalCache.loadingProgress.value;
    _cachedCount = _totalCachedCount;

    _indexingWorker = ever(_ghazalCache.isIndexing, (val) {
      if (mounted) setState(() => _isIndexing = val);
    });
    _progressWorker = ever(_ghazalCache.loadingProgress, (val) {
      if (mounted) setState(() => _loadingProgress = val);
    });
    _countWorker = ever(_ghazalCache.cachedGhazalsRx, (_) {
      if (mounted) setState(() => _cachedCount = _totalCachedCount);
    });
  }

  int get _totalCachedCount =>
      _ghazalCache.cachedCount +
      _ghataatCache.cachedCount +
      _ghasayedCache.cachedCount +
      _robaeyatCache.cachedCount +
      _montasabCache.cachedCount;

  @override
  void dispose() {
    _debounce?.cancel();
    _indexingWorker?.dispose();
    _progressWorker?.dispose();
    _countWorker?.dispose();
    _searchController.removeListener(_onSearchChanged);
    _animController.dispose();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), _performSearch);
  }

  void _performSearch() {
    final query = normalize(_searchController.text);
    if (query.trim().isEmpty) {
      if (mounted) setState(() => _searchResults = []);
      return;
    }

    final results = <SearchResult>[];
    results.addAll(
      _ghazalCache
          .search(query)
          .map(
            (g) => SearchResult(
              id: g.id,
              title: g.title,
              text: g.text,
              audioUrl: g.audioUrl, // ← اگه خالیه مشکل از اینجاست
              type: SearchResultType.ghazal,
            ),
          ),
    );

    results.addAll(
      _ghataatCache
          .search(query)
          .map(
            (g) => SearchResult(
              id: g.id,
              title: g.title,
              text: g.text,
              audioUrl: '',
              type: SearchResultType.ghataat,
            ),
          ),
    );

    results.addAll(
      _ghasayedCache
          .search(query)
          .map(
            (g) => SearchResult(
              id: g.id,
              title: g.title,
              text: g.text,
              audioUrl: '',
              type: SearchResultType.qasaid,
            ),
          ),
    );

    results.addAll(
      _robaeyatCache
          .search(query)
          .map(
            (g) => SearchResult(
              id: g.id,
              title: g.title,
              text: g.text,
              audioUrl: '',
              type: SearchResultType.robaeyat,
            ),
          ),
    );

    results.addAll(
      _montasabCache
          .search(query)
          .map(
            (g) => SearchResult(
              id: g.id,
              title: g.title,
              text: g.text,
              audioUrl: '',
              type: SearchResultType.montasab,
            ),
          ),
    );
    final filtered = _selectedType == null
        ? results
        : results.where((r) => r.type == _selectedType).toList();

    if (mounted) setState(() => _searchResults = filtered);
  }

  void _onTapResult(SearchResult item) {
    _focusNode.unfocus();

    Future<String> Function(String) fetchText;
    Future<String> Function(String)? fetchAudioUrl;

    switch (item.type) {
      case SearchResultType.ghazal:
        fetchText = (id) =>
            GhazalLocalService.instance.fetchGhazalById(id).then((g) => g.text);
        fetchAudioUrl = (id) => _ghazalCache.getAudioUrl(id);
        break;
      case SearchResultType.ghataat:
        fetchText = (id) => GhataatLocalService.instance
            .fetchGhataatById(id)
            .then((g) => g.text);
        fetchAudioUrl = (id) => _ghataatCache.getAudioUrl(id);
        break;
      case SearchResultType.qasaid:
        fetchText = (id) =>
            _ghasayedCache.getGhasayedDetail(id).then((g) => g.text);
        fetchAudioUrl = (id) => _ghasayedCache.getAudioUrl(id);
        break;
      case SearchResultType.robaeyat:
        fetchText = (id) =>
            _robaeyatCache.getRobaeyatDetail(id).then((g) => g.text);
        fetchAudioUrl = (id) => _robaeyatCache.getAudioUrl(id);
        break;
      case SearchResultType.montasab:
        fetchText = (id) =>
            _montasabCache.getMontasabDetail(id).then((g) => g.text);
        fetchAudioUrl = (id) => _montasabCache.getAudioUrl(id);
        break;
    }

    Get.to(
      () => PoemScreen(
        args: PoemScreenArgs(
          id: item.id,
          title: item.title,
          text: item.text,
          audioUrl: item.audioUrl,
          fetchText: fetchText,
          fetchAudioUrl: fetchAudioUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;
    final textColor = isLight ? Colors.black : colorScheme.onSurface;

    return SlideTransition(
      position: _slideAnimation,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'جستجوی اشعار',
              style: textTheme.headlineMedium?.copyWith(color: textColor),
            ),
            leading: IconButton(
              onPressed: Get.back,
              icon: Icon(Icons.arrow_back_rounded, color: textColor),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  autofocus: true,
                  style: textTheme.bodyLarge?.copyWith(color: textColor),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'جستجو در تمام اشعار...',
                    hintStyle: textTheme.bodyMedium?.copyWith(
                      color: isLight
                          ? Colors.black45
                          : colorScheme.onSurfaceVariant,
                    ),
                    prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                    suffixIcon: _isIndexing
                        ? Padding(
                            padding: const EdgeInsets.all(12),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                value: _loadingProgress == 0
                                    ? null
                                    : _loadingProgress,
                                color: colorScheme.primary.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
                if (_isIndexing) ...[
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _loadingProgress == 0 ? null : _loadingProgress,
                      minHeight: 3,
                      backgroundColor: colorScheme.primary.withValues(
                        alpha: 0.12,
                      ),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.primary.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '$_cachedCount شعر آماده'
                      '${_loadingProgress > 0 ? " — ${(_loadingProgress * 100).toInt()}٪" : ""}',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.45),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 8),
                if (_searchController.text.isNotEmpty) ...[
                  _buildTypeFilter(colorScheme),
                  const SizedBox(height: 8),
                ],
                Expanded(
                  child: _buildResults(
                    context,
                    theme: theme,
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                    textColor: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeFilter(ColorScheme colorScheme) {
    final types = [
      (null, 'همه'),
      (SearchResultType.ghazal, 'غزل'),
      (SearchResultType.ghataat, 'قطعه'),
      (SearchResultType.qasaid, 'قصیده'),
      (SearchResultType.robaeyat, 'رباعی'),
      (SearchResultType.montasab, 'منتسب'),
    ];

    return SizedBox(
      height: 34,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: types.map((t) {
          final isSelected = _selectedType == t.$1;
          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedType = t.$1);
                _performSearch();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outline.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  t.$2,
                  style: TextStyle(
                    fontSize: 13,
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildResults(
    BuildContext context, {
    required ThemeData theme,
    required TextTheme textTheme,
    required ColorScheme colorScheme,
    required Color textColor,
  }) {
    if (_searchController.text.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_rounded,
              size: 52,
              color: colorScheme.onSurface.withValues(alpha: 0.18),
            ),
            const SizedBox(height: 12),
            Text(
              'جستجوی خود را شروع کنید',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
            if (_cachedCount > 0) ...[
              const SizedBox(height: 6),
              Text(
                '$_cachedCount شعر در دسترس',
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.28),
                ),
              ),
            ],
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.find_in_page_rounded,
              size: 52,
              color: colorScheme.onSurface.withValues(alpha: 0.18),
            ),
            const SizedBox(height: 12),
            Text(
              'نتیجه‌ای یافت نشد',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            if (_isIndexing) ...[
              const SizedBox(height: 8),
              Text(
                'ممکن است اشعار بیشتری در حال دریافت باشند',
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: _searchResults.length,
      separatorBuilder: (_, _) => Divider(color: theme.dividerColor, height: 1),
      itemBuilder: (context, index) {
        final item = _searchResults[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                margin: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.typeLabel,
                  style: TextStyle(
                    fontSize: 11,
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: _buildHighlightedText(
                  item.title,
                  _searchController.text,
                  textTheme.titleMedium?.copyWith(color: textColor),
                  colorScheme,
                ),
              ),
            ],
          ),
          subtitle: item.text.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: _buildHighlightedText(
                    item.text,
                    _searchController.text,
                    textTheme.bodyMedium?.copyWith(
                      color: textColor.withValues(alpha: 0.75),
                    ),
                    colorScheme,
                  ),
                )
              : null,
          trailing: Icon(
            Icons.chevron_left_rounded,
            color: colorScheme.primary,
          ),
          onTap: () => _onTapResult(item),
        );
      },
    );
  }

  Widget _buildHighlightedText(
    String text,
    String rawQuery,
    TextStyle? style,
    ColorScheme colorScheme,
  ) {
    if (rawQuery.isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    final normalizedQuery = normalize(rawQuery);
    final lines = text.split('\n');
    final foundLine = lines.firstWhere(
      (line) => normalize(line).contains(normalizedQuery),
      orElse: () => lines.first,
    );

    final normalizedLine = normalize(foundLine);
    final start = normalizedLine.indexOf(normalizedQuery);

    if (start == -1 ||
        start >= foundLine.length ||
        start + normalizedQuery.length > foundLine.length) {
      return Text(
        foundLine,
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    final end = start + normalizedQuery.length;

    return Text.rich(
      TextSpan(
        style: style,
        children: [
          TextSpan(text: foundLine.substring(0, start)),
          TextSpan(
            text: foundLine.substring(start, end),
            style: style?.copyWith(
              backgroundColor: colorScheme.secondary.withValues(alpha: 0.32),
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: foundLine.substring(end)),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
