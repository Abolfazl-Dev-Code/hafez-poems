import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/text_style.dart';

class CarouselScreenWidget extends StatefulWidget {
  final String initialGhazal;
  final String imagePath;
  final String changeButtonIcon;
  final String darkImagePath; // عکس تم شب  ← اضافه شد
  final Color lightColor;
  final Color darkColor;
  final VoidCallback onChangeGhazal;

  const CarouselScreenWidget({
    super.key,
    required this.initialGhazal,
    required this.imagePath,
    required this.darkImagePath, // ← اضافه شد
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

  @override
  void initState() {
    super.initState();
    _displayedGhazal = _extractFirstFourMesras(widget.initialGhazal);
  }

  @override
  void didUpdateWidget(covariant CarouselScreenWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialGhazal != widget.initialGhazal) {
      _displayedGhazal = _extractFirstFourMesras(widget.initialGhazal);
    }
  }

  String _extractFirstFourMesras(String text) {
    final normalized = text.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

    final lines = normalized
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .take(4)
        .toList();

    return lines.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? widget.darkColor : widget.lightColor,
        borderRadius: BorderRadius.circular(20),
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
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      isDark ? widget.darkImagePath : widget.imagePath,
                      fit: BoxFit.cover,
                    ),
                    if (isDark)
                      Container(
                        color: const Color(0xFF2A211B).withValues(alpha: 0.0),
                      ),
                  ],
                ),
              ),
            ),
          ),
          //* text edit
          Positioned(
            top: 12,
            right: 12,
            left: 120,
            bottom: 0,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Text(
                _displayedGhazal,
                textAlign: TextAlign.right,
                softWrap: true,
                overflow: TextOverflow.visible,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colorScheme.onSurface,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 11,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () async {
                  setState(() {
                    _turns += 1;
                  });

                  await Future.delayed(const Duration(milliseconds: 600));

                  if (mounted) {
                    widget.onChangeGhazal();
                  }
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(50),
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
                    duration: const Duration(milliseconds: 450),
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
        ],
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:hafez_poems/theme/text_style.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:video_player/video_player.dart';

// class CarouselScreenWidget extends StatefulWidget {
//   final String initialGhazal;
//   final String imagePath;
//   final String changeButtonIcon;
//   final String darkImagePath;
//   final Color lightColor;
//   final Color darkColor;
//   final VoidCallback onChangeGhazal;

//   const CarouselScreenWidget({
//     super.key,
//     required this.initialGhazal,
//     required this.imagePath,
//     required this.darkImagePath,
//     required this.changeButtonIcon,
//     required this.onChangeGhazal,
//     required this.lightColor,
//     required this.darkColor,
//   });

//   @override
//   State<CarouselScreenWidget> createState() => _CarouselScreenWidgetState();
// }

// class _CarouselScreenWidgetState extends State<CarouselScreenWidget>
//     with TickerProviderStateMixin {
//   late String _displayedGhazal;
//   bool _isAnimating = false;
//   bool _isVideoPlaying = false;
//   double _turns = 0.0;

//   VideoPlayerController? _videoController;
//   bool _videoReady = false;

//   AudioPlayer? _audioPlayer;
//   bool _audioReady = false;

//   @override
//   void initState() {
//     super.initState();
//     _displayedGhazal = _extractFirstFourMesras(widget.initialGhazal);
//     _initVideo();
//     _initAudio();
//   }

//   Future<void> _initVideo() async {
//     final controller = VideoPlayerController.asset(
//       'assets/videos/hafez_flip.mp4',
//     );
//     try {
//       await controller.initialize();
//       await controller.setLooping(false);
//       await controller.setVolume(0.0);
//       if (!mounted) {
//         controller.dispose();
//         return;
//       }
//       setState(() {
//         _videoController = controller;
//         _videoReady = true;
//       });
//     } catch (e) {
//       debugPrint('❌ خطا در لود ویدیو: $e');
//       controller.dispose();
//     }
//   }

//   Future<void> _initAudio() async {
//     final player = AudioPlayer();
//     try {
//       await player.setAsset('assets/sounds/page_flip.mp3');
//       if (!mounted) {
//         player.dispose();
//         return;
//       }
//       _audioPlayer = player;
//       _audioReady = true;
//     } catch (e) {
//       debugPrint('❌ خطا در لود صدا: $e');
//       player.dispose();
//     }
//   }

//   @override
//   void dispose() {
//     _videoController?.dispose();
//     _audioPlayer?.dispose();
//     super.dispose();
//   }

//   @override
//   void didUpdateWidget(covariant CarouselScreenWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.initialGhazal != widget.initialGhazal) {
//       setState(() {
//         _displayedGhazal = _extractFirstFourMesras(widget.initialGhazal);
//       });
//     }
//   }

//   String _extractFirstFourMesras(String text) {
//     final normalized = text.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
//     final lines = normalized
//         .split('\n')
//         .map((e) => e.trim())
//         .where((e) => e.isNotEmpty)
//         .take(4)
//         .toList();
//     return lines.join('\n');
//   }

//   Future<void> _onRefreshTap() async {
//     if (_isAnimating || !_videoReady || _videoController == null) return;

//     final controller = _videoController!;
//     final videoDuration = controller.value.duration;
//     if (videoDuration == Duration.zero) return;

//     setState(() {
//       _isAnimating = true;
//       _turns += 1;
//     });

//     // ابتدا ویدیو رو به فریم اول برگردون
//     await controller.seekTo(Duration.zero);

//     // حالا عکس رو fade کن و ویدیو رو نشون بده
//     setState(() => _isVideoPlaying = true);

//     // کمی صبر کن تا ویدیو آماده رندر بشه، بعد پخش کن
//     await Future.delayed(const Duration(milliseconds: 50));

//     // پخش ویدیو و صدا همزمان
//     await Future.wait([
//       controller.play(),
//       if (_audioReady && _audioPlayer != null)
//         _audioPlayer!.seek(Duration.zero).then((_) => _audioPlayer!.play()),
//     ]);

//     // نصف مدت ویدیو: غزل عوض میشه
//     final half = Duration(milliseconds: videoDuration.inMilliseconds ~/ 2);
//     await Future.delayed(half);
//     if (mounted) widget.onChangeGhazal();

//     // صبر برای اتمام ویدیو
//     await Future.delayed(half);

//     if (mounted) {
//       // عکس برمیگرده
//       setState(() {
//         _isVideoPlaying = false;
//         _isAnimating = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//     final isDark = theme.brightness == Brightness.dark;

//     return Container(
//       decoration: BoxDecoration(
//         color: isDark ? widget.darkColor : widget.lightColor,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: theme.dividerColor.withValues(alpha: isDark ? 0.25 : 0.18),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: theme.shadowColor.withValues(alpha: isDark ? 0.28 : 0.08),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           // ─── ناحیه تصویر / ویدیو ───
//           Positioned(
//             top: 0,
//             left: 0,
//             bottom: 0,
//             child: SizedBox(
//               width: 145,
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(20),
//                   topLeft: Radius.circular(20),
//                 ),
//                 child: Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     // لایه ۱: ویدیو (همیشه زیر، آماده پخش)
//                     if (_videoReady && _videoController != null)
//                       FittedBox(
//                         fit: BoxFit.cover,
//                         child: SizedBox(
//                           width: _videoController!.value.size.width,
//                           height: _videoController!.value.size.height,
//                           child: VideoPlayer(_videoController!),
//                         ),
//                       ),

//                     // لایه ۲: عکس استاتیک (روی ویدیو، موقع پخش fade میشه)
//                     AnimatedOpacity(
//                       opacity: _isVideoPlaying ? 0.0 : 1.0,
//                       duration: const Duration(milliseconds: 80),
//                       child: Image.asset(
//                         isDark ? widget.darkImagePath : widget.imagePath,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           // ─── متن غزل ───
//           Positioned(
//             top: 12,
//             right: 12,
//             left: 120,
//             bottom: 0,
//             child: AnimatedSwitcher(
//               duration: const Duration(milliseconds: 400),
//               transitionBuilder: (child, animation) =>
//                   FadeTransition(opacity: animation, child: child),
//               child: Text(
//                 _displayedGhazal,
//                 key: ValueKey(_displayedGhazal),
//                 textAlign: TextAlign.right,
//                 softWrap: true,
//                 overflow: TextOverflow.visible,
//                 style: AppTextStyles.bodyMedium.copyWith(
//                   color: colorScheme.onSurface,
//                   height: 1.4,
//                   fontWeight: FontWeight.w500,
//                   fontSize: 13,
//                 ),
//               ),
//             ),
//           ),

//           // ─── دکمه رفرش ───
//           Positioned(
//             bottom: 8,
//             right: 11,
//             child: Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(50),
//                 onTap: _onRefreshTap,
//                 child: AnimatedOpacity(
//                   opacity: _isAnimating ? 0.5 : 1.0,
//                   duration: const Duration(milliseconds: 200),
//                   child: Container(
//                     width: 30,
//                     height: 30,
//                     decoration: BoxDecoration(
//                       color: colorScheme.primary,
//                       borderRadius: BorderRadius.circular(50),
//                       boxShadow: [
//                         BoxShadow(
//                           color: colorScheme.primary.withValues(
//                             alpha: isDark ? 0.28 : 0.22,
//                           ),
//                           blurRadius: 8,
//                           offset: const Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     alignment: Alignment.center,
//                     child: AnimatedRotation(
//                       turns: _turns,
//                       duration: const Duration(milliseconds: 450),
//                       curve: Curves.easeInOutCubic,
//                       child: Icon(
//                         Icons.refresh,
//                         size: 22,
//                         color: colorScheme.onPrimary,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
