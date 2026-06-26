import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hafez_poems/screens/biography_banner_home_page.dart';
import 'package:hafez_poems/screens/box_grid_home_page.dart';
import 'package:hafez_poems/screens/fal_banner_home_page_screen.dart';
import 'package:hafez_poems/screens/greeting_card.dart';
import 'package:hafez_poems/screens/shimmer_skeleton_effect.dart';
import 'package:hafez_poems/services/poem_cache_services.dart';
import 'package:hafez_poems/widgets/custom_appbar.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/widgets/section_header.dart';
import 'carousel_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// ✅ تغییر: AutomaticKeepAliveClientMixin اضافه شد
class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final GhazalCacheService _cache = Get.find<GhazalCacheService>();
  Worker? _textsReadyWorker;
  Worker? _indexingWorker;

  List<GhazalExcerpt> _allTexts = [];
  List<GhazalExcerpt> _carouselTexts = [];
  bool _isLoadingCarousel = true;

  // Shimmer animation
  late final AnimationController _shimmerController;

  // ✅ تغییر: wantKeepAlive برای ماندن صفحه در حافظه
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
    GhazalExcerpt newItem;
    do {
      newItem = _allTexts[Random().nextInt(_allTexts.length)];
    } while (newItem.id == _carouselTexts[index].id && _allTexts.length > 1);
    setState(() => _carouselTexts[index] = newItem);
  }

  Future<void> _onRefresh() async {
    HapticFeedback.lightImpact();
    _trySetCarouselTexts();
    await Future.delayed(const Duration(milliseconds: 600));
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
    // ✅ تغییر: این خط الزامی است برای AutomaticKeepAliveClientMixin
    super.build(context);

    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            color: theme.colorScheme.primary,
            displacement: 20,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const CustomAppBar(title: "اشعار حافظ"),
                  const SizedBox(height: 8),
                  // ── Greeting ──
                  GreetingCard(theme),
                  const SizedBox(height: 15),
                  // ── Carousel / Skeleton ──
                  if (_isLoadingCarousel && _carouselTexts.isEmpty)
                    ShimmerSkeleton(theme)
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
                      itemBuilder: (context, index, _) => CarouselScreenWidget(
                        key: ValueKey('carousel_slide_$index'),
                        initialGhazal: _carouselTexts[index].excerpt,
                        ghazalNumber: _carouselTexts[index].number,
                        imagePath: 'assets/icon/hafez-light.png',
                        darkImagePath: 'assets/icon/hafez-dark.png',
                        lightColor: const Color.fromARGB(255, 255, 255, 255),
                        darkColor: const Color.fromARGB(255, 41, 28, 14),
                        changeButtonIcon: 'rotate',
                        onChangeGhazal: () => _refreshSlide(index),
                      ),
                    ),

                  const SizedBox(height: 26),
                  // ── بخش دیوان ──
                  SectionHeader(title: 'دیوان حافظ'),
                  const SizedBox(height: 16),

                  PoemBoxGridsHomePage(theme),
                  const SizedBox(height: 8),
                  // ── بخش فال — جدا و برجسته ──
                  SectionHeader(title: 'ویژه‌ها'),
                  const SizedBox(height: 16),
                  FalBanner(theme),
                  const SizedBox(height: 14),
                  BiographyBanner(theme),
                  const SizedBox(height: 70),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
