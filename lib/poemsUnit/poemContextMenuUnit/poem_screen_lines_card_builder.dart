part of '../poems/poem_screen.dart';

extension _PoemScreenLinesCardBuilder on _PoemScreenState {
  Widget _buildPoemLinesCard(
    ThemeData theme,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Card(
      color: colorScheme.surface,
      elevation: theme.brightness == Brightness.dark ? 0 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lgRadius,
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: ListenableBuilder(
          listenable: _verseSyncCtrl,
          builder: (context, _) {
            final activeOrder = _verseSyncCtrl.activeVerseOrder;
            return Column(
              children: [
                if (_highlightedLineIndexes.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.touch_app_outlined,
                          size: 16,
                          color: colorScheme.onSurface.withValues(alpha: 0.35),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'برای دیدن تنظیمات بیشتر، روی یک مصرع نگه دارید',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.35,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ...List.generate(_poemLines.length, (i) {
                  final isActive =
                      _verseSyncCtrl.hasSyncData && activeOrder == i;
                  final isFlashing = _flashingLineIndex == i;
                  final layerLink = _lineLayerLinks[i] ??= LayerLink();
                  final verseKey = _verseTargetKeys[i] ??= GlobalKey();
                  final verseText = CompositedTransformTarget(
                    link: layerLink,
                    child: KeyedSubtree(
                      key: verseKey,
                      child: Opacity(
                        opacity: _menuOpenLineIndex == i ? 0 : 1,
                        child: PoemSelectedText(
                          text: _poemLines[i],
                          isSelected: _isMultiLineSelecting
                              ? _selectedShareLines.contains(i)
                              : _selectedLineIndex == i,
                          isHighlighted: _highlightedLineIndexes.contains(i),
                          fontSize: _fontSize,
                          lineHeight: _lineHeight,
                          isFlashing: isFlashing,
                          isContextMenuOpen: _menuOpenLineIndex == i,
                          fontFamily: _fontFamily,
                          fontColor: _fontColor,
                          onTap: () {
                            if (_isMultiLineSelecting) {
                              _toggleShareLineSelection(i);
                              return;
                            }
                            _toggleSelectedLineIndex(i);
                          },
                          onLongPress: (details) => _showLineMenu(i, details),
                        ),
                      ),
                    ),
                  );
                  return Padding(
                    key: _lineKeys[i] ??= GlobalKey(),
                    padding: const EdgeInsets.only(bottom: 8, right: 0),
                    child: _verseSyncCtrl.hasSyncData
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: _PoemScreenState.indicatorSlotSize,
                                height: _PoemScreenState.indicatorSlotSize,
                                child: Center(
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 250),
                                    transitionBuilder: (child, anim) =>
                                        ScaleTransition(
                                          scale: anim,
                                          child: FadeTransition(
                                            opacity: anim,
                                            child: child,
                                          ),
                                        ),
                                    child: isActive
                                        ? ActiveVerseIndicator(
                                            key: const ValueKey(
                                              'active_indicator',
                                            ),
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          )
                                        : const SizedBox.shrink(
                                            key: ValueKey('inactive_indicator'),
                                          ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 6.5),
                              Expanded(child: verseText),
                            ],
                          )
                        : verseText,
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}
