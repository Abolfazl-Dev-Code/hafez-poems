import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_spacing.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:hafez_poems/poemsUnit/poems/persian_numbers.dart';
import 'package:hafez_poems/theme/color_style.dart';
import 'infinite_background_carousel.dart';
import 'share_image_capture_service.dart';
import 'verse_background_theme.dart';

class ImageSharePreview extends StatefulWidget {
  final String verseText;
  final String poemTitle;

  const ImageSharePreview({
    super.key,
    required this.verseText,
    required this.poemTitle,
  });

  @override
  State<ImageSharePreview> createState() => _ImageSharePreviewState();
}

class _ImageSharePreviewState extends State<ImageSharePreview> {
  late final List<GlobalKey> _repaintKeys = List.generate(
    VerseBackgroundThemes.length,
    (_) => GlobalKey(),
  );

  int _selectedBackground = 0;

  bool _isSharing = false;
  double _shareProgress = 0;

  Future<void> _share() async {
    if (_isSharing) return;

    setState(() {
      _isSharing = true;
      _shareProgress = 0;
    });

    try {
      await ShareImageCaptureService.shareImage(
        _repaintKeys[_selectedBackground],
        onProgress: (progress) {
          if (!mounted) return;

          setState(() {
            _shareProgress = progress;
          });
        },
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
          _shareProgress = 0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.black,

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          centerTitle: true,

          leading: Padding(
            padding: const EdgeInsets.only(right: 18),
            child: IconButton(
              iconSize: 26,
              color: Colors.white,
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),

          title: const Text('اشتراک گذاری مصرع دلخواه'),
        ),

        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: InfiniteBackgroundCarousel(
                  verseText: widget.verseText,
                  poemTitle: widget.poemTitle,
                  repaintKeys: _repaintKeys,
                  onBackgroundChanged: (index) {
                    setState(() {
                      _selectedBackground = index;
                    });
                  },
                ),
              ),

              const SizedBox(height: 16),

              CarouselDots(selectedIndex: _selectedBackground),

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: Stack(
                    children: [
                      if (_isSharing)
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: AppRadius.mdRadius,
                            child: LinearProgressIndicator(
                              value: _shareProgress,
                              minHeight: 54,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest
                                  .withValues(alpha: 0.35),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.green,
                              ),
                            ),
                          ),
                        ),

                      Positioned.fill(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isSharing
                                ? Colors.transparent
                                : Theme.of(context).colorScheme.primary,

                            shadowColor: Colors.transparent,

                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadius.mdRadius,
                            ),
                          ),

                          onPressed: _isSharing ? null : _share,

                          icon: _isSharing
                              ? null
                              : const Icon(Icons.ios_share_rounded),

                          label: Text(
                            _isSharing
                                ? '${(_shareProgress * 100).round()}٪'
                                      .toPersianNumbers()
                                : 'اشتراک‌گذاری',
                            style: TextStyle(
                              color: _isSharing
                                  ? AppColors.textPrimary
                                  : Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
