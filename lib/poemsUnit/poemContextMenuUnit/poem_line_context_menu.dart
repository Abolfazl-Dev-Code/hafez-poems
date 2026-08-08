import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:hafez_poems/poemsUnit/poemContextMenuUnit/poem_line_action_menu.dart';
import 'package:hafez_poems/theme/color_style.dart';

part 'poem_line_context_menu_overlay.dart';

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
    required bool isReadMarker,
    required VoidCallback onCopy,
    required VoidCallback onToggleHighlight,
    required VoidCallback onToggleReadMarker,
    required VoidCallback onShareAsImage,
    required VoidCallback onPlayFromHere,
    required VoidCallback onClosed,
  }) {
    if (_entry != null) return;

    _overlayKey = GlobalKey<_PoemLineContextMenuOverlayState>();

    final media = MediaQuery.of(context);
    const menuGap = -5.0;
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
          isReadMarker: isReadMarker,
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
          onToggleReadMarker: () {
            onToggleReadMarker();
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
