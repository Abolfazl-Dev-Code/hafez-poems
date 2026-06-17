import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hafez_poems/screens/poem_list_sheet.dart';
import 'package:hafez_poems/screens/poem_screen.dart';
import 'package:hafez_poems/services/poem_cache_services.dart';
import 'package:hafez_poems/services/poem_local_services.dart';
import 'package:hafez_poems/widgets/custom_appbar.dart';
import 'package:hafez_poems/screens/fal_screen.dart';
import 'package:get/get.dart';
import '../widgets/square_box.dart';
import 'carousel_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final GhazalCacheService _cache = Get.find<GhazalCacheService>();
  Worker? _textsReadyWorker;
  Worker? _indexingWorker;

  List<String> _allTexts = [];
  List<String> _carouselTexts = [];
  bool _isLoadingCarousel = true;

  @override
  void initState() {
    super.initState();
    _initCarousel();
  }

  void _initCarousel() {
    if (_trySetCarouselTexts()) return;
    _textsReadyWorker = ever(_cache.textsReadyCount, (count) {
      if (count >= 5 && _carouselTexts.isEmpty && mounted) {
        _trySetCarouselTexts();
      }
    });

    _indexingWorker = ever(_cache.isIndexing, (indexing) {
      if (!indexing && mounted) {
        if (_carouselTexts.isEmpty) _trySetCarouselTexts();
        if (mounted) setState(() => _isLoadingCarousel = false);
      }
    });
  }

  bool _trySetCarouselTexts() {
    final excerpts = _cache.randomExcerpts(count: 10);
    if (excerpts.isEmpty) return false;

    if (mounted) {
      setState(() {
        _allTexts = excerpts;
        _carouselTexts = excerpts.take(5).toList();
        _isLoadingCarousel = false;
      });
    }
    return true;
  }

  void _refreshSlide(int index) {
    if (_allTexts.length <= 1 || index >= _carouselTexts.length) return;

    String newText;
    do {
      newText = _allTexts[Random().nextInt(_allTexts.length)];
    } while (newText == _carouselTexts[index] && _allTexts.length > 1);

    setState(() => _carouselTexts[index] = newText);
  }

  @override
  void dispose() {
    _textsReadyWorker?.dispose();
    _indexingWorker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    const CustomAppBar(title: "اشعار حافظ"),
                    const SizedBox(height: 20),
                    if (_isLoadingCarousel && _carouselTexts.isEmpty)
                      _buildSkeleton(theme)
                    else if (_carouselTexts.isEmpty)
                      const SizedBox(height: 180)
                    else
                      CarouselSlider.builder(
                        carouselController: _carouselController,
                        options: CarouselOptions(
                          height: 200,
                          viewportFraction: 0.9,
                          enableInfiniteScroll: false,
                        ),
                        itemCount: 1,
                        itemBuilder: (context, index, _) => GhazalDisplayWidget(
                          key: ValueKey(_carouselTexts[index]),
                          initialGhazal: _carouselTexts[index],
                          imagePath: 'assets/icon/hafez.png',
                          changeButtonIcon: 'rotate',
                          onChangeGhazal: () => _refreshSlide(index),
                        ),
                      ),

                    const SizedBox(height: 40),

                    _buildActionRow([
                      {
                        "icon": Image.asset(
                          "assets/icon/ghazaliat.png",
                          width: 61,
                          height: 61,
                        ),
                        "title": "غزلیات",
                        "onTap": () => _showSheet(
                          PoemListSheet(
                            config: PoemListConfig(
                              headerTitle: 'لیست غزل‌ها',
                              loadingText: 'در حال دریافت غزل‌ها...',
                              emptyText: 'هیچ غزلی یافت نشد',
                              items: Get.find<GhazalCacheService>()
                                  .cachedGhazalsRx,
                              isIndexing:
                                  Get.find<GhazalCacheService>().isIndexing,
                              loadingProgress: Get.find<GhazalCacheService>()
                                  .loadingProgress,
                              prefetch: (id) => Get.find<GhazalCacheService>()
                                  .getGhazalDetail(id)
                                  .then((_) {}),
                              onRetry: Get.find<GhazalCacheService>().preload,
                              buildArgs: (item) => PoemScreenArgs(
                                id: item.id,
                                title: item.title,
                                text: item.hasFullText ? item.text : '',
                                audioUrl: item.audioUrl,
                                fetchText: (id) => GhazalLocalService.instance
                                    .fetchGhazalById(id)
                                    .then((g) => g.text),
                                fetchAudioUrl: (id) =>
                                    Get.find<GhazalCacheService>().getAudioUrl(
                                      id,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      },
                      {
                        "icon": Image.asset(
                          "assets/icon/divan.png",
                          width: 55,
                          height: 55,
                        ),
                        "title": "قطعات",
                        "onTap": () => _showSheet(
                          PoemListSheet(
                            config: PoemListConfig(
                              headerTitle: 'قطعات حافظ',
                              loadingText: 'در حال دریافت قطعات...',
                              emptyText: 'هیچ قطعه‌ای یافت نشد',
                              tilePrefix: 'قطعه شماره',
                              items: Get.find<GhataatCacheService>()
                                  .cachedGhataatRx,
                              isIndexing:
                                  Get.find<GhataatCacheService>().isIndexing,
                              loadingProgress: Get.find<GhataatCacheService>()
                                  .loadingProgress,
                              prefetch: (id) => Get.find<GhataatCacheService>()
                                  .getGhataatDetail(id)
                                  .then((_) {}),
                              onRetry: Get.find<GhataatCacheService>().preload,
                              buildArgs: (item) => PoemScreenArgs(
                                id: item.id,
                                title: item.title,
                                text: item.hasFullText ? item.text : '',
                                fetchText: (id) => GhataatLocalService.instance
                                    .fetchGhataatById(id)
                                    .then((d) => d.text),
                                fetchAudioUrl: (id) =>
                                    Get.find<GhataatCacheService>().getAudioUrl(
                                      id,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      },
                      {
                        "icon": Image.asset(
                          "assets/icon/faal.png",
                          width: 60,
                          height: 60,
                        ),
                        "title": "فال",
                        "onTap": () => _showSheet(FalScreen()),
                      },
                    ]),

                    const SizedBox(height: 20),

                    _buildActionRow([
                      {
                        "icon": Image.asset(
                          "assets/icon/ghasayed.png",
                          width: 53,
                          height: 53,
                        ),
                        "title": "قصاید",
                        "onTap": () => _showSheet(
                          PoemListSheet(
                            config: PoemListConfig(
                              headerTitle: 'قصاید حافظ',
                              loadingText: 'در حال دریافت قصاید...',
                              emptyText: 'هیچ قصیده‌ای یافت نشد',
                              tilePrefix: 'قصیده شماره',
                              items: Get.find<GhasayedCacheService>()
                                  .cachedQasaidRx,
                              isIndexing:
                                  Get.find<GhasayedCacheService>().isIndexing,
                              loadingProgress: Get.find<GhasayedCacheService>()
                                  .loadingProgress,
                              prefetch: (id) => Get.find<GhasayedCacheService>()
                                  .getQasaidDetail(id)
                                  .then((_) {}),
                              onRetry: Get.find<GhasayedCacheService>().preload,
                              buildArgs: (item) => PoemScreenArgs(
                                id: item.id,
                                title: item.title,
                                text: item.hasFullText ? item.text : '',
                                fetchText: (id) =>
                                    Get.find<GhasayedCacheService>()
                                        .getGhasayedDetail(id)
                                        .then((d) => d.text),
                                fetchAudioUrl: (id) =>
                                    Get.find<GhasayedCacheService>()
                                        .getAudioUrl(id),
                              ),
                            ),
                          ),
                        ),
                      },
                      {
                        "icon": Image.asset(
                          "assets/icon/robaeiyat.png",
                          width: 64,
                          height: 64,
                        ),
                        "title": "رباعیات",
                        "onTap": () => _showSheet(
                          PoemListSheet(
                            config: PoemListConfig(
                              headerTitle: 'رباعیات حافظ',
                              loadingText: 'در حال دریافت رباعیات...',
                              emptyText: 'هیچ رباعی‌ای یافت نشد',
                              tilePrefix: 'رباعی شماره',
                              items: Get.find<RobaeyatCacheService>()
                                  .cachedRobaeyatRx,
                              isIndexing:
                                  Get.find<RobaeyatCacheService>().isIndexing,
                              loadingProgress: Get.find<RobaeyatCacheService>()
                                  .loadingProgress,
                              prefetch: (id) => Get.find<RobaeyatCacheService>()
                                  .getRobaeyatDetail(id)
                                  .then((_) {}),
                              onRetry: Get.find<RobaeyatCacheService>().preload,
                              buildArgs: (item) => PoemScreenArgs(
                                id: item.id,
                                title: item.title,
                                text: item.hasFullText ? item.text : '',
                                fetchText: (id) =>
                                    Get.find<RobaeyatCacheService>()
                                        .getRobaeyatDetail(id)
                                        .then((d) => d.text),
                                fetchAudioUrl: (id) =>
                                    Get.find<RobaeyatCacheService>()
                                        .getAudioUrl(id),
                              ),
                            ),
                          ),
                        ),
                      },
                      {
                        "icon": Image.asset(
                          "assets/icon/taabir.png",
                          width: 61,
                          height: 61,
                        ),
                        "title": "اشعار منتسب",
                        "onTap": () => _showSheet(
                          PoemListSheet(
                            config: PoemListConfig(
                              headerTitle: 'اشعار منتسب حافظ',
                              loadingText: 'در حال دریافت اشعار منتسب...',
                              emptyText: 'هیچ شعری یافت نشد',
                              tilePrefix: 'شماره',
                              items: Get.find<MontasabCacheService>()
                                  .cachedMontasabRx,
                              isIndexing:
                                  Get.find<MontasabCacheService>().isIndexing,
                              loadingProgress: Get.find<MontasabCacheService>()
                                  .loadingProgress,
                              prefetch: (id) => Get.find<MontasabCacheService>()
                                  .getMontasabDetail(id)
                                  .then((_) {}),
                              onRetry: Get.find<MontasabCacheService>().preload,
                              buildArgs: (item) => PoemScreenArgs(
                                id: item.id,
                                title: item.title,
                                text: item.hasFullText ? item.text : '',
                                fetchText: (id) =>
                                    Get.find<MontasabCacheService>()
                                        .getMontasabDetail(id)
                                        .then((d) => d.text),
                                fetchAudioUrl: (id) =>
                                    Get.find<MontasabCacheService>()
                                        .getAudioUrl(id),
                              ),
                            ),
                          ),
                        ),
                      },
                    ]),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeleton(ThemeData theme) {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.2)),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => SizedBox(
                width: 180,
                child: LinearProgressIndicator(
                  value: _cache.loadingProgress.value == 0
                      ? null
                      : _cache.loadingProgress.value,
                  backgroundColor: theme.colorScheme.primary.withValues(
                    alpha: 0.15,
                  ),
                  color: theme.colorScheme.primary,
                  minHeight: 3,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'در حال دریافت اشعار...',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionRow(List<Map<String, dynamic>> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: items
          .map(
            (item) => SquareActionBox(
              icon: item["icon"],
              title: item["title"],
              onTap: item["onTap"],
            ),
          )
          .toList(),
    );
  }

  void _showSheet(Widget child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      builder: (_) => child,
    );
  }
}
