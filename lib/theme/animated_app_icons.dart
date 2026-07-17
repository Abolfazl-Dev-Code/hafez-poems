import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedAppIcon extends StatefulWidget {
  const AnimatedAppIcon({
    super.key,
    required this.asset,
    this.size = 24,
    this.color,
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget icon = Transform.scale(
      scale: widget.scale,
      child: Lottie.asset(
        widget.asset,
        controller: _controller,
        width: widget.size,
        height: widget.size,
        fit: widget.fit,
        repeat: widget.repeat,
        animate: false,
        delegates: widget.color == null
            ? null
            : LottieDelegates(
                values: [
                  ValueDelegate.color(const ['**'], value: widget.color!),
                ],
              ),
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
      ),
    );
    if (widget.onTap == null) {
      return icon;
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(widget.size),
        onTap: _handleTap,
        child: SizedBox(
          width: widget.size + 12,
          height: widget.size + 12,
          child: Center(child: icon),
        ),
      ),
    );
  }
}
