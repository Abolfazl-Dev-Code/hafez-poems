import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_audio_controller.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_screen_chapter_data.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_theme.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_floating_controls.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_app_bar.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/biography_scroll_body.dart';
import 'package:hafez_poems/homeScreenUnit/biographyUnit/route_observer_screen.dart';
import 'package:hafez_poems/models/biography_models.dart';

part 'biography_scroll_controls.dart';

class HafezBiographyScreen extends StatefulWidget {
  const HafezBiographyScreen({super.key});

  @override
  State<HafezBiographyScreen> createState() => _HafezBiographyScreenState();
}

class _HafezBiographyScreenState extends State<HafezBiographyScreen>
    with TickerProviderStateMixin, RouteAware, WidgetsBindingObserver {
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
  bool _wasPlayingBeforePause = false;
  bool _wasPlayingBeforeNavigate = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        _wasPlayingBeforePause =
            BiographyAudioController.isPlayingNotifier.value;
        BiographyAudioController.stop();
        break;

      case AppLifecycleState.resumed:
        if (_wasPlayingBeforePause) {
          BiographyAudioController.play();
        }
        break;

      case AppLifecycleState.detached:
        BiographyAudioController.stop();
        break;
    }
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
    _wasPlayingBeforeNavigate =
        BiographyAudioController.isPlayingNotifier.value;
    BiographyAudioController.stop();
  }

  @override
  void didPopNext() {
    if (_wasPlayingBeforeNavigate) {
      BiographyAudioController.play();
    }
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

  @override
  void dispose() {
    _ambientCtrl.dispose();
    _scrollCtrl.dispose();
    _hideControlsTimer?.cancel();
    routeObserver.unsubscribe(this);
    BiographyAudioController.release();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: BiographyColors.night,
        extendBodyBehindAppBar: true,
        appBar: const BiographyAppBar(),
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
                const BiographyAudioButton(),
                const SizedBox(height: 12),
                BiographyAutoScrollButton(
                  autoScrolling: _autoScrolling,
                  onToggle: _toggleAutoScroll,
                ),
              ],
            ),
          ),
        ),
        body: BiographyScrollBody(
          scrollController: _scrollCtrl,
          ambientController: _ambientCtrl,
          particles: _particles,
          chapters: chapters,
          chapterKeys: _chapterKeys,
          chapterVisible: _chapterVisible,
          autoScrolling: _autoScrolling,
          onShowControls: _showControls,
          onStopAutoScroll: _stopAutoScroll,
        ),
      ),
    );
  }
}
