import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_theme.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:hafez_poems/models/onboarding_particle.dart';
import 'package:hafez_poems/models/onboarding_slide_data.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/bottomNavBar/bottom_nav_bar.dart';
import 'package:hafez_poems/onboardingSplashUnit/onboarding_indicator.dart';
import 'package:hafez_poems/onboardingSplashUnit/onboarding_islamic_pattern.dart';
import 'package:hafez_poems/onboardingSplashUnit/onboarding_particle_painter.dart';
import 'package:hafez_poems/onboardingSplashUnit/onboarding_slide_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  late final AnimationController _contentController;
  late final AnimationController _iconController;
  late final AnimationController _breatheController;
  late final AnimationController _particleController;

  late final Animation<double> _contentFade;
  late final Animation<Offset> _contentSlide;
  late final Animation<double> _iconScale;
  late final Animation<double> _breatheScale;

  final List<Particle> _particles = [];

  static const List<SlideData> _slides = [
    SlideData(
      icon: Icons.menu_book_rounded,
      title: "دیوان کامل حافظ",
      subtitle: "تمام غزلیات، رباعیات و قصاید حافظ\nدر یک مجموعه زیبا و خوانا",
      lightBgTop: Color(0xFFF8F5F0),
      lightBgBottom: Color(0xFFEFE7DA),
      darkBgTop: Color(0xFF0F172A),
      darkBgBottom: Color(0xFF020617),
      lightAccent: Color(0xFF8B5E3C),
      darkAccent: BiographyColors.gold,
    ),

    SlideData(
      icon: Icons.auto_awesome_rounded,
      title: "فال حافظ",
      subtitle: "با نیتی از دل فال بگیر\nو پیام حافظ را بخوان",
      lightBgTop: Color(0xFFFDF6EC),
      lightBgBottom: Color(0xFFF5E8D8),
      darkBgTop: Color(0xFF020617),
      darkBgBottom: Color(0xFF0F172A),
      lightAccent: Color(0xFFB45309),
      darkAccent: Color(0xFFFACC15),
    ),

    SlideData(
      icon: Icons.headphones_rounded,
      title: "پخش صوتی اشعار",
      subtitle: "به غزل‌های حافظ با صدای دلنشین گوش بده\nو در شعرها غرق شو",
      lightBgTop: Color(0xFFF8F5F0),
      lightBgBottom: Color(0xFFEFE7DA),
      darkBgTop: Color(0xFF0F172A),
      darkBgBottom: Color(0xFF020617),
      lightAccent: Color(0xFF92400E),
      darkAccent: Color(0xFFFBBF24),
    ),
  ];

  @override
  void initState() {
    super.initState();

    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _iconScale = CurvedAnimation(
      parent: _iconController,
      curve: Curves.elasticOut,
    );

    _contentFade = CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOut,
    );

    _contentSlide = Tween(begin: const Offset(0, .15), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
        );

    _breatheScale = Tween(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOut),
    );

    _generateParticles();

    _playAnimations();
  }

  void _playAnimations() {
    _iconController.forward(from: 0);
    _contentController.forward(from: 0);
  }

  void _generateParticles() {
    final rnd = Random();

    for (int i = 0; i < 24; i++) {
      _particles.add(
        Particle(
          x: rnd.nextDouble(),
          y: rnd.nextDouble(),
          radius: rnd.nextDouble() * 2 + 1,
          speed: rnd.nextDouble() * 0.8 + 0.2,
          phase: rnd.nextDouble() * 2 * pi,
          opacity: rnd.nextDouble() * 0.5 + 0.2,
        ),
      );
    }
  }

  Future<void> _next() async {
    if (_currentPage == _slides.length - 1) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('seen_onboarding', true);

      if (!mounted) return;
      Get.offAll(() => const BottomNavBar());
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _contentController.dispose();
    _iconController.dispose();
    _breatheController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_currentPage];

    final isLight = Theme.of(context).brightness == Brightness.light;

    final accent = isLight ? slide.lightAccent : slide.darkAccent;

    final bgTop = isLight ? slide.lightBgTop : slide.darkBgTop;
    final bgBottom = isLight ? slide.lightBgBottom : slide.darkBgBottom;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [bgTop, bgBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _particleController,
              builder: (_, _) {
                return Stack(
                  children: [
                    CustomPaint(
                      size: Size.infinite,
                      painter: IslamicPatternPainter(
                        color: accent.withValues(alpha: .05),
                        progress: _particleController.value,
                      ),
                    ),
                    CustomPaint(
                      size: Size.infinite,
                      painter: ParticlePainter(
                        particles: _particles,
                        color: accent,
                        progress: _particleController.value,
                      ),
                    ),
                  ],
                );
              },
            ),
            PageView.builder(
              controller: _pageController,
              itemCount: _slides.length,
              onPageChanged: (i) {
                setState(() => _currentPage = i);
                _playAnimations();
              },
              itemBuilder: (_, i) {
                return OnboardingPage(
                  slide: _slides[i],
                  accent: accent,
                  iconScale: _iconScale,
                  breatheScale: _breatheScale,
                  contentFade: _contentFade,
                  contentSlide: _contentSlide,
                  breatheController: _breatheController,
                );
              },
            ),

            Positioned(
              bottom: 120,
              left: 0,
              right: 0,
              child: OnboardingIndicator(
                length: _slides.length,
                current: _currentPage,
                color: accent,
              ),
            ),

            Positioned(
              bottom: 50,
              left: 32,
              right: 32,
              child: ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.mdRadius,
                  ),
                ),
                child: Text(
                  _currentPage == _slides.length - 1 ? "شروع" : "ادامه",
                  style: const TextStyle(
                    fontFamily: "vazir",
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
