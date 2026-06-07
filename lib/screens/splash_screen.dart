import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hafez_poems/screens/onboarding_screen.dart';
import 'package:hafez_poems/screens/bottom_nav_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _pulseController;
  late final AnimationController _statusController;

  late final Animation<double> _logoFade;
  late final Animation<Offset> _logoSlide;
  late final Animation<double> _logoScale;
  late final Animation<double> _pulse;
  late final Animation<double> _statusFade;
  late final Animation<Offset> _statusSlide;

  _ConnectionStatus? _status;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSequence();
  }

  void _setupAnimations() {
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _logoFade = CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    _logoSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
        );

    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _pulse =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.08), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.0), weight: 50),
        ]).animate(
          CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
        );

    _statusController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _statusFade = CurvedAnimation(
      parent: _statusController,
      curve: Curves.easeOut,
    );

    _statusSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _statusController,
            curve: Curves.easeOutCubic,
          ),
        );
  }

  Future<bool> _isVpnActive() async {
    try {
      final interfaces = await NetworkInterface.list(
        includeLoopback: false,
        type: InternetAddressType.any,
      );

      for (final interface in interfaces) {
        final name = interface.name.toLowerCase();

        if (name.contains('tun') ||
            name.contains('ppp') ||
            name.contains('pptp') ||
            name.contains('ipsec') ||
            name.contains('utun') ||
            name.contains('wg')) {
          return true;
        }
      }
    } catch (_) {}

    return false;
  }

  Future<bool> _hasInternetAccess() async {
    HttpClient? client;
    try {
      client = HttpClient()..connectionTimeout = const Duration(seconds: 5);

      final request = await client.getUrl(
        Uri.parse('https://clients3.google.com/generate_204'),
      );

      final response = await request.close();
      return response.statusCode == 204 || response.statusCode == 200;
    } catch (_) {
      return false;
    } finally {
      client?.close(force: true);
    }
  }

  Future<_ConnectionStatus> _checkConnection() async {
    try {
      final result = await Connectivity().checkConnectivity();

      if (result.contains(ConnectivityResult.none)) {
        return _ConnectionStatus.offline;
      }

      if (result.contains(ConnectivityResult.vpn)) {
        return _ConnectionStatus.vpn;
      }

      if (await _isVpnActive()) {
        return _ConnectionStatus.vpn;
      }

      final hasInternet = await _hasInternetAccess();
      return hasInternet ? _ConnectionStatus.online : _ConnectionStatus.offline;
    } catch (_) {
      return _ConnectionStatus.offline;
    }
  }

  Future<void> _startSequence() async {
    await _logoController.forward();

    _pulseController.repeat();
    final status = await _checkConnection();

    _pulseController.stop();
    await _pulseController.animateTo(1.0);

    if (!mounted) return;
    setState(() => _status = status);

    await _statusController.forward();

    await Future.delayed(
      status == _ConnectionStatus.vpn
          ? const Duration(seconds: 2)
          : const Duration(milliseconds: 1500),
    );

    await _navigate();
  }

  Future<void> _navigate() async {
    if (_navigated || !mounted) return;
    _navigated = true;

    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seen_onboarding') ?? false;

    Get.offAll(
      () => seenOnboarding ? const BottomNavBar() : const OnboardingScreen(),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _pulseController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    final bgColor = isLight ? const Color(0xFFE1D4C2) : const Color(0xFF1E1712);
    final primaryColor = isLight
        ? const Color(0xFF6D4C41)
        : const Color(0xFFD7B896);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -80,
            child: _DecorativeCircle(
              color: primaryColor.withValues(alpha: 0.06),
              size: 300,
            ),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            child: _DecorativeCircle(
              color: primaryColor.withValues(alpha: 0.04),
              size: 250,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _logoController,
                    _pulseController,
                  ]),
                  builder: (context, _) {
                    return FadeTransition(
                      opacity: _logoFade,
                      child: SlideTransition(
                        position: _logoSlide,
                        child: Transform.scale(
                          scale: _logoScale.value * _pulse.value,
                          child: _LogoWidget(
                            primaryColor: primaryColor,
                            isLight: isLight,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 48),
                AnimatedBuilder(
                  animation: _statusController,
                  builder: (context, _) {
                    if (_status == null) return const SizedBox(height: 60);

                    return FadeTransition(
                      opacity: _statusFade,
                      child: SlideTransition(
                        position: _statusSlide,
                        child: _StatusWidget(
                          status: _status!,
                          primaryColor: primaryColor,
                          isLight: isLight,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 48,
            left: 24,
            right: 24,
            child: AnimatedBuilder(
              animation: _logoFade,
              builder: (_, _) {
                return Opacity(
                  opacity: _logoFade.value,
                  child: Text(
                    'الا یا ایها الساقی ادر کاساً و ناولها',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'vazir',
                      color: primaryColor.withValues(alpha: 0.5),
                      letterSpacing: 0.5,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  final Color color;
  final double size;

  const _DecorativeCircle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _LogoWidget extends StatelessWidget {
  final Color primaryColor;
  final bool isLight;

  const _LogoWidget({required this.primaryColor, required this.isLight});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: primaryColor.withValues(alpha: 0.1),
            border: Border.all(
              color: primaryColor.withValues(alpha: 0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.15),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Icon(Icons.menu_book_rounded, size: 52, color: primaryColor),
        ),
        const SizedBox(height: 20),
        Text(
          'حافظ',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: 36,
            fontFamily: 'vazir',
            fontWeight: FontWeight.bold,
            color: primaryColor,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'دیوان شعر',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'vazir',
            color: primaryColor.withValues(alpha: 0.6),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class _StatusWidget extends StatelessWidget {
  final _ConnectionStatus status;
  final Color primaryColor;
  final bool isLight;

  const _StatusWidget({
    required this.status,
    required this.primaryColor,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    final (icon, message, color) = switch (status) {
      _ConnectionStatus.online => (
        Icons.check_circle_outline_rounded,
        'اتصال برقرار است',
        const Color(0xFF2E7D32),
      ),
      _ConnectionStatus.offline => (
        Icons.wifi_off_rounded,
        'بدون اینترنت — اشعار آفلاین در دسترس‌اند',
        const Color(0xFFE65100),
      ),
      _ConnectionStatus.vpn => (
        Icons.vpn_lock_rounded,
        'برای کارکرد صحیح برنامه لطفا VPN خود را خاموش کنید',
        const Color(0xFF1565C0),
      ),
    };

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isLight ? 0.08 : 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              message,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'vazir',
                color: color,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _ConnectionStatus { online, offline, vpn }
