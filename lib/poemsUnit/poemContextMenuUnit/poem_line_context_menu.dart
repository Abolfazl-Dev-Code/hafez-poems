import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:hafez_poems/poemsUnit/poemContextMenuUnit/poem_line_action_menu.dart';
import 'package:hafez_poems/theme/color_style.dart';

typedef LineWidgetBuilder = Widget Function(BuildContext context);

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
    required VoidCallback onShareAsImage,
    required VoidCallback onPlayFromHere,
    required VoidCallback onClosed,
  }) {
    if (_entry != null) return;

    _overlayKey = GlobalKey<_PoemLineContextMenuOverlayState>();

    final media = MediaQuery.of(context);
    const menuGap = 0.0;
    final menuHeight = ActionMenu.estimatedHeight();
    final topSpace = targetOffset.dy - media.padding.top;
    final bottomSpace =
        media.size.height -
        media.padding.bottom -
        (targetOffset.dy + targetSize.height);

    final showBelow =
        bottomSpace >= menuHeight + menuGap || bottomSpace >= topSpace;

    _entry = OverlayEntry(
      builder: (_) {
        return _PoemLineContextMenuOverlay(
          key: _overlayKey,
          layerLink: layerLink,
          targetSize: targetSize,
          lineBuilder: lineBuilder,
          isHighlighted: isHighlighted,
          showBelow: showBelow,
          menuGap: menuGap,
          menuHeight: menuHeight,
          onCopy: () {
            onCopy();
            hide();
          },
          onToggleHighlight: () {
            onToggleHighlight();
            hide();
          },
          onShareAsImage: () async {
            await hide();
            onShareAsImage();
          },
          onPlayFromHere: () async {
            await hide();
            onPlayFromHere();
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
    required this.menuGap,
    required this.menuHeight,
    required this.onCopy,
    required this.onToggleHighlight,
    required this.onShareAsImage,
    required this.onPlayFromHere,
    required this.onDismiss,
  });

  final LayerLink layerLink;
  final Size targetSize;
  final LineWidgetBuilder lineBuilder;
  final bool isHighlighted;
  final bool showBelow;

  final double menuGap;
  final double menuHeight;

  final VoidCallback onCopy;
  final VoidCallback onToggleHighlight;
  final VoidCallback onShareAsImage;
  final VoidCallback onPlayFromHere;
  final VoidCallback onDismiss;

  @override
  State<_PoemLineContextMenuOverlay> createState() =>
      _PoemLineContextMenuOverlayState();
}

class _PoemLineContextMenuOverlayState
    extends State<_PoemLineContextMenuOverlay>
    with SingleTickerProviderStateMixin {
  static const double _liftDistance = 14;

  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;
  late final Animation<double> _lift;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _scale = Tween<double>(
      begin: .92,
      end: 1,
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
        builder: (_, _) {
          return Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: widget.onDismiss,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 6 * _fade.value,
                      sigmaY: 6 * _fade.value,
                    ),
                    child: Container(
                      color: blurTint.withValues(alpha: .28 * _fade.value),
                    ),
                  ),
                ),
              ),

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
                      borderRadius: AppRadius.mdRadius,
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

              CompositedTransformFollower(
                link: widget.layerLink,
                showWhenUnlinked: false,
                offset: Offset(
                  widget.targetSize.width - 230,
                  widget.showBelow
                      ? widget.targetSize.height + widget.menuGap
                      : -(widget.menuHeight + widget.menuGap),
                ),
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
                      onShareAsImage: widget.onShareAsImage,
                      onPlayFromHere: widget.onPlayFromHere,
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
