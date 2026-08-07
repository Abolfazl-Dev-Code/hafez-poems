part of '../poems/poem_screen.dart';

extension _PoemScreenLineMenu on _PoemScreenState {
  Future<void> _showLineMenu(int index, LongPressStartDetails details) async {
    if (_contextMenuController.isOpen) return;
    final renderObject = _verseTargetKeys[index]?.currentContext
        ?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.attached) return;
    final targetSize = renderObject.size;
    final targetOffset = renderObject.localToGlobal(Offset.zero);
    HapticFeedback.mediumImpact();
    _pauseAutoScroll();
    _setLineMenuState(selectedLineIndex: index, menuOpenLineIndex: index);
    final layerLink = _lineLayerLinks[index] ??= LayerLink();

    _contextMenuController.show(
      context: context,
      layerLink: layerLink,
      targetSize: targetSize,
      targetOffset: targetOffset,
      isHighlighted: _highlightedLineIndexes.contains(index),
      lineBuilder: (ctx) => PoemSelectedText(
        text: _poemLines[index],
        isSelected: _selectedShareLines.contains(index),
        isHighlighted: _highlightedLineIndexes.contains(index),
        fontSize: _fontSize,
        lineHeight: _lineHeight,
        fontFamily: _fontFamily,
        fontColor: _fontColor,
        isFlashing: false,
        isContextMenuOpen: true,
        onTap: () {},
      ),
      onCopy: () => _copyLine(_poemLines[index]),
      onToggleHighlight: () {
        _selectedLineIndex = index;
        _toggleHighlight();
      },
      onShareAsImage: () => _showShareModeSheet(index),
      onClosed: () {
        if (!mounted) return;
        _setLineMenuState(selectedLineIndex: null, menuOpenLineIndex: null);
        _resumeAutoScrollImmediately();
      },
      onPlayFromHere: () => _playFromVerse(index),
    );
  }

  Future<void> _playFromVerse(int verseOrder) async {
    final player = _audioWidgetKey.currentState;
    if (player == null) return;
    final loadingTimer = Timer(const Duration(seconds: 4), () {
      if (!mounted) return;
      AppSnackBarService.info('درحال بارگیری صدا، لطفاً منتظر بمانید.');
    });

    try {
      await player.prepareForPlay();
    } finally {
      loadingTimer.cancel();
    }
    if (!mounted) return;
    const manualOffset = Duration(milliseconds: 200);
    final position = _verseSyncCtrl.positionForVerse(verseOrder);
    if (position == null) {
      AppSnackBarService.error('موقعیت این مصرع پیدا نشد.');
      return;
    }

    final playPosition = position > manualOffset
        ? position - manualOffset
        : Duration.zero;

    await player.playFromPosition(playPosition);
  }

  void _startMultiLineSelection(int index) {
    _setMultiLineSelection(index);
  }

  void _showShareModeSheet(int index) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (_) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'اشتراک‌گذاری مصرع',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'انتخاب کنید فقط همین مصرع یا چند مصرع را به اشتراک بگذارید.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                ShareModeOptionTile(
                  theme: theme,
                  icon: Icons.text_fields_rounded,
                  title: 'همین مصرع',
                  subtitle: 'اشتراک‌گذاری فقط همین مصرع',
                  onTap: () {
                    Navigator.pop(context);
                    showVerseShareSheet(
                      context,
                      verseText: _poemLines[index],
                      poemTitle: _args.title,
                    );
                  },
                ),
                Divider(
                  height: 20,
                  color: theme.dividerColor.withValues(alpha: .5),
                ),
                ShareModeOptionTile(
                  theme: theme,
                  icon: Icons.library_books_rounded,
                  title: 'انتخاب چند مصرع',
                  subtitle: 'ادامه انتخاب و اشتراک چند مصرع',
                  onTap: () {
                    Navigator.pop(context);
                    _startMultiLineSelection(index);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _toggleShareLineSelection(int index) {
    _toggleShareLine(index);
  }
}
