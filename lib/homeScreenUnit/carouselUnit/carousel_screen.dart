import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:video_player/video_player.dart';
import 'package:hafez_poems/theme/text_style.dart';

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

  Future<void> _initFlipVideo(bool isDark) async {
    if (_isInitializingVideo) return;
    _isInitializingVideo = true;
    try {
      _videoController?.removeListener(_onVideoTick);
      await _videoController?.dispose();
      _videoController = null;

      final asset = isDark ? _flipVideoDark : _flipVideoLight;
      final controller = VideoPlayerController.asset(asset);
      await controller.initialize();
      await controller.setVolume(0);
      controller.addListener(_onVideoTick);
      if (!mounted) {
        controller.dispose();
        return;
      }
      setState(() => _videoController = controller);
    } catch (e) {
      debugPrint('Hafez flip video failed to load: $e');
    } finally {
      _isInitializingVideo = false;
    }
  }

  void _onVideoTick() {
    if (!_videoPlaying || !_showVideo) return;
    final controller = _videoController;
    if (controller == null) return;
    final value = controller.value;
    if (!value.isInitialized || value.duration == Duration.zero) return;

    if (!value.isPlaying && value.position >= value.duration) {
      _videoPlaying = false;
      _onFlipFinished();
    }
  }

  void _onFlipFinished() {
    _completionTimer?.cancel();
    _completionTimer = null;
    if (!mounted || !_isRefreshing) return;

    widget.onChangeGhazal();
    setState(() {
      _showVideo = false;
      _isRefreshing = false;
    });
    _videoController?.seekTo(Duration.zero);
  }

  Future<void> _handleRefreshTap() async {
    if (_isRefreshing) return;
    if (_videoController == null && _videoInitFuture != null) {
      await _videoInitFuture!.timeout(
        const Duration(milliseconds: 1200),
        onTimeout: () {},
      );
    }

    final controller = _videoController;
    final videoReady = controller != null && controller.value.isInitialized;

    setState(() {
      _turns += 1;
      _isRefreshing = true;
      _showVideo = videoReady;
      _videoPlaying = false;
    });

    if (!videoReady) {
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      widget.onChangeGhazal();
      setState(() => _isRefreshing = false);
      return;
    }

    await controller.seekTo(Duration.zero);
    await Future.delayed(const Duration(milliseconds: 100));
    _videoPlaying = true;
    await controller.play();

    final duration = controller.value.duration;
    _completionTimer?.cancel();
    _completionTimer = Timer(
      duration + const Duration(milliseconds: 500),
      _onFlipFinished,
    );
  }

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
            child: SizedBox(
              width: 145,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: isVideoVisible
                    ? _buildFlipVideo(_videoController!)
                    : ClipRRect(
                        key: const ValueKey('hafez_static_image'),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          topLeft: Radius.circular(15),
                        ),
                        child: SizedBox.expand(
                          child: Image.asset(
                            isDark ? widget.darkImagePath : widget.imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
              ),
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
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: AppRadius.pillRadius,
                    onTap: _isRefreshing ? null : _handleRefreshTap,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _isRefreshing ? 0.55 : 1.0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: AppRadius.pillRadius,
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withValues(
                                alpha: isDark ? 0.28 : 0.22,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: AnimatedRotation(
                          turns: _turns,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOutCubic,
                          child: Icon(
                            Icons.refresh,
                            size: 22,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 320),
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
                  child: Column(
                    key: ValueKey(
                      '$_displayedCategoryLabel$_displayedGhazalNumber',
                    ),
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'دیوان حافظ',
                        textAlign: TextAlign.right,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$_displayedCategoryLabel $_displayedGhazalNumber',
                        textAlign: TextAlign.right,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.55),
                          fontWeight: FontWeight.w400,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
