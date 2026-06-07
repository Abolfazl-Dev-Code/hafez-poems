import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hafez_poems/screens/bottom_nav_bar.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _initialized = false;
  late AnimationController _contentController;
  late AnimationController _bgController;
  late AnimationController _iconController;
  late Animation<double> _contentFade;
  late Animation<Offset> _contentSlide;
  late Animation<double> _iconScale;
  late Animation<Color?> _bgColor;
  late Animation<Color?> _accentColor;

  static const _slides = [
    _SlideData(
      icon: Icons.menu_book_rounded,
      title: 'دیوان حافظ',
      subtitle: 'تمام غزل‌ها، قصاید و رباعیات\nدر یک برنامه، همیشه در دسترس',
      lightBg: Color(0xFFE8D5B7),
      darkBg: Color(0xFF2C1F0E),
      lightAccent: Color(0xFF6D4C41),
      darkAccent: Color(0xFFD7A96B),
    ),
    _SlideData(
      icon: Icons.favorite_rounded,
      title: 'مجموعه شخصی',
      subtitle: 'لایک کن، ذخیره کن، هایلایت کن\nشعرهای دلخواهت رو نگه دار',
      lightBg: Color(0xFFFFE4E4),
      darkBg: Color(0xFF2C0E0E),
      lightAccent: Color(0xFFC62828),
      darkAccent: Color(0xFFEF9A9A),
    ),
    _SlideData(
      icon: Icons.offline_bolt_rounded,
      title: 'همیشه همراهت',
      subtitle: 'حتی بدون اینترنت بخوان\nبا یادآوری روزانه، هر روز یک غزل',
      lightBg: Color(0xFFE4F0FF),
      darkBg: Color(0xFF0E1A2C),
      lightAccent: Color(0xFF1565C0),
      darkAccent: Color(0xFF90CAF9),
    ),
  ];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _setupAnimations(0, 0);
      _contentController.forward();
      _bgController.forward();
      _iconController.forward();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void _setupAnimations(int fromPage, int toPage) {
    try {
      _contentController.dispose();
    } catch (_) {}
    try {
      _bgController.dispose();
    } catch (_) {}
    try {
      _iconController.dispose();
    } catch (_) {}

    final isLight =
        MediaQuery.platformBrightnessOf(context) == Brightness.light;
    final currentSlide = _slides[fromPage];
    final nextSlide = _slides[toPage];

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _contentFade = CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOut,
    );
    _contentSlide =
        Tween<Offset>(begin: const Offset(0.15, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _contentController,
            curve: Curves.easeOutCubic,
          ),
        );
    _iconScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeOutBack),
    );

    _bgColor = ColorTween(
      begin: isLight ? currentSlide.lightBg : currentSlide.darkBg,
      end: isLight ? nextSlide.lightBg : nextSlide.darkBg,
    ).animate(_bgController);

    _accentColor = ColorTween(
      begin: isLight ? currentSlide.lightAccent : currentSlide.darkAccent,
      end: isLight ? nextSlide.lightAccent : nextSlide.darkAccent,
    ).animate(_bgController);
  }

  Future<void> _goToPage(int page) async {
    if (page >= _slides.length) {
      _finish();
      return;
    }

    _contentController.stop();
    _iconController.stop();

    await Future.wait([
      _contentController.reverse(),
      _iconController.reverse(),
    ]);

    if (!mounted) return;

    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );

    final fromPage = _currentPage;
    setState(() => _currentPage = page);
    _setupAnimations(fromPage, page);

    _bgController.forward(from: 0);
    _contentController.forward(from: 0);
    _iconController.forward(from: 0);
  }

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboarding', true);
    Get.offAll(
      () => const BottomNavBar(),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _contentController.dispose();
    _bgController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final slide = _slides[_currentPage];
    final accent = isLight ? slide.lightAccent : slide.darkAccent;
    final bg = isLight ? slide.lightBg : slide.darkBg;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _bgController,
        _contentController,
        _iconController,
      ]),
      builder: (context, _) {
        final animBg = _bgColor.value ?? bg;
        final animAccent = _accentColor.value ?? accent;

        return Scaffold(
          backgroundColor: animBg,
          body: SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16, top: 8),
                      child: TextButton(
                        onPressed: _finish,
                        child: Text(
                          'رد کردن',
                          style: TextStyle(
                            color: animAccent.withValues(alpha: 0.6),
                            fontFamily: 'vazir',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _slides.length,
                      itemBuilder: (_, index) => _buildPage(
                        slide: _slides[index],
                        accent: animAccent,
                        bg: animBg,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _slides.length,
                            (i) => AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: i == _currentPage ? 28 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: i == _currentPage
                                    ? animAccent
                                    : animAccent.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            color: animAccent,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: animAccent.withValues(alpha: 0.35),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () => _goToPage(_currentPage + 1),
                              child: Center(
                                child: Text(
                                  _currentPage == _slides.length - 1
                                      ? 'ورود به دنیای حافظ'
                                      : 'بعدی',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'vazir',
                                    fontWeight: FontWeight.bold,
                                    color: isLight
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPage({
    required _SlideData slide,
    required Color accent,
    required Color bg,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _iconScale,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withValues(alpha: 0.12),
                border: Border.all(
                  color: accent.withValues(alpha: 0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.2),
                    blurRadius: 40,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Icon(slide.icon, size: 64, color: accent),
            ),
          ),
          const SizedBox(height: 48),
          FadeTransition(
            opacity: _contentFade,
            child: SlideTransition(
              position: _contentSlide,
              child: Text(
                slide.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'vazir',
                  fontWeight: FontWeight.bold,
                  color: accent,
                  height: 1.4,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FadeTransition(
            opacity: _contentFade,
            child: SlideTransition(
              position: _contentSlide,
              child: Text(
                slide.subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'vazir',
                  color: accent.withValues(alpha: 0.7),
                  height: 1.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SlideData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color lightBg;
  final Color darkBg;
  final Color lightAccent;
  final Color darkAccent;

  const _SlideData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.lightBg,
    required this.darkBg,
    required this.lightAccent,
    required this.darkAccent,
  });
}
