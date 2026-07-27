import 'package:flutter/material.dart';
import 'package:flutter_lucide_animated/flutter_lucide_animated.dart';

class AutoPlayLucideIcon extends StatefulWidget {
  final LucideAnimatedIconData icon;
  final double size;
  final Color color;
  final Duration duration;
  final bool shouldPlay;

  const AutoPlayLucideIcon({
    super.key,
    required this.icon,
    this.size = 28,
    this.color = Colors.white,
    this.duration = const Duration(seconds: 2),
    this.shouldPlay = false,
  });

  @override
  State<AutoPlayLucideIcon> createState() => _AutoPlayLucideIconState();
}

class _AutoPlayLucideIconState extends State<AutoPlayLucideIcon> {
  final LucideAnimatedIconController _controller =
      LucideAnimatedIconController();

  bool _hasPlayed = false;

  @override
  void initState() {
    super.initState();
    if (widget.shouldPlay) {
      _playOnce();
    }
  }

  @override
  void didUpdateWidget(covariant AutoPlayLucideIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldPlay && !_hasPlayed) {
      _playOnce();
    }
  }

  void _playOnce() {
    _hasPlayed = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.animate();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.animate();
      },
      behavior: HitTestBehavior.opaque,
      child: LucideAnimatedIcon(
        icon: widget.icon,
        size: widget.size,
        color: widget.color,
        duration: widget.duration,
        trigger: AnimationTrigger.manual,
        controller: _controller,
      ),
    );
  }
}
