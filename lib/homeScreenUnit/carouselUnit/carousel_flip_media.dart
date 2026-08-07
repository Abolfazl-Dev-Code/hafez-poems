import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CarouselFlipMedia extends StatelessWidget {
  final bool isVideoVisible;
  final VideoPlayerController? videoController;
  final bool isDark;
  final String imagePath;
  final String darkImagePath;

  const CarouselFlipMedia({
    super.key,
    required this.isVideoVisible,
    required this.videoController,
    required this.isDark,
    required this.imagePath,
    required this.darkImagePath,
  });

  Widget _buildFlipVideo(VideoPlayerController controller) {
    return ClipRRect(
      key: const ValueKey('hafez_flip_video'),
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(15),
        topLeft: Radius.circular(15),
      ),
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: controller.value.size.width,
            height: controller.value.size.height,
            child: VideoPlayer(controller),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 145,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: isVideoVisible
            ? _buildFlipVideo(videoController!)
            : ClipRRect(
                key: const ValueKey('hafez_static_image'),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  topLeft: Radius.circular(15),
                ),
                child: SizedBox.expand(
                  child: Image.asset(
                    isDark ? darkImagePath : imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
      ),
    );
  }
}
