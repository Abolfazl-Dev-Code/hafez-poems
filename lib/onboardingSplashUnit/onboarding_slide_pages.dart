import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hafez_poems/models/onboarding_slide_data.dart';

class OnboardingPage extends StatelessWidget {
  final SlideData slide;
  final Color accent;
  final Animation<double> iconScale;
  final Animation<double> breatheScale;
  final Animation<double> contentFade;
  final Animation<Offset> contentSlide;
  final AnimationController breatheController;

  const OnboardingPage({
    super.key,
    required this.slide,
    required this.accent,
    required this.iconScale,
    required this.breatheScale,
    required this.contentFade,
    required this.contentSlide,
    required this.breatheController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: iconScale,
            child: AnimatedBuilder(
              animation: breatheController,
              builder: (_, _) => Transform.scale(
                scale: breatheScale.value,
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
            opacity: contentFade,
            child: SlideTransition(
              position: contentSlide,
              child: Text(
                slide.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'vazir',
                  fontWeight: FontWeight.bold,
                  color: accent,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FadeTransition(
            opacity: contentFade,
            child: SlideTransition(
              position: contentSlide,
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
