import 'package:flutter/material.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_screen_hero_animation.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_screen_story.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_screen_fal.dart';
import 'package:hafez_poems/models/biography_models.dart';

class BiographyScrollBody extends StatelessWidget {
  final ScrollController scrollController;
  final AnimationController ambientController;
  final List<Particle> particles;
  final List chapters;
  final List<GlobalKey> chapterKeys;
  final List<bool> chapterVisible;
  final bool autoScrolling;
  final VoidCallback onShowControls;
  final VoidCallback onStopAutoScroll;

  const BiographyScrollBody({
    super.key,
    required this.scrollController,
    required this.ambientController,
    required this.particles,
    required this.chapters,
    required this.chapterKeys,
    required this.chapterVisible,
    required this.autoScrolling,
    required this.onShowControls,
    required this.onStopAutoScroll,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (n is ScrollStartNotification && n.dragDetails != null) {
          onShowControls();
          if (autoScrolling) onStopAutoScroll();
        }
        return false;
      },
      child: SingleChildScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            HeroAnimationBiography(
              animation: ambientController,
              particles: particles,
            ),
            StoryBiography(
              chapters: chapters,
              chapterKeys: chapterKeys,
              chapterVisible: chapterVisible,
            ),
            const FalBiography(),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
