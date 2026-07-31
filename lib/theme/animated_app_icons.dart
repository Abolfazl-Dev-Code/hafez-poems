import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedAppIcon extends StatefulWidget {
  const AnimatedAppIcon({
    super.key,
    required this.asset,
    this.size = 24,
    this.color,
    this.secondaryColor,
    this.strokeWidth,
    this.fit = BoxFit.contain,
    this.scale = 1,
    this.repeat = false,
    this.animateOnTap = true,
    this.animateOnSelected = true,
    this.selected = false,
    this.autoplay = false,
    this.speed = 1,
    this.tapDelay = Duration.zero,
    this.onTap,
  });

  final String asset;
  final double size;
  final double scale;
  final Color? color;
  final Color? secondaryColor;
  final double? strokeWidth;
  final BoxFit fit;
  final bool repeat;
  final bool animateOnTap;
  final bool animateOnSelected;
  final bool selected;
  final bool autoplay;
  final double speed;
  final Duration tapDelay;
  final VoidCallback? onTap;

  @override
  State<AnimatedAppIcon> createState() => AnimatedAppIconState();
}

class AnimatedAppIconState extends State<AnimatedAppIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didUpdateWidget(covariant AnimatedAppIcon oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.animateOnSelected && !oldWidget.selected && widget.selected) {
      play();
    } else if (widget.animateOnSelected &&
        oldWidget.selected &&
        !widget.selected) {
      reverseToStart();
    }
  }

  Future<void> play() async {
    if (!_loaded) return;
    _controller.reset();
    if (widget.repeat) {
      _controller.repeat();
    } else {
      await _controller.forward();
    }
  }

  Future<void> reverseToStart() async {
    if (!_loaded) return;
    if (widget.repeat) {
      _controller.stop();
      _controller.value = 0;
      return;
    }
    await _controller.reverse();
  }

  void stop() {
    if (!_loaded) return;
    _controller.stop();
  }

  void reset() {
    if (!_loaded) return;
    _controller.reset();
  }

  Future<void> _handleTap() async {
    if (widget.animateOnTap) {
      play();
    }
    if (widget.tapDelay > Duration.zero) {
      await Future.delayed(widget.tapDelay);
    }
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final delegates = <ValueDelegate>[
      if (widget.secondaryColor != null) ...[
        if (widget.color != null)
          ValueDelegate.color(const [
            '**',
            '.primary',
            'Color',
          ], value: widget.color!),
        ValueDelegate.color(const [
          '**',
          '.secondary',
          'Color',
        ], value: widget.secondaryColor!),
      ],
      if (widget.strokeWidth != null)
        ValueDelegate.strokeWidth(const ['**'], value: widget.strokeWidth!),
    ];

    Widget lottie = Lottie.asset(
      widget.asset,
      controller: _controller,
      width: widget.size,
      height: widget.size,
      fit: widget.fit,
      repeat: widget.repeat,
      animate: false,
      delegates: delegates.isEmpty ? null : LottieDelegates(values: delegates),
      onLoaded: (composition) {
        _loaded = true;
        _controller.duration = Duration(
          microseconds: (composition.duration.inMicroseconds / widget.speed)
              .round(),
        );

        final bool shouldAutoPlay =
            widget.autoplay || (widget.selected && widget.animateOnSelected);

        if (shouldAutoPlay) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) play();
          });
        }
      },
    );

    if (widget.color != null && widget.secondaryColor == null) {
      lottie = ColorFiltered(
        colorFilter: ColorFilter.mode(widget.color!, BlendMode.srcIn),
        child: lottie,
      );
    }

    Widget icon = Transform.scale(scale: widget.scale, child: lottie);

    if (widget.onTap == null) {
      return icon;
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(widget.size),
        onTap: _handleTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        child: SizedBox(
          width: widget.size + 12,
          height: widget.size + 12,
          child: Center(child: icon),
        ),
      ),
    );
  }
}
