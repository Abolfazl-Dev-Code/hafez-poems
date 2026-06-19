import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hafez_poems/controllers/profile_controller.dart';
import 'package:hafez_poems/screens/hafez_biography_screen.dart';
import 'package:hafez_poems/screens/poem_list_sheet.dart';
import 'package:hafez_poems/screens/poem_screen.dart';
import 'package:hafez_poems/services/poem_cache_services.dart';
import 'package:hafez_poems/services/poem_local_services.dart';
import 'package:hafez_poems/widgets/custom_appbar.dart';
import 'package:hafez_poems/screens/fal_screen.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/widgets/persian_numbers.dart';
import '../widgets/square_box.dart';
import 'carousel_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final GhazalCacheService _cache = Get.find<GhazalCacheService>();
  Worker? _textsReadyWorker;
  Worker? _indexingWorker;

  List<String> _allTexts = [];
  List<String> _carouselTexts = [];
  bool _isLoadingCarousel = true;

  // Shimmer animation
  late final AnimationController _shimmerController;
  late final Animation<double> _shimmerAnim;

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _shimmerAnim = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

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

  // ── Greeting card ──────────────────────────────────────────────────────────
  String _greetingText({String name = ''}) {
    final hour = DateTime.now().hour;
    String base;

    if (hour >= 6 && hour < 12) {
      base = 'صبح بخیر';
    } else if (hour >= 12 && hour < 17) {
      base = 'ظهر بخیر';
    } else if (hour >= 17 && hour < 21) {
      base = 'عصر بخیر';
    } else {
      base = 'شب بخیر';
    }

    return name.trim().isEmpty ? base : '$base ${name.trim()}';
  }

  String get _greetingSubtitle {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) return 'روزت رو با یه بیت حافظ شروع کن ☀️';
    if (hour >= 12 && hour < 17) return 'یه لحظه استراحت با حافظ 🍃';
    if (hour >= 17 && hour < 21) return 'عصرانه‌ات رو با شعر همراه کن 🌿';
    return 'شبت رو با حافظ آروم کن 🌙'; // 21 تا 24 و 0 تا 6
  }

  IconData get _greetingIcon {
    final hour = DateTime.now().hour;
    if (hour < 12) return Icons.wb_sunny_rounded;
    if (hour < 17) return Icons.wb_cloudy_rounded;
    if (hour < 21) return Icons.wb_twilight_rounded;
    return Icons.nightlight_round;
  }

  List<Color> _greetingGradientForTheme(bool isLight) {
    final hour = DateTime.now().hour;

    if (isLight) {
      if (hour >= 6 && hour < 12) {
        return [const Color(0xFFFFF8EE), const Color(0xFFFFEDD5)];
      }
      if (hour >= 12 && hour < 17) {
        return [const Color(0xFFEFFAF0), const Color(0xFFD4F0D8)];
      }
      if (hour >= 17 && hour < 21) {
        return [const Color(0xFFFFF0F3), const Color(0xFFFFD6E0)];
      }
      return [const Color(0xFFF0ECFC), const Color(0xFFE0D5F5)]; // شب
    } else {
      if (hour >= 6 && hour < 12) {
        return [const Color(0xFF2A1F10), const Color(0xFF1E1508)];
      }
      if (hour >= 12 && hour < 17) {
        return [const Color(0xFF0F1F12), const Color(0xFF0A1A0C)];
      }
      if (hour >= 17 && hour < 21) {
        return [const Color(0xFF221018), const Color(0xFF180A10)];
      }
      return [const Color(0xFF14102A), const Color(0xFF0D0A1E)]; // شب
    }
  }

  Color _greetingIconColor(bool isLight) {
    final hour = DateTime.now().hour;

    if (isLight) {
      if (hour >= 6 && hour < 12) return const Color(0xFFE67E22);
      if (hour >= 12 && hour < 17) return const Color(0xFF27AE60);
      if (hour >= 17 && hour < 21) return const Color(0xFFE91E8C);
      return const Color(0xFF7C4DFF); // شب
    } else {
      if (hour >= 6 && hour < 12) return const Color(0xFFFFB74D);
      if (hour >= 12 && hour < 17) return const Color(0xFF81C784);
      if (hour >= 17 && hour < 21) return const Color(0xFFF48FB1);
      return const Color(0xFFB39DDB); // شب
    }
  }

  Widget _buildGreetingCard(ThemeData theme) {
    final isLight = theme.brightness == Brightness.light;
    final gradColors = _greetingGradientForTheme(isLight);
    final iconColor = _greetingIconColor(isLight);

    final ProfileController profileController = Get.find<ProfileController>();

    return Obx(() {
      final String userName = profileController.userName.value;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradColors,
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: iconColor.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(_greetingIcon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _greetingText(name: userName),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontFamily: 'vazir',
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.85,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _greetingSubtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'vazir',
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // ── Grid یکدست برای ۵ باکس ────────────────────────────────────────────────
  Widget _buildPoemGrid(ThemeData theme) {
    final items = [
      _ActionItem(
        icon: Image.asset("assets/icon/ghazaliat.png", width: 56, height: 56),
        title: "غزلیات",
        subtitle: "۴۹۵ غزل",
        onTap: () => _showSheet(
          PoemListSheet(
            config: PoemListConfig(
              headerTitle: 'لیست غزل‌ها',
              loadingText: 'در حال دریافت غزل‌ها...',
              emptyText: 'هیچ غزلی یافت نشد',
              items: Get.find<GhazalCacheService>().cachedGhazalsRx,
              isIndexing: Get.find<GhazalCacheService>().isIndexing,
              loadingProgress: Get.find<GhazalCacheService>().loadingProgress,
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
                    Get.find<GhazalCacheService>().getAudioUrl(id),
              ),
            ),
          ),
        ),
      ),
      _ActionItem(
        icon: Image.asset("assets/icon/ghasayed.png", width: 49, height: 49),
        title: "قصاید",
        subtitle: "۳ قصیده",
        onTap: () => _showSheet(
          PoemListSheet(
            config: PoemListConfig(
              headerTitle: 'قصاید حافظ',
              loadingText: 'در حال دریافت قصاید...',
              emptyText: 'هیچ قصیده‌ای یافت نشد',
              tilePrefix: 'قصیده شماره',
              items: Get.find<GhasayedCacheService>().cachedQasaidRx,
              isIndexing: Get.find<GhasayedCacheService>().isIndexing,
              loadingProgress: Get.find<GhasayedCacheService>().loadingProgress,
              prefetch: (id) => Get.find<GhasayedCacheService>()
                  .getQasaidDetail(id)
                  .then((_) {}),
              onRetry: Get.find<GhasayedCacheService>().preload,
              buildArgs: (item) => PoemScreenArgs(
                id: item.id,
                title: item.title,
                text: item.hasFullText ? item.text : '',
                fetchText: (id) => Get.find<GhasayedCacheService>()
                    .getGhasayedDetail(id)
                    .then((d) => d.text),
                fetchAudioUrl: (id) =>
                    Get.find<GhasayedCacheService>().getAudioUrl(id),
              ),
            ),
          ),
        ),
      ),
      _ActionItem(
        icon: Image.asset("assets/icon/robaeiyat.png", width: 59, height: 59),
        title: "رباعیات",
        subtitle: "۴۲ رباعی",
        onTap: () => _showSheet(
          PoemListSheet(
            config: PoemListConfig(
              headerTitle: 'رباعیات حافظ',
              loadingText: 'در حال دریافت رباعیات...',
              emptyText: 'هیچ رباعی‌ای یافت نشد',
              tilePrefix: 'رباعی شماره',
              items: Get.find<RobaeyatCacheService>().cachedRobaeyatRx,
              isIndexing: Get.find<RobaeyatCacheService>().isIndexing,
              loadingProgress: Get.find<RobaeyatCacheService>().loadingProgress,
              prefetch: (id) => Get.find<RobaeyatCacheService>()
                  .getRobaeyatDetail(id)
                  .then((_) {}),
              onRetry: Get.find<RobaeyatCacheService>().preload,
              buildArgs: (item) => PoemScreenArgs(
                id: item.id,
                title: item.title,
                text: item.hasFullText ? item.text : '',
                fetchText: (id) => Get.find<RobaeyatCacheService>()
                    .getRobaeyatDetail(id)
                    .then((d) => d.text),
                fetchAudioUrl: (id) =>
                    Get.find<RobaeyatCacheService>().getAudioUrl(id),
              ),
            ),
          ),
        ),
      ),
      _ActionItem(
        icon: Image.asset("assets/icon/divan.png", width: 50, height: 50),
        title: "قطعات",
        subtitle: "34 قطعه".toPersianNumbers(),
        onTap: () => _showSheet(
          PoemListSheet(
            config: PoemListConfig(
              headerTitle: 'قطعات حافظ',
              loadingText: 'در حال دریافت قطعات...',
              emptyText: 'هیچ قطعه‌ای یافت نشد',
              tilePrefix: 'قطعه شماره',
              items: Get.find<GhataatCacheService>().cachedGhataatRx,
              isIndexing: Get.find<GhataatCacheService>().isIndexing,
              loadingProgress: Get.find<GhataatCacheService>().loadingProgress,
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
                    Get.find<GhataatCacheService>().getAudioUrl(id),
              ),
            ),
          ),
        ),
      ),
      _ActionItem(
        icon: Image.asset("assets/icon/taabir.png", width: 59, height: 59),
        title: "اشعار منتسب",
        subtitle: "اشعار دیگر",
        onTap: () => _showSheet(
          PoemListSheet(
            config: PoemListConfig(
              headerTitle: 'اشعار منتسب حافظ',
              loadingText: 'در حال دریافت اشعار منتسب...',
              emptyText: 'هیچ شعری یافت نشد',
              tilePrefix: 'شماره',
              items: Get.find<MontasabCacheService>().cachedMontasabRx,
              isIndexing: Get.find<MontasabCacheService>().isIndexing,
              loadingProgress: Get.find<MontasabCacheService>().loadingProgress,
              prefetch: (id) => Get.find<MontasabCacheService>()
                  .getMontasabDetail(id)
                  .then((_) {}),
              onRetry: Get.find<MontasabCacheService>().preload,
              buildArgs: (item) => PoemScreenArgs(
                id: item.id,
                title: item.title,
                text: item.hasFullText ? item.text : '',
                fetchText: (id) => Get.find<MontasabCacheService>()
                    .getMontasabDetail(id)
                    .then((d) => d.text),
                fetchAudioUrl: (id) =>
                    Get.find<MontasabCacheService>().getAudioUrl(id),
              ),
            ),
          ),
        ),
      ),
      _ActionItem(
        icon: Icon(Icons.auto_awesome_rounded),
        title: "به زودی...",
        subtitle: "",
        onTap: () {},
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const gap = 0.0;
          final itemWidth = (constraints.maxWidth - gap * 2) / 3;

          Widget buildCell(_ActionItem item) {
            return SizedBox(width: itemWidth, child: item);
          }

          return Column(
            children: [
              Row(
                children: [
                  buildCell(items[0]),
                  const SizedBox(width: gap),
                  buildCell(items[1]),
                  const SizedBox(width: gap),
                  buildCell(items[2]),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildCell(items[3]),
                  const SizedBox(width: gap),
                  buildCell(items[4]),
                  const SizedBox(width: gap),
                  buildCell(items[5]),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  _buildGreetingCard(theme),

                  const SizedBox(height: 20),

                  // ── Carousel / Skeleton ──
                  if (_isLoadingCarousel && _carouselTexts.isEmpty)
                    _buildShimmerSkeleton(theme)
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
                        key: ValueKey(_carouselTexts[index]),
                        initialGhazal: _carouselTexts[index],
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
                  _buildSectionHeader(theme, 'دیوان حافظ'),
                  const SizedBox(height: 16),

                  _buildPoemGrid(theme),
                  const SizedBox(height: 8),
                  // ── بخش فال — جدا و برجسته ──
                  _buildSectionHeader(theme, 'ویژ‌ه‌ها'),
                  const SizedBox(height: 16),
                  _buildFalBanner(theme),
                  const SizedBox(height: 14),
                  _buildBiographyBanner(theme),
                  const SizedBox(height: 70),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Section header ─────────────────────────────────────────────────────────
  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 18,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontFamily: 'vazir',
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiographyBanner(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.mediumImpact();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const HafezBiographyScreen()),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.38),
                width: 1,
              ),
              // ── تصویر پس‌زمینه ──
              image: DecorationImage(
                image: AssetImage('assets/icon/hafez-banner.png'),
                fit: BoxFit.cover,
                opacity: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 39),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // فلش
                  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 17,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── فال banner ─────────────────────────────────────────────────────────────
  Widget _buildFalBanner(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.mediumImpact();
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const FalScreen()));
          },
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.38),
                width: 1,
              ),
              // ── تصویر پس‌زمینه ──
              image: DecorationImage(
                image: AssetImage(
                  'assets/icon/faal-banner.png',
                ), // نام فایل رو عوض کن
                fit: BoxFit.fitWidth,
                opacity: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 17,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Shimmer skeleton ────────────────────────────────────────────────────────
  Widget _buildShimmerSkeleton(ThemeData theme) {
    return AnimatedBuilder(
      animation: _shimmerAnim,
      builder: (_, _) {
        return Container(
          height: 180,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.15),
            ),
            gradient: LinearGradient(
              begin: Alignment(_shimmerAnim.value - 1, 0),
              end: Alignment(_shimmerAnim.value, 0),
              colors: [
                theme.colorScheme.onSurface.withValues(alpha: 0.04),
                theme.colorScheme.onSurface.withValues(alpha: 0.10),
                theme.colorScheme.onSurface.withValues(alpha: 0.04),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _shimmerLine(theme, width: 180, height: 12),
                const SizedBox(height: 10),
                _shimmerLine(theme, width: double.infinity, height: 10),
                const SizedBox(height: 8),
                _shimmerLine(theme, width: 220, height: 10),
                const SizedBox(height: 16),
                _shimmerLine(theme, width: 90, height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _shimmerLine(
    ThemeData theme, {
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  // ── Action row ──────────────────────────────────────────────────────────────

  void _showSheet(Widget child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      builder: (_) => child,
    );
  }
}

// ── Action item wrapper با subtitle و HapticFeedback ───────────────────────
class _ActionItem extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Column(
        children: [
          SquareActionBox(icon: icon, title: title, onTap: onTap),
          const SizedBox(height: 0),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontFamily: 'vazir',
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}
