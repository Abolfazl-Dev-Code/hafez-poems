import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_audio_controller.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_screen_chapter_data.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_screen_fal.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_screen_hero_animation.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_screen_story.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_theme.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/route_observer_screen.dart';
import 'package:hafez_poems/models/biography_models.dart';

class HafezBiographyScreen extends StatefulWidget {
  const HafezBiographyScreen({super.key});

  @override
  State<HafezBiographyScreen> createState() => _HafezBiographyScreenState();
}

class _HafezBiographyScreenState extends State<HafezBiographyScreen>
    with TickerProviderStateMixin, RouteAware {
  late final AnimationController _ambientCtrl;
  late final ScrollController _scrollCtrl;

  bool _autoScrolling = false;

  bool _controlsVisible = true;
  Timer? _hideControlsTimer;
  static const _hideControlsDelay = Duration(seconds: 3);
  static const _controlsFadeDuration = Duration(milliseconds: 450);

  final List<bool> _chapterVisible = List.filled(chapters.length, false);
  final List<GlobalKey> _chapterKeys = List.generate(
    chapters.length,
    (_) => GlobalKey(),
  );

  late final List<Particle> _particles;

  @override
  void initState() {
    super.initState();

    _ambientCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _scrollCtrl = ScrollController()..addListener(_onScroll);

    BiographyAudioController.play();

    final random = Random();
    _particles = List.generate(70, (i) {
      return Particle(
        startX: random.nextDouble(),
        phase: random.nextDouble(),
        drift: random.nextDouble() * 60 - 30,
        size: random.nextDouble() * 2.2 + 0.6,
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkChapterVisibility();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPushNext() {
    BiographyAudioController.stop();
  }

  @override
  void didPopNext() {
    BiographyAudioController.play();
  }

  void _showControls() {
    _hideControlsTimer?.cancel();
    if (!_controlsVisible && mounted) {
      setState(() => _controlsVisible = true);
    }
  }

  void _scheduleHideControls() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(_hideControlsDelay, () {
      if (mounted) setState(() => _controlsVisible = false);
    });
  }

  Future<void> _startAutoScroll() async {
    if (!mounted || !_scrollCtrl.hasClients) return;

    final max = _scrollCtrl.position.maxScrollExtent;
    final current = _scrollCtrl.offset;

    if (max <= 0 || current >= max) return;

    final remaining = max - current;
    const double scrollSpeed = 30.0;

    final ms = (remaining / scrollSpeed * 1000).round().clamp(3000, 120000);

    setState(() => _autoScrolling = true);
    _scheduleHideControls();

    try {
      await _scrollCtrl.animateTo(
        max,
        duration: Duration(milliseconds: ms),
        curve: Curves.linear,
      );
    } catch (_) {}

    if (mounted) setState(() => _autoScrolling = false);
  }

  void _stopAutoScroll() {
    if (!_scrollCtrl.hasClients) return;
    _scrollCtrl.jumpTo(_scrollCtrl.offset);
    if (mounted) setState(() => _autoScrolling = false);
    _showControls();
  }

  void _toggleAutoScroll() {
    HapticFeedback.lightImpact();
    _autoScrolling ? _stopAutoScroll() : _startAutoScroll();
  }

  void _onScroll() => _checkChapterVisibility();

  void _checkChapterVisibility() {
    final screenH = MediaQuery.of(context).size.height;
    bool changed = false;

    for (int i = 0; i < chapters.length; i++) {
      if (_chapterVisible[i]) continue;

      final ctx = _chapterKeys[i].currentContext;
      if (ctx == null) continue;

      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null) continue;

      final posY = box.localToGlobal(Offset.zero).dy;

      if (posY < screenH * 0.88) {
        _chapterVisible[i] = true;
        changed = true;
      }
    }

    if (changed && mounted) setState(() {});
  }

  Widget _buildAudioControls() {
    return ValueListenableBuilder<bool>(
      valueListenable: BiographyAudioController.isPlayingNotifier,
      builder: (context, isPlaying, _) {
        return FloatingActionButton(
          heroTag: 'audio_btn',
          backgroundColor: BiographyColors.panel,
          onPressed: () {
            isPlaying
                ? BiographyAudioController.pause()
                : BiographyAudioController.play();
          },
          child: Icon(
            isPlaying ? Icons.volume_up : Icons.volume_off,
            color: BiographyColors.gold,
          ),
        );
      },
    );
  }

  Widget _buildControls() {
    return FloatingActionButton(
      heroTag: 'scroll_btn',
      onPressed: _toggleAutoScroll,
      backgroundColor: BiographyColors.panel,
      child: Icon(
        _autoScrolling ? Icons.pause : Icons.play_arrow,
        color: BiographyColors.gold,
      ),
    );
  }

  @override
  void dispose() {
    _ambientCtrl.dispose();
    _scrollCtrl.dispose();
    _hideControlsTimer?.cancel();
    routeObserver.unsubscribe(this);
    BiographyAudioController.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: BiographyColors.night,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: BiographyColors.gold,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: AnimatedOpacity(
          opacity: _controlsVisible ? 1 : 0,
          duration: _controlsFadeDuration,
          curve: Curves.easeInOut,
          child: IgnorePointer(
            ignoring: !_controlsVisible,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAudioControls(),
                const SizedBox(height: 12),
                _buildControls(),
              ],
            ),
          ),
        ),

        body: NotificationListener<ScrollNotification>(
          onNotification: (n) {
            if (n is ScrollStartNotification && n.dragDetails != null) {
              _showControls();
              if (_autoScrolling) _stopAutoScroll();
            }
            return false;
          },
          child: SingleChildScrollView(
            controller: _scrollCtrl,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                HeroAnimationBiography(
                  animation: _ambientCtrl,
                  particles: _particles,
                ),
                StoryBiography(
                  chapters: chapters,
                  chapterKeys: _chapterKeys,
                  chapterVisible: _chapterVisible,
                ),
                const FalBiography(),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
