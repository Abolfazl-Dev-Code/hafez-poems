import 'package:flutter/material.dart';
import 'package:hafez_poems/services/theme_reveal_service.dart';

class ThemeModeIconToggle extends StatefulWidget {
  const ThemeModeIconToggle({
    super.key,
    required this.isDarkMode,
    required this.onTap,
  });

  final bool isDarkMode;
  final VoidCallback onTap;

  @override
  State<ThemeModeIconToggle> createState() => _ThemeModeIconToggleState();
}

class _ThemeModeIconToggleState extends State<ThemeModeIconToggle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  late final Animation<double> _rotateAnim;
  late final Animation<double> _scaleAnim;
  late final Animation<Offset> _slideOut;
  late final Animation<Offset> _slideIn;
  late final Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _buildAnimations();
    _ctrl.value = widget.isDarkMode ? 1.0 : 0.0;
  }

  void _buildAnimations() {
    _rotateAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutBack));

    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.6, end: 1.15), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 40),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    _slideOut = Tween<Offset>(begin: Offset.zero, end: const Offset(0, 1.6))
        .animate(
          CurvedAnimation(
            parent: _ctrl,
            curve: const Interval(0.0, 0.45, curve: Curves.easeIn),
          ),
        );

    _slideIn = Tween<Offset>(begin: const Offset(0, -1.6), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _ctrl,
            curve: const Interval(0.45, 1.0, curve: Curves.easeOutBack),
          ),
        );

    _glowAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(ThemeModeIconToggle old) {
    super.didUpdateWidget(old);
    if (old.isDarkMode != widget.isDarkMode) {
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final glowColor = widget.isDarkMode
        ? const Color(0xFF7C4DFF)
        : const Color(0xFFFFB300);

    return GestureDetector(
      onTap: () {
        final box = context.findRenderObject() as RenderBox?;
        final pos =
            box?.localToGlobal(box.size.center(Offset.zero)) ??
            Offset(MediaQuery.of(context).size.width / 2, 100);

        ThemeRevealService.instance.reveal(
          context: context,
          origin: pos,
          toDark: !widget.isDarkMode,
          onSwitch: widget.onTap,
        );
      },
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          return Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.8),
              ),
              boxShadow: [
                BoxShadow(
                  color: glowColor.withValues(alpha: _glowAnim.value * 0.85),
                  blurRadius: 22 + _glowAnim.value * 22,
                  spreadRadius: _glowAnim.value * 5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 520),
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 0.85,
                          colors: widget.isDarkMode
                              ? [
                                  const Color(
                                    0xFF2D1B69,
                                  ).withValues(alpha: 0.35),
                                  Colors.transparent,
                                ]
                              : [
                                  const Color(
                                    0xFFFFF3CD,
                                  ).withValues(alpha: 0.5),
                                  Colors.transparent,
                                ],
                        ),
                      ),
                    ),
                  ),
                  SlideTransition(
                    position: _slideOut,
                    child: Opacity(
                      opacity: (1.0 - _ctrl.value * 2.2).clamp(0.0, 1.0),
                      child: _buildIcon(isDark: widget.isDarkMode),
                    ),
                  ),
                  SlideTransition(
                    position: _slideIn,
                    child: Opacity(
                      opacity: ((_ctrl.value - 0.4) * 1.8).clamp(0.0, 1.0),
                      child: Transform.scale(
                        scale: _scaleAnim.value,
                        child: RotationTransition(
                          turns: _rotateAnim,
                          child: _buildIcon(isDark: widget.isDarkMode),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIcon({required bool isDark}) {
    return Icon(
      isDark ? Icons.dark_mode_rounded : Icons.wb_sunny_rounded,
      size: 26,
      color: isDark ? const Color(0xFF7C4DFF) : const Color(0xFFFFB300),
    );
  }
}
