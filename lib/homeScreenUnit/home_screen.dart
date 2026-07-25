import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/custom_appbar.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_banner_home_page.dart';
import 'package:hafez_poems/homeScreenUnit/carouselUnit/carousel_screen.dart';
import 'package:hafez_poems/homeScreenUnit/faalUnit/fal_banner_home_page_screen.dart';
import 'package:hafez_poems/homeScreenUnit/greeting_card.dart';
import 'package:hafez_poems/homeScreenUnit/moshaereHelper/moshaere_helper_banner.dart';
import 'package:hafez_poems/homeScreenUnit/podcastUnit/podcast_banner.dart';
import 'package:hafez_poems/homeScreenUnit/poemBoxesUnit/box_grid_home_page.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/homeScreenUnit/section_header.dart';
import 'package:hafez_poems/poemsUnit/poems/poem_cache_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final GhazalCacheService _cache = Get.find<GhazalCacheService>();
  Worker? _textsReadyWorker;
  Worker? _indexingWorker;
  List<GhazalExcerpt> _allTexts = [];
  List<GhazalExcerpt> _carouselTexts = [];
  late final AnimationController _shimmerController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

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
        if (mounted) {}
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
      });
    }
    return true;
  }

  void _refreshSlide(int index) {
    if (_allTexts.length <= 1 || index >= _carouselTexts.length) return;
    GhazalExcerpt newItem;
    do {
      newItem = _allTexts[Random().nextInt(_allTexts.length)];
    } while (newItem.id == _carouselTexts[index].id && _allTexts.length > 1);
    setState(() => _carouselTexts[index] = newItem);
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _textsReadyWorker?.dispose();
    _indexingWorker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const CustomAppBar(title: "اشعار حافظ"),
                const SizedBox(height: 8),
                GreetingCard(theme),
                const SizedBox(height: 15),
                CarouselSlider.builder(
                  carouselController: _carouselController,
                  options: CarouselOptions(
                    height: 200,
                    viewportFraction: 0.9,
                    enableInfiniteScroll: false,
                  ),
                  itemCount: 1,
                  itemBuilder: (context, index, _) => CarouselScreenWidget(
                    key: ValueKey('carousel_slide_$index'),
                    initialGhazal: _carouselTexts[index].excerpt,
                    ghazalNumber: _carouselTexts[index].number,
                    imagePath: 'assets/icons/hafez-light.png',
                    darkImagePath: 'assets/icons/hafez-dark.png',
                    lightColor: const Color.fromARGB(255, 255, 255, 255),
                    darkColor: const Color.fromARGB(255, 41, 28, 14),
                    changeButtonIcon: 'rotate',
                    onChangeGhazal: () => _refreshSlide(index),
                  ),
                ),
                const SizedBox(height: 26),
                SectionHeader(title: 'دیوان حافظ'),
                const SizedBox(height: 16),
                PoemBoxGridsHomePage(theme),
                const SizedBox(height: 8),
                SectionHeader(title: 'ویژه‌ها'),
                const SizedBox(height: 16),
                FalBanner(theme),
                const SizedBox(height: 13),
                BiographyBanner(theme),
                const SizedBox(height: 13),
                PodcastBanner(theme),
                const SizedBox(height: 13),
                MoshaereBanner(theme),
                const SizedBox(height: 85),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
