import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:video_player/video_player.dart';
import 'package:hafez_poems/theme/text_style.dart';
import 'package:hafez_poems/homeScreenUnit/carouselUnit/carousel_flip_media.dart';
import 'package:hafez_poems/homeScreenUnit/carouselUnit/carousel_refresh_button.dart';
import 'package:hafez_poems/homeScreenUnit/carouselUnit/carousel_category_label.dart';
part 'carousel_video_controller.dart';

class CarouselScreenWidget extends StatefulWidget {
  final String initialGhazal;
  final String ghazalNumber;
  final String categoryLabel;
  final String imagePath;
  final String changeButtonIcon;
  final String darkImagePath;
  final Color lightColor;
  final Color darkColor;
  final VoidCallback onChangeGhazal;

  const CarouselScreenWidget({
    super.key,
    required this.initialGhazal,
    required this.ghazalNumber,
    required this.categoryLabel,
    required this.imagePath,
    required this.darkImagePath,
    required this.changeButtonIcon,
    required this.onChangeGhazal,
    required this.lightColor,
    required this.darkColor,
  });

  @override
  State<CarouselScreenWidget> createState() => _CarouselScreenWidgetState();
}

class _CarouselScreenWidgetState extends State<CarouselScreenWidget> {
  double _turns = 0.0;
  late String _displayedGhazal;
  late String _displayedGhazalNumber;
  late String _displayedCategoryLabel;

  VideoPlayerController? _videoController;
  bool _isRefreshing = false;
  bool _showVideo = false;
  bool _videoPlaying = false;
  bool _isDark = false;
  Timer? _completionTimer;
  Future<void>? _videoInitFuture;
  bool _isInitializingVideo = false;

  static const String _flipVideoLight =
      'assets/videos/hafez_flip_light_v2.webm';
  static const String _flipVideoDark = 'assets/videos/hafez_flip_dark_v2.webm';

  @override
  void initState() {
    super.initState();
    _displayedGhazal = _extractFirstFourMesras(widget.initialGhazal);
    _displayedGhazalNumber = widget.ghazalNumber;
    _displayedCategoryLabel = widget.categoryLabel;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (_videoController == null || _isDark != isDark) {
      _isDark = isDark;
      _videoInitFuture = _initFlipVideo(isDark);
    }
  }

  @override
  void didUpdateWidget(covariant CarouselScreenWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialGhazal != widget.initialGhazal) {
      _displayedGhazal = _extractFirstFourMesras(widget.initialGhazal);
    }
    if (oldWidget.ghazalNumber != widget.ghazalNumber) {
      _displayedGhazalNumber = widget.ghazalNumber;
    }
    if (oldWidget.categoryLabel != widget.categoryLabel) {
      _displayedCategoryLabel = widget.categoryLabel;
    }
  }

  void _setVideoController(VideoPlayerController? controller) {
    setState(() => _videoController = controller);
  }

  void _setFlipFinishedState() {
    setState(() {
      _showVideo = false;
      _isRefreshing = false;
    });
  }

  void _setRefreshState({
    required bool isRefreshing,
    required bool showVideo,
    required bool videoPlaying,
  }) {
    setState(() {
      _turns += 1;
      _isRefreshing = isRefreshing;
      _showVideo = showVideo;
      _videoPlaying = videoPlaying;
    });
  }

  void _setRefreshing(bool value) {
    setState(() => _isRefreshing = value);
  }

  @override
  void dispose() {
    _completionTimer?.cancel();
    _videoController?.removeListener(_onVideoTick);
    _videoController?.dispose();
    super.dispose();
  }

  String _extractFirstFourMesras(String text) {
    final normalized = text
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .replaceAll('/', '\n');
    final lines = normalized
        .split('\n')
        .map((e) => e.replaceAll(RegExp(r'[\t\u00A0]+'), ' ').trim())
        .where((e) => e.isNotEmpty)
        .take(4)
        .toList();
    for (final l in lines) {
      debugPrint('MESRA[${l.length}]: ${l.codeUnits}');
    }
    return lines.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final isVideoVisible =
        _showVideo &&
        _videoController != null &&
        _videoController!.value.isInitialized;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? widget.darkColor : widget.lightColor,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: isDark ? 0.25 : 0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: isDark ? 0.28 : 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            child: CarouselFlipMedia(
              isVideoVisible: isVideoVisible,
              videoController: _videoController,
              isDark: isDark,
              imagePath: widget.imagePath,
              darkImagePath: widget.darkImagePath,
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            left: 115,
            bottom: 0,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 380),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) {
                  final slide = Tween<Offset>(
                    begin: const Offset(0, 0.06),
                    end: Offset.zero,
                  ).animate(animation);
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(position: slide, child: child),
                  );
                },
                child: Align(
                  key: ValueKey(_displayedGhazal),
                  alignment: Alignment.centerRight,
                  child: Text(
                    _displayedGhazal,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colorScheme.onSurface,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 11,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CarouselRefreshButton(
                  isRefreshing: _isRefreshing,
                  isDark: isDark,
                  turns: _turns,
                  onTap: _handleRefreshTap,
                ),
                const SizedBox(width: 8),
                CarouselCategoryLabel(
                  categoryLabel: _displayedCategoryLabel,
                  ghazalNumber: _displayedGhazalNumber,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
