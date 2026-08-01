import 'package:hafez_poems/theme/text_style.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_screen_particle_painter.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_screen_skyline_painter.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_theme.dart';
import 'package:hafez_poems/models/biography_models.dart';

class HeroAnimationBiography extends StatelessWidget {
  final Animation<double> animation;
  final List<Particle> particles;

  const HeroAnimationBiography({
    super.key,
    required this.animation,
    required this.particles,
  });

  @override
  Widget build(BuildContext context) {
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
                colors: [Color(0x22D4AF37), Color(0xFF0C1029)],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: animation,
            builder: (_, _) {
              return CustomPaint(
                size: Size(size.width, size.height),
                painter: ParticlePainterBiography(particles, animation.value),
              );
            },
          ),
          Positioned(
            top: size.height * 0.08,
            right: size.width * 0.12,
            child: AnimatedBuilder(
              animation: animation,
              builder: (_, _) {
                final glow = 0.5 + 0.5 * sin(animation.value * 2 * pi);

                return Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [Color(0xFFFFF9E3), Color(0xFFD4AF37)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFFD4AF37,
                        ).withValues(alpha: 0.35 + 0.35 * glow),
                        blurRadius: 40 + 30 * glow,
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
              painter: SkylinePainter(),
            ),
          ),
          Positioned(
            bottom: size.height * 0.30,
            left: 24,
            right: 24,
            child: Column(
              children: [
                const Text(
                  'قصهٔ یک نام',
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 4,
                    color: Color(0xFFD4AF37),
                  ),
                ),
                const SizedBox(height: 14),

                const Text(
                  'حافظ',
                  style: TextStyle(
                    fontSize: 84,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFF3ECD9),
                  ),
                ),

                const SizedBox(height: 40),

                Transform.translate(
                  offset: const Offset(0, -30),
                  child: Text(
                    'خواجه شمس‌الدین محمد\nزبان غزل پارسی و صدای جانِ شیراز',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 13.5,
                      color: BiographyColors.cream.withValues(alpha: 0.60),
                      height: 1.9,
                    ),
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
              animation: animation,
              builder: (_, _) {
                final bob = sin(animation.value * 2 * pi * 1.5) * 6;

                return Transform.translate(
                  offset: Offset(0, bob),
                  child: Column(
                    children: const [
                      Text(
                        'برای آغاز سفر به پایین بروید',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0x99C9A227),
                        ),
                      ),
                      SizedBox(height: 6),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Color(0x99C9A227),
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
}
