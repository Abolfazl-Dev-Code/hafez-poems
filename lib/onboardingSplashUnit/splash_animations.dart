part of 'splash_screen.dart';

extension _SplashAnimations on _SplashScreenState {
  void _setupAnimations() {
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _logoFade = CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    _logoSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
        );

    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _pulse =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.08), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.0), weight: 50),
        ]).animate(
          CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
        );

    _statusController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _statusFade = CurvedAnimation(
      parent: _statusController,
      curve: Curves.easeOut,
    );

    _statusSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _statusController,
            curve: Curves.easeOutCubic,
          ),
        );
  }
}
