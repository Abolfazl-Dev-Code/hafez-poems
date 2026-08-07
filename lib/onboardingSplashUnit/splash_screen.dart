import 'package:hafez_poems/theme/text_style.dart';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:hafez_poems/theme/color_style.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/bottomNavBar/bottom_nav_bar.dart';
import 'package:hafez_poems/onboardingSplashUnit/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'splash_widgets.dart';
part 'splash_animations.dart';
part 'splash_connection_checker.dart';

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

  @override
  void dispose() {
    _logoController.dispose();
    _pulseController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  void _setConnectionStatus(_ConnectionStatus status) {
    setState(() => _status = status);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final bgColor = isLight ? AppColors.background : AppColors.darkBackground;
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
                      fontFamily: AppTextStyles.fontFamily,
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
