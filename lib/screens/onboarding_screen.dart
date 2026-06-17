import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // Controllers — page-transition (rebuilt each time)
  late AnimationController _contentController;
  late AnimationController _bgController;
  late AnimationController _iconController;

  // Controllers — persistent (built once in initState)
  late final AnimationController _breatheController;
  late final AnimationController _pulseController;
  late final AnimationController _particleController;

  // Animations
  late Animation<double> _contentFade;
  late Animation<Offset> _contentSlide;
  late Animation<double> _iconScale;
  late Animation<Color?> _bgColorTop;
  late Animation<Color?> _bgColorBottom;
  late Animation<Color?> _accentColor;
  late Animation<double> _breatheScale;
  late Animation<double> _pulseScale;
  late Animation<double> _pulseOpacity;

  static const _slides = [
    _SlideData(
      icon: Icons.menu_book_rounded,
      title: 'اشعار حافظ',
      subtitle: 'تمام غزل‌ها، قصاید و رباعیات\nدر یک برنامه، همیشه در دسترس',
      lightBgTop: Color(0xFFF5E6C8),
      lightBgBottom: Color(0xFFD4AA70),
      darkBgTop: Color(0xFF2C1F0E),
      darkBgBottom: Color(0xFF1A1005),
      lightAccent: Color(0xFF6D4C41),
      darkAccent: Color(0xFFD7A96B),
    ),
    _SlideData(
      icon: Icons.favorite_rounded,
      title: 'مجموعه شخصی',
      subtitle: 'لایک کن، ذخیره کن، هایلایت کن\nشعرهای دلخواهت رو نگه دار',
      lightBgTop: Color(0xFFFFECEC),
      lightBgBottom: Color(0xFFFFB3B3),
      darkBgTop: Color(0xFF2C0E0E),
      darkBgBottom: Color(0xFF1A0808),
      lightAccent: Color(0xFFC62828),
      darkAccent: Color(0xFFEF9A9A),
    ),
    _SlideData(
      icon: Icons.offline_bolt_rounded,
      title: 'همیشه همراهت',
      subtitle: 'حتی بدون اینترنت بخوان\nبا یادآوری روزانه، هر روز یک غزل',
      lightBgTop: Color(0xFFEAF4FF),
      lightBgBottom: Color(0xFF90CAF9),
      darkBgTop: Color(0xFF0E1A2C),
      darkBgBottom: Color(0xFF060E18),
      lightAccent: Color(0xFF1565C0),
      darkAccent: Color(0xFF90CAF9),
    ),
  ];

  final List<_Particle> _particles = [];
  final Random _rng = Random();

  @override
  void initState() {
    super.initState();

    // ✅ کنترلرهای persistent فقط یک‌بار اینجا ساخته می‌شن
    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _breatheScale = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOut),
    );
    _pulseScale = Tween<double>(
      begin: 1.0,
      end: 1.07,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));
    _pulseOpacity = Tween<double>(
      begin: 0.6,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));

    _generateParticles();

    // کنترلرهای transition موقتاً placeholder می‌سازیم تا didChangeDependencies آماده بشه
    _contentController = AnimationController(
      vsync: this,
      duration: Duration.zero,
    );
    _bgController = AnimationController(vsync: this, duration: Duration.zero);
    _iconController = AnimationController(vsync: this, duration: Duration.zero);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _setupAnimations باید بعد از اینکه context داره MediaQuery رو می‌ده فراخوانی بشه
    _setupTransitionAnimations(0, 0);
    _contentController.forward();
    _bgController.forward();
    _iconController.forward();
  }

  void _generateParticles() {
    _particles.clear();
    for (int i = 0; i < 18; i++) {
      _particles.add(
        _Particle(
          x: _rng.nextDouble(),
          y: _rng.nextDouble(),
          radius: _rng.nextDouble() * 6 + 2,
          speed: _rng.nextDouble() * 0.3 + 0.1,
          phase: _rng.nextDouble() * 2 * pi,
          opacity: _rng.nextDouble() * 0.18 + 0.04,
        ),
      );
    }
  }

  // فقط سه کنترلر transition رو rebuild می‌کنه — persistent ها دست نمی‌خوره
  void _setupTransitionAnimations(int fromPage, int toPage) {
    _contentController.dispose();
    _bgController.dispose();
    _iconController.dispose();

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
      duration: const Duration(milliseconds: 700),
    );
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
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

    _bgColorTop = ColorTween(
      begin: isLight ? currentSlide.lightBgTop : currentSlide.darkBgTop,
      end: isLight ? nextSlide.lightBgTop : nextSlide.darkBgTop,
    ).animate(_bgController);

    _bgColorBottom = ColorTween(
      begin: isLight ? currentSlide.lightBgBottom : currentSlide.darkBgBottom,
      end: isLight ? nextSlide.lightBgBottom : nextSlide.darkBgBottom,
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

    HapticFeedback.lightImpact();

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
    _setupTransitionAnimations(fromPage, page);

    _bgController.forward(from: 0);
    _contentController.forward(from: 0);
    _iconController.forward(from: 0);
  }

  Future<void> _finish() async {
    HapticFeedback.mediumImpact();
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
    // ✅ persistent controllers هم اینجا dispose می‌شن
    _breatheController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final slide = _slides[_currentPage];
    final accent = isLight ? slide.lightAccent : slide.darkAccent;
    final bgTop = isLight ? slide.lightBgTop : slide.darkBgTop;
    final bgBottom = isLight ? slide.lightBgBottom : slide.darkBgBottom;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _bgController,
        _contentController,
        _iconController,
        _breatheController,
        _pulseController,
        _particleController,
      ]),
      builder: (context, _) {
        final animBgTop = _bgColorTop.value ?? bgTop;
        final animBgBottom = _bgColorBottom.value ?? bgBottom;
        final animAccent = _accentColor.value ?? accent;

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [animBgTop, animBgBottom],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _IslamicPatternPainter(
                        color: animAccent.withValues(alpha: 0.06),
                        progress: _particleController.value,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _ParticlePainter(
                        particles: _particles,
                        color: animAccent,
                        progress: _particleController.value,
                      ),
                    ),
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16, top: 12),
                            child: GestureDetector(
                              onTap: _finish,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: animAccent.withValues(alpha: 0.3),
                                    width: 1.2,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  color: animAccent.withValues(alpha: 0.07),
                                ),
                                child: Text(
                                  'رد کردن',
                                  style: TextStyle(
                                    color: animAccent.withValues(alpha: 0.7),
                                    fontFamily: 'vazir',
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            physics: const BouncingScrollPhysics(),
                            itemCount: _slides.length,
                            onPageChanged: (page) {
                              if (page != _currentPage) _goToPage(page);
                            },
                            itemBuilder: (_, index) => _buildPage(
                              slide: _slides[index],
                              accent: animAccent,
                              isLight: isLight,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 36),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  _slides.length,
                                  (i) => AnimatedContainer(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
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
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  AnimatedBuilder(
                                    animation: _pulseController,
                                    builder: (_, _) => Transform.scale(
                                      scale: _pulseScale.value,
                                      child: Opacity(
                                        opacity: _pulseOpacity.value,
                                        child: Container(
                                          width: double.infinity,
                                          height: 56,
                                          decoration: BoxDecoration(
                                            color: animAccent.withValues(
                                              alpha: 0.4,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 400),
                                    width: double.infinity,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: animAccent,
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          color: animAccent.withValues(
                                            alpha: 0.4,
                                          ),
                                          blurRadius: 20,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(18),
                                        onTap: () =>
                                            _goToPage(_currentPage + 1),
                                        child: Center(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                _currentPage ==
                                                        _slides.length - 1
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
                                              if (_currentPage <
                                                  _slides.length - 1) ...[
                                                const SizedBox(width: 8),
                                                Icon(
                                                  Icons.arrow_back_rounded,
                                                  color: isLight
                                                      ? Colors.white
                                                      : Colors.black87,
                                                  size: 20,
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
    required bool isLight,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _iconScale,
            child: AnimatedBuilder(
              animation: _breatheController,
              builder: (_, _) => Transform.scale(
                scale: _breatheScale.value,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(70),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accent.withValues(alpha: 0.13),
                        border: Border.all(
                          color: accent.withValues(alpha: 0.35),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: accent.withValues(alpha: 0.25),
                            blurRadius: 50,
                            spreadRadius: 10,
                          ),
                        ],
                        gradient: RadialGradient(
                          colors: [
                            accent.withValues(alpha: 0.2),
                            accent.withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                      child: Icon(slide.icon, size: 64, color: accent),
                    ),
                  ),
                ),
              ),
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
                  height: 1.9,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Particle system ────────────────────────────────────────────────────────

class _Particle {
  final double x, y, radius, speed, phase, opacity;
  const _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.phase,
    required this.opacity,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final Color color;
  final double progress;

  _ParticlePainter({
    required this.particles,
    required this.color,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = progress * 2 * pi * p.speed + p.phase;
      final dx = cos(t * 0.6) * 10;
      final dy = sin(t) * 18;
      canvas.drawCircle(
        Offset(p.x * size.width + dx, p.y * size.height + dy),
        p.radius,
        Paint()..color = color.withValues(alpha: p.opacity),
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}

// ─── Islamic decorative pattern ──────────────────────────────────────────────

class _IslamicPatternPainter extends CustomPainter {
  final Color color;
  final double progress;

  _IslamicPatternPainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const step = 80.0;
    final shift = sin(progress * 2 * pi) * 4;

    for (double x = -step; x < size.width + step; x += step) {
      for (double y = -step; y < size.height + step; y += step) {
        _drawStar(canvas, paint, Offset(x + shift, y + shift), 28);
      }
    }
  }

  void _drawStar(Canvas canvas, Paint paint, Offset center, double r) {
    const points = 8;
    final path = Path();
    for (int i = 0; i < points * 2; i++) {
      final angle = (i * pi) / points - pi / 2;
      final radius = i.isEven ? r : r * 0.45;
      final px = center.dx + radius * cos(angle);
      final py = center.dy + radius * sin(angle);
      i == 0 ? path.moveTo(px, py) : path.lineTo(px, py);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_IslamicPatternPainter old) => old.progress != progress;
}

// ─── Data class ──────────────────────────────────────────────────────────────

class _SlideData {
  final IconData icon;
  final String title, subtitle;
  final Color lightBgTop, lightBgBottom, darkBgTop, darkBgBottom;
  final Color lightAccent, darkAccent;

  const _SlideData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.lightBgTop,
    required this.lightBgBottom,
    required this.darkBgTop,
    required this.darkBgBottom,
    required this.lightAccent,
    required this.darkAccent,
  });
}
