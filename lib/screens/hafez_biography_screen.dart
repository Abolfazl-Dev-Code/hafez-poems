import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hafez_poems/screens/fal_screen.dart';

// ══════════════════════════════════════════════════════════════════════════════
// رنگ‌پالت
// ══════════════════════════════════════════════════════════════════════════════
const _kNight = Color(0xFF0C1029);
const _kPanel = Color(0xFF141A3A);
const _kGold = Color(0xFFD4AF37);
const _kGoldSoft = Color(0xFFC9A227);
const _kCream = Color(0xFFF3ECD9);
const _kWine = Color(0xFF7A2436);

// ══════════════════════════════════════════════════════════════════════════════
// مدل‌های داده
// ══════════════════════════════════════════════════════════════════════════════
class _Particle {
  final double startX;
  final double size;
  final double drift;
  final double phase;

  const _Particle({
    required this.startX,
    required this.size,
    required this.drift,
    required this.phase,
  });
}

class _ChapterData {
  final String eyebrow;
  final String title;
  final String body;
  final String? pullQuote;
  final IconData icon;

  const _ChapterData({
    required this.eyebrow,
    required this.title,
    required this.body,
    required this.icon,
    this.pullQuote,
  });
}

// ══════════════════════════════════════════════════════════════════════════════
// داده‌های ثابت
// ══════════════════════════════════════════════════════════════════════════════
const List<_ChapterData> _chapters = [
  _ChapterData(
    eyebrow: 'آغاز',
    title: 'زادگاه',
    icon: Icons.location_city_rounded,
    body:
        'در حدود هفت قرن پیش، در شیراز — شهری سرشار از باغ و سرو و آواز — '
        'کودکی به نام شمس‌الدین محمد به دنیا آمد. پدرش بهاءالدین بازرگانی '
        'بود که در سال‌های نخستِ زندگیِ پسر از دنیا رفت و خانواده را در '
        'تنگدستی گذاشت. هیچ‌کس آن روزها گمان نمی‌برد این کودک روزی زبان '
        'غزل پارسی شود.',
  ),
  _ChapterData(
    eyebrow: 'نام',
    title: 'حافظِ قرآن',
    icon: Icons.menu_book_rounded,
    body:
        'محمدِ نوجوان برای کمک به خانواده در نان‌بازاری کار می‌کرد، اما '
        'شب‌ها در مدرسه به آموختن قرآن می‌نشست. می‌گویند تمام کلام‌الله را '
        'از حفظ داشت و به چندین شیوهٔ قرائت می‌خواند؛ از همین‌جا لقبی گرفت '
        'که دیگر هرگز از او جدا نشد: حافظ.',
  ),
  _ChapterData(
    eyebrow: 'آموختن',
    title: 'شاگردی و افسانه',
    icon: Icons.nightlight_round,
    body:
        'حافظ ادبیات، فلسفه و علوم دینی را نزد استادان شیراز آموخت. در '
        'میان روایت‌های مردمی، داستانی نقل می‌شود از چهل شبِ بیداری بر '
        'سرِ مزار شیخی در دامنهٔ کوه، تا سرانجام فروغی در دلش افتاد و '
        'کلامش به شعر گشوده شد.',
  ),
  _ChapterData(
    eyebrow: 'شعر',
    title: 'غزل و عشق',
    icon: Icons.favorite_rounded,
    body:
        'از آن پس غزل برای او زبانی شد برای گفتن از عشقِ زمینی و عشقِ '
        'الهی در یک نفس؛ از می و معشوق و باغ، و در پسِ همهٔ این‌ها، '
        'گفت‌وگو با حقیقت. هیچ شاعری مانند او عرفان را این‌چنین در '
        'پوستینِ شراب و عشق نپوشاند.',
    pullQuote:
        'گل در بر و می در کف و معشوق به کام است\n'
        'سلطان جهانم به چنان کار غلام است',
  ),
  _ChapterData(
    eyebrow: 'روزگار',
    title: 'دربار و فراز و نشیب',
    icon: Icons.account_balance_rounded,
    body:
        'شیراز در زمان حافظ دستخوش تغییر فرمانروایان بود؛ گاه به دربار '
        'شاهان نزدیک می‌شد، گاه با تغییر باد سیاست آرامش شهر برهم '
        'می‌خورد و او ناگزیر می‌شد لحن، و گاه حتی شهر را تغییر دهد. '
        'با این همه، هرگز شعرش را تسلیمِ هیچ قدرتی نکرد.',
  ),
  _ChapterData(
    eyebrow: 'میراث',
    title: 'دیوان ابدی',
    icon: Icons.auto_stories_rounded,
    body:
        'غزل‌هایی که در طول زندگی‌اش پراکنده سروده می‌شد، پس از او در '
        'مجموعه‌ای گرد آمد به نام دیوان حافظ؛ کتابی که از همان سده‌های '
        'نخست، در کنار قرآن، در هر خانهٔ ایرانی جایی یافت و رسمِ '
        '«فال حافظ» را برای نسل‌ها زنده نگه داشت.',
  ),
  _ChapterData(
    eyebrow: 'پایان و آغاز',
    title: 'خاموش‌شدنِ شمع',
    icon: Icons.local_florist_rounded,
    body:
        'حافظ در حدود سال ۷۹۲ هجری در شیراز از دنیا رفت. مزار او در '
        'باغی در شیراز است که امروز نام خودِ او را دارد: حافظیه — '
        'جایی که هنوز هزاران نفر می‌روند تا دلی از اشعارش ببرند.',
  ),
];

// ══════════════════════════════════════════════════════════════════════════════
// صفحهٔ اصلی
// ══════════════════════════════════════════════════════════════════════════════
class HafezBiographyScreen extends StatefulWidget {
  const HafezBiographyScreen({super.key});

  @override
  State<HafezBiographyScreen> createState() => _HafezBiographyScreenState();
}

class _HafezBiographyScreenState extends State<HafezBiographyScreen>
    with TickerProviderStateMixin {
  late final AnimationController _ambientCtrl;
  late final ScrollController _scrollCtrl;
  bool _autoScrolling = false;

  final List<bool> _chapterVisible = List.filled(_chapters.length, false);
  final List<GlobalKey> _chapterKeys = List.generate(
    _chapters.length,
    (_) => GlobalKey(),
  );

  late final List<_Particle> _particles;

  // ══════════════════════════════════════════════════════════════════════════
  @override
  void initState() {
    super.initState();

    final rng = Random();
    _particles = List.generate(
      28,
      (_) => _Particle(
        startX: rng.nextDouble(),
        size: 1.5 + rng.nextDouble() * 2.8,
        drift: (rng.nextDouble() - 0.5) * 70,
        phase: rng.nextDouble(),
      ),
    );

    _ambientCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _scrollCtrl = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkChapterVisibility();
    });
  }

  // ══════════════════════════════════════════════════════════════════════════
  // اسکرول خودکار — سرعت یکنواخت ۷۰px در ثانیه
  // ══════════════════════════════════════════════════════════════════════════
  Future<void> _startAutoScroll() async {
    if (!mounted || !_scrollCtrl.hasClients) return;
    final max = _scrollCtrl.position.maxScrollExtent;
    final current = _scrollCtrl.offset;
    if (max <= 0 || current >= max) return;

    final remaining = max - current;
    // ۷۰ پیکسل در ثانیه — قابل خواندن و یکنواخت
    final ms = (remaining / 70 * 1000).round().clamp(3000, 60000);

    setState(() => _autoScrolling = true);
    try {
      await _scrollCtrl.animateTo(
        max,
        duration: Duration(milliseconds: ms),
        curve: Curves.linear, // سرعت کاملاً یکنواخت
      );
    } catch (_) {}
    if (mounted) setState(() => _autoScrolling = false);
  }

  void _stopAutoScroll() {
    if (!_scrollCtrl.hasClients) return;
    _scrollCtrl.jumpTo(_scrollCtrl.offset);
    if (mounted) setState(() => _autoScrolling = false);
  }

  void _toggleAutoScroll() {
    HapticFeedback.lightImpact();
    _autoScrolling ? _stopAutoScroll() : _startAutoScroll();
  }

  // ══════════════════════════════════════════════════════════════════════════
  void _onScroll() => _checkChapterVisibility();

  void _checkChapterVisibility() {
    final screenH = MediaQuery.of(context).size.height;
    bool changed = false;
    for (int i = 0; i < _chapters.length; i++) {
      if (_chapterVisible[i]) continue;
      final ctx = _chapterKeys[i].currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final posY = box.localToGlobal(Offset.zero).dy;
      if (posY < screenH * 0.88) {
        _chapterVisible[i] = true;
        changed = true;
      }
    }
    if (changed && mounted) setState(() {});
  }

  // ══════════════════════════════════════════════════════════════════════════
  @override
  void dispose() {
    _ambientCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _kNight,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _kGold),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: _buildControls(),
        body: NotificationListener<ScrollNotification>(
          onNotification: (n) {
            if (n is ScrollStartNotification && n.dragDetails != null) {
              if (_autoScrolling) _stopAutoScroll();
            }
            return false;
          },
          child: SingleChildScrollView(
            controller: _scrollCtrl,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildHero(),
                _buildStory(),
                _buildFalSection(),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // دکمهٔ کنترل — با متن راهنما
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildControls() {
    return GestureDetector(
      onTap: _toggleAutoScroll,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color(0xDD141A3A),
          border: Border.all(color: _kGold.withValues(alpha: 0.35)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _autoScrolling ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: _kGold,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              _autoScrolling ? 'توقف اسکرول' : 'برای اسکرول خودکار کلیک کنید',
              style: TextStyle(
                fontFamily: 'vazir',
                fontSize: 12,
                color: _kCream.withValues(alpha: 0.80),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Hero
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildHero() {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.35),
                radius: 1.3,
                colors: [Color(0x22D4AF37), _kNight],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _ambientCtrl,
            builder: (_, _) => CustomPaint(
              size: Size(size.width, size.height),
              painter: _ParticlePainter(_particles, _ambientCtrl.value),
            ),
          ),
          Positioned(
            top: size.height * 0.09,
            right: size.width * 0.11,
            child: AnimatedBuilder(
              animation: _ambientCtrl,
              builder: (_, _) {
                final glow = 0.5 + 0.5 * sin(_ambientCtrl.value * 2 * pi);
                return Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [Color(0xFFFFF9E3), _kGold],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _kGold.withValues(alpha: 0.38 + 0.32 * glow),
                        blurRadius: 38 + 28 * glow,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(size.width, size.height * 0.27),
              painter: _SkylinePainter(),
            ),
          ),
          Positioned(
            bottom: size.height * 0.27 + 52,
            left: 24,
            right: 24,
            child: Column(
              children: [
                Text(
                  'قصهٔ یک نام',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'vazir',
                    fontSize: 12,
                    letterSpacing: 4,
                    color: _kGold.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'حافظ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'vazir',
                    fontSize: 88,
                    color: _kCream,
                    fontWeight: FontWeight.w900,
                    height: 1,
                    shadows: [
                      Shadow(
                        color: _kGold.withValues(alpha: 0.32),
                        blurRadius: 42,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'خواجه شمس‌الدین محمد\nزبان غزل پارسی و صدای جانِ شیراز',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'vazir',
                    fontSize: 13.5,
                    color: _kCream.withValues(alpha: 0.60),
                    height: 2.1,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 22,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _ambientCtrl,
              builder: (_, _) {
                final bob = sin(_ambientCtrl.value * 2 * pi * 1.4) * 5.0;
                return Transform.translate(
                  offset: Offset(0, bob),
                  child: Column(
                    children: [
                      Text(
                        'برای آغاز سفر، پایین بکش',
                        style: TextStyle(
                          fontFamily: 'vazir',
                          fontSize: 11,
                          color: _kGoldSoft.withValues(alpha: 0.75),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: _kGoldSoft.withValues(alpha: 0.8),
                        size: 22,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // داستان
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildStory() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 48, 22, 0),
      child: Column(
        children: List.generate(_chapters.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 56),
            child: _ChapterCard(
              key: _chapterKeys[i],
              data: _chapters[i],
              visible: _chapterVisible[i],
              reverse: i.isOdd,
            ),
          );
        }),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // بخش فال — با navigate به FalScreen
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildFalSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 36, 24, 36),
        decoration: BoxDecoration(
          color: _kPanel,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: _kGold.withValues(alpha: 0.22)),
          boxShadow: [
            BoxShadow(
              color: _kGold.withValues(alpha: 0.06),
              blurRadius: 30,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              'یک رسمِ هزارساله',
              style: TextStyle(
                fontFamily: 'vazir',
                fontSize: 11,
                letterSpacing: 3.5,
                color: _kGold.withValues(alpha: 0.88),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'فالی از حافظ',
              style: TextStyle(
                fontFamily: 'vazir',
                fontSize: 23,
                color: _kCream,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'برای گرفتن فال، روی کتاب بزن',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'vazir',
                fontSize: 13,
                color: _kCream.withValues(alpha: 0.52),
              ),
            ),
            const SizedBox(height: 32),
            // کتاب — با tap به FalScreen می‌رود
            GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const FalScreen()));
              },
              child: _BookCover(),
            ),
            const SizedBox(height: 20),
            Text(
              'برای گرفتن فال لمس کنید',
              style: TextStyle(
                fontFamily: 'vazir',
                fontSize: 12,
                color: _kGoldSoft.withValues(alpha: 0.70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// جلد کتاب (بدون منطق فال — فقط UI برای navigate)
// ══════════════════════════════════════════════════════════════════════════════
class _BookCover extends StatelessWidget {
  const _BookCover();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      height: 256,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6B1A28), _kWine, Color(0xFF4D1320)],
        ),
        border: Border.all(color: _kGoldSoft, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.menu_book_rounded, color: _kGold, size: 40),
          const SizedBox(height: 12),
          const Text(
            'دیوان حافظ',
            style: TextStyle(
              fontFamily: 'vazir',
              color: _kGold,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'برای گرفتن فال، لمس کن',
            style: TextStyle(
              fontFamily: 'vazir',
              fontSize: 11,
              color: _kCream.withValues(alpha: 0.45),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// کارت فصل
// ══════════════════════════════════════════════════════════════════════════════
class _ChapterCard extends StatelessWidget {
  final _ChapterData data;
  final bool visible;
  final bool reverse;

  const _ChapterCard({
    super.key,
    required this.data,
    required this.visible,
    required this.reverse,
  });

  @override
  Widget build(BuildContext context) {
    final row = <Widget>[
      _buildIconBadge(),
      const SizedBox(width: 18),
      Expanded(child: _buildText()),
    ];

    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 880),
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: visible ? Offset.zero : const Offset(0, 0.10),
        duration: const Duration(milliseconds: 880),
        curve: Curves.easeOutCubic,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: reverse ? row.reversed.toList() : row,
        ),
      ),
    );
  }

  Widget _buildIconBadge() {
    return Container(
      width: 62,
      height: 62,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: _kGold.withValues(alpha: 0.30)),
        gradient: RadialGradient(
          colors: [_kGold.withValues(alpha: 0.13), Colors.transparent],
        ),
      ),
      child: Icon(data.icon, color: _kGold, size: 26),
    );
  }

  Widget _buildText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.eyebrow,
          style: TextStyle(
            fontFamily: 'vazir',
            fontSize: 10,
            letterSpacing: 3.2,
            color: _kGold.withValues(alpha: 0.88),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          data.title,
          style: const TextStyle(
            fontFamily: 'vazir',
            fontSize: 21,
            color: _kCream,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          data.body,
          style: TextStyle(
            fontFamily: 'vazir',
            fontSize: 13.5,
            color: _kCream.withValues(alpha: 0.62),
            height: 2.1,
          ),
        ),
        if (data.pullQuote != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 14, 16, 14),
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: _kWine, width: 3)),
              color: Color(0x1A7A2436),
            ),
            child: Text(
              data.pullQuote!,
              style: const TextStyle(
                fontFamily: 'vazir',
                fontSize: 14,
                color: Color(0xFFF1D9B8),
                height: 2.4,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ذرات طلایی
// ══════════════════════════════════════════════════════════════════════════════
class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double t;

  _ParticlePainter(this.particles, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final p in particles) {
      final phase = (p.phase + t) % 1.0;
      final x = p.startX * size.width + p.drift * sin(phase * pi);
      final y = phase * size.height * 1.08 - size.height * 0.04;
      final opacity = phase < 0.1
          ? phase / 0.1
          : (phase > 0.88 ? (1 - phase) / 0.12 : 1.0);
      paint.color = _kGold.withValues(alpha: 0.55 * opacity.clamp(0, 1));
      canvas.drawCircle(Offset(x, y), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.t != t;
}

// ══════════════════════════════════════════════════════════════════════════════
// خط افق شیراز
// ══════════════════════════════════════════════════════════════════════════════
class _SkylinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final fillPaint = Paint()
      ..color = const Color(0xFF0A0E22)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = _kGold.withValues(alpha: 0.20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = Path()
      ..moveTo(0, h)
      ..lineTo(0, h * 0.46)
      ..quadraticBezierTo(w * 0.06, h * 0.32, w * 0.09, h * 0.04)
      ..quadraticBezierTo(w * 0.11, h * -0.06, w * 0.13, h * 0.04)
      ..quadraticBezierTo(w * 0.15, h * 0.32, w * 0.21, h * 0.40)
      ..lineTo(w * 0.30, h * 0.40)
      ..quadraticBezierTo(w * 0.32, h * 0.10, w * 0.34, h * -0.06)
      ..quadraticBezierTo(w * 0.36, h * -0.16, w * 0.38, h * -0.06)
      ..quadraticBezierTo(w * 0.40, h * 0.10, w * 0.43, h * 0.40)
      ..lineTo(w * 0.58, h * 0.40)
      ..quadraticBezierTo(w * 0.62, h * 0.14, w * 0.70, h * 0.14)
      ..quadraticBezierTo(w * 0.78, h * 0.14, w * 0.82, h * 0.40)
      ..lineTo(w * 0.84, h * 0.40)
      ..quadraticBezierTo(w * 0.86, h * -0.02, w * 0.90, h * -0.08)
      ..quadraticBezierTo(w * 0.94, h * -0.14, w * 0.97, h * -0.08)
      ..quadraticBezierTo(w * 1.00, h * -0.02, w * 1.00, h * 0.40)
      ..lineTo(w, h)
      ..close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(_) => false;
}
