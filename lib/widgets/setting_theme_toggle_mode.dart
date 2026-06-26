import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:hafez_poems/services/theme_reveal_service.dart';

class ThemeModeIconToggle extends StatefulWidget {
  const ThemeModeIconToggle({
    super.key,
    required this.isDarkMode,
    required this.onTap,
  });

  final bool isDarkMode;
  final VoidCallback onTap;

  @override
  State<ThemeModeIconToggle> createState() => _ThemeModeIconToggleState();
}

class _ThemeModeIconToggleState extends State<ThemeModeIconToggle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  // همه انیمیشن‌ها یک بار ساخته می‌شن — بدون rebuild
  late final Animation<double> _rotateAnim; // همیشه 0 → 1
  late final Animation<double> _scaleAnim;
  late final Animation<double> _glowAnim;

  // جهت چرخش: +1.0 = راست (خورشید)، -1.0 = چپ (ماه)
  // این یه متغیر ساده‌ست — نه Animation، نه Tween جدید
  double _rotateDirection = 1.0;

  // آیکون مبدا انیمیشن (قبل از تعویض)
  late bool _animFrom;

  // وقتی tap شروع کرده، از didUpdateWidget جلوگیری می‌کنه
  bool _tapInProgress = false;

  @override
  void initState() {
    super.initState();
    _animFrom = widget.isDarkMode;

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // ساخت یک‌باره همه انیمیشن‌ها
    _rotateAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.5), weight: 45),
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.12), weight: 35),
      TweenSequenceItem(tween: Tween(begin: 1.12, end: 1.0), weight: 20),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

    _glowAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

    // وقتی انیمیشن تموم شد، flag رو پاک کن
    _ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _tapInProgress = false;
      }
    });
  }

  @override
  void didUpdateWidget(ThemeModeIconToggle old) {
    super.didUpdateWidget(old);
    // فقط برای تغییر تم از بیرون (مثل تم سیستم) — نه از tap این دکمه
    if (old.isDarkMode != widget.isDarkMode && !_tapInProgress) {
      if (!_ctrl.isAnimating) {
        // تغییر خارجی: جهت و مبدا رو آپدیت کن و انیمیشن بزن
        _rotateDirection = widget.isDarkMode ? -1.0 : 1.0;
        setState(() => _animFrom = old.isDarkMode);
        _ctrl.forward(from: 0);
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final glowColor = widget.isDarkMode
        ? const Color(0xFF7C4DFF)
        : const Color(0xFFFFB300);

    return GestureDetector(
      onTap: () {
        // ─── جهت چرخش ───────────────────────────────────────────────────────
        // رفتن به تم شب (ماه)  → چرخش چپ  -1.0
        // رفتن به تم روز (خورشید) → چرخش راست +1.0
        // !widget.isDarkMode = مقصد:
        //   مقصد=true  (شب/ماه)   → -1.0
        //   مقصد=false (روز/خورشید) → +1.0
        _rotateDirection = !widget.isDarkMode ? -1.0 : 1.0;

        _tapInProgress = true;
        setState(() => _animFrom = widget.isDarkMode);
        _ctrl.forward(from: 0);

        final box = context.findRenderObject() as RenderBox?;
        final pos =
            box?.localToGlobal(box.size.center(Offset.zero)) ??
            Offset(MediaQuery.of(context).size.width / 2, 100);

        ThemeRevealService.instance.reveal(
          context: context,
          origin: pos,
          toDark: !widget.isDarkMode,
          onSwitch: widget.onTap,
        );
      },
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          // آیکون فعلی:
          //   وقتی انیمیشن اجرا نمی‌شه → همیشه widget.isDarkMode
          //   قبل از نقطه ۵۰٪       → _animFrom (آیکون قدیمی)
          //   بعد از نقطه ۵۰٪       → !_animFrom (آیکون جدید)
          final bool currentIsDark;
          if (!_ctrl.isAnimating) {
            currentIsDark = widget.isDarkMode;
          } else if (_ctrl.value < 0.5) {
            currentIsDark = _animFrom;
          } else {
            currentIsDark = !_animFrom;
          }

          // چرخش واقعی: مقدار 0→1 ضربدر جهت (+1 یا -1) = زاویه کامل
          final double rotationAngle =
              _rotateAnim.value * _rotateDirection * 2 * math.pi;

          return Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.8),
              ),
              boxShadow: [
                BoxShadow(
                  color: glowColor.withValues(alpha: _glowAnim.value * 0.85),
                  blurRadius: 22 + _glowAnim.value * 22,
                  spreadRadius: _glowAnim.value * 5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // پس‌زمینه گرادیان
                  Positioned.fill(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 560),
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 0.85,
                          colors: widget.isDarkMode
                              ? [
                                  const Color(
                                    0xFF2D1B69,
                                  ).withValues(alpha: 0.35),
                                  Colors.transparent,
                                ]
                              : [
                                  const Color(
                                    0xFFFFF3CD,
                                  ).withValues(alpha: 0.5),
                                  Colors.transparent,
                                ],
                        ),
                      ),
                    ),
                  ),

                  // آیکون واحد با چرخش جهت‌دار
                  Transform.scale(
                    scale: _scaleAnim.value,
                    child: Transform.rotate(
                      angle: rotationAngle,
                      child: _buildIcon(isDark: currentIsDark),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIcon({required bool isDark}) {
    return Icon(
      isDark ? Icons.dark_mode_rounded : Icons.wb_sunny_rounded,
      size: 26,
      color: isDark ? const Color(0xFF7C4DFF) : const Color(0xFFFFB300),
    );
  }
}
