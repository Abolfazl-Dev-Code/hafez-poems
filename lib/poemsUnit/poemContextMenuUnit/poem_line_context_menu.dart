// lib/poemsUnit/poems/poem_line_context_menu.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hafez_poems/poemsUnit/poemContextMenuUnit/poem_line_action_menu.dart';
import 'package:hafez_poems/theme/color_style.dart';

typedef LineWidgetBuilder = Widget Function(BuildContext context);

/// کنترلر مدیریت چرخه‌ی حیات منوی شناور (Overlay-based context menu)
class PoemLineContextMenuController {
  OverlayEntry? _entry;
  GlobalKey<_PoemLineContextMenuOverlayState>? _overlayKey;
  VoidCallback? _onClosedCallback;

  bool get isOpen => _entry != null;

  void show({
    required BuildContext context,
    required LayerLink layerLink,
    required Size targetSize,
    required Offset targetOffset,
    required LineWidgetBuilder lineBuilder,
    required bool isHighlighted,
    required VoidCallback onCopy,
    required VoidCallback onToggleHighlight,
    required VoidCallback onClosed,
  }) {
    if (_entry != null) return;

    _overlayKey = GlobalKey<_PoemLineContextMenuOverlayState>();

    final screenHeight = MediaQuery.of(context).size.height;
    final spaceBelow = screenHeight - (targetOffset.dy + targetSize.height);
    const estimatedMenuHeight = 190.0;
    final showBelow = spaceBelow >= estimatedMenuHeight;

    _entry = OverlayEntry(
      builder: (overlayContext) {
        return _PoemLineContextMenuOverlay(
          key: _overlayKey,
          layerLink: layerLink,
          targetSize: targetSize,
          lineBuilder: lineBuilder,
          isHighlighted: isHighlighted,
          showBelow: showBelow,
          onCopy: () {
            onCopy();
            hide();
          },
          onToggleHighlight: () {
            onToggleHighlight();
            hide();
          },
          onDismiss: hide,
        );
      },
    );

    Overlay.of(context).insert(_entry!);
    _onClosedCallback = onClosed;
  }

  Future<void> hide() async {
    if (_entry == null) return;
    await _overlayKey?.currentState?.reverse();
    _entry?.remove();
    _entry = null;
    _onClosedCallback?.call();
    _onClosedCallback = null;
  }

  void dispose() {
    _entry?.remove();
    _entry = null;
  }
}

class _PoemLineContextMenuOverlay extends StatefulWidget {
  const _PoemLineContextMenuOverlay({
    super.key,
    required this.layerLink,
    required this.targetSize,
    required this.lineBuilder,
    required this.isHighlighted,
    required this.showBelow,
    required this.onCopy,
    required this.onToggleHighlight,
    required this.onDismiss,
  });

  final LayerLink layerLink;
  final Size targetSize;
  final LineWidgetBuilder lineBuilder;
  final bool isHighlighted;
  final bool showBelow;
  final VoidCallback onCopy;
  final VoidCallback onToggleHighlight;
  final VoidCallback onDismiss;

  @override
  State<_PoemLineContextMenuOverlay> createState() =>
      _PoemLineContextMenuOverlayState();
}

class _PoemLineContextMenuOverlayState
    extends State<_PoemLineContextMenuOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;
  late final Animation<double> _lift;

  static const double _menuGap = 8.0;
  static const double _liftDistance = 18.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _scale = Tween<double>(
      begin: 0.92,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _lift = Tween<double>(
      begin: 0,
      end: widget.showBelow ? -_liftDistance : _liftDistance,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  Future<void> reverse() => _controller.reverse();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final blurTint = isDark ? AppColors.darkBackground : AppColors.textPrimary;
    final cardColor = isDark ? AppColors.darkSurface : AppColors.surface;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Stack(
            children: [
              // لایه ۱: بلور پس‌زمینه + بستن با تپ بیرون
              Positioned.fill(
                child: GestureDetector(
                  onTap: widget.onDismiss,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 6 * _fade.value,
                      sigmaY: 6 * _fade.value,
                    ),
                    child: Container(
                      color: blurTint.withValues(alpha: 0.28 * _fade.value),
                    ),
                  ),
                ),
              ),

              // لایه ۲: کارت شناور مصرع
              CompositedTransformFollower(
                link: widget.layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, _lift.value),
                child: Opacity(
                  opacity: _fade.value,
                  child: Transform.scale(
                    scale: _scale.value,
                    child: Material(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(14),
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox(
                        width: widget.targetSize.width,
                        child: GestureDetector(
                          onVerticalDragEnd: (details) {
                            if ((details.primaryVelocity ?? 0) > 250) {
                              widget.onDismiss();
                            }
                          },
                          child: widget.lineBuilder(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // لایه ۳: منوی اکشن دقیقاً زیر/بالای کارت شناور
              CompositedTransformFollower(
                link: widget.layerLink,
                showWhenUnlinked: false,
                offset: Offset(
                  0,
                  widget.showBelow
                      ? widget.targetSize.height + _lift.value + _menuGap
                      : _lift.value - _menuGap,
                ),
                child: Align(
                  alignment: widget.showBelow
                      ? Alignment.topCenter
                      : Alignment.bottomCenter,
                  child: FractionalTranslation(
                    translation: Offset(0, widget.showBelow ? 0 : -1),
                    child: Opacity(
                      opacity: _fade.value,
                      child: Transform.scale(
                        scale: _scale.value,
                        alignment: widget.showBelow
                            ? Alignment.topCenter
                            : Alignment.bottomCenter,
                        child: ActionMenu(
                          isHighlighted: widget.isHighlighted,
                          fadeValue: _fade.value,
                          isDark: isDark,
                          onCopy: widget.onCopy,
                          onToggleHighlight: widget.onToggleHighlight,
                          onClose: widget.onDismiss,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
