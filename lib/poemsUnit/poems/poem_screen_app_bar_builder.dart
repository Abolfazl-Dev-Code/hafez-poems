part of 'poem_screen.dart';

extension _PoemScreenAppBarBuilder on _PoemScreenState {
  PreferredSizeWidget _buildAppBar(
    ThemeData theme,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return AppBar(
      toolbarHeight: 50,
      automaticallyImplyLeading: false,
      leadingWidth: 70,
      leading: _isMultiLineSelecting
          ? null
          : Center(
              child: LucideAnimatedIcon(
                icon: arrow_right,
                size: 25,
                trigger: AnimationTrigger.onTap,
                duration: const Duration(milliseconds: 300),
                color: colorScheme.onSurface,
                onTap: () {
                  Navigator.of(context).pop();
                  if (_args.hasAudio) _audioCtrl.stop();
                },
              ),
            ),
      titleSpacing: 35,
      title: _isMultiLineSelecting
          ? Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${_selectedShareLines.length} مصرع انتخاب شده'
                    .toPersianNumbers(),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          : Text(_args.title, style: textTheme.headlineMedium),
      actions: _isMultiLineSelecting
          ? [
              Padding(
                padding: const EdgeInsets.only(left: AppSpacing.md),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: _exitMultiLineSelection,
                      child: const Text('لغو'),
                    ),
                    TextButton(
                      onPressed: _selectedShareLines.isEmpty
                          ? null
                          : () {
                              final indexes = _selectedShareLines.toList()
                                ..sort();

                              final text = indexes
                                  .map((i) => _poemLines[i])
                                  .join('\n');
                              _exitMultiLineSelection();
                              showVerseShareSheet(
                                context,
                                verseText: text,
                                poemTitle: _args.title,
                              );
                            },
                      child: const Text('تایید'),
                    ),
                  ],
                ),
              ),
            ]
          : [
              Padding(
                padding: const EdgeInsets.only(left: AppSpacing.xs),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppBarToggleIcon(
                      isActive: _isLiked,
                      activeIcon: Icons.favorite,
                      inactiveIcon: Icons.favorite_border,
                      activeColor: Colors.red.shade400,
                      inactiveColor: colorScheme.onSurface,
                      onTap: _toggleLike,
                    ),
                    AppBarToggleIcon(
                      isActive: _isSaved,
                      activeIcon: Icons.bookmark,
                      inactiveIcon: Icons.bookmark_border,
                      activeColor: Colors.greenAccent,
                      inactiveColor: colorScheme.onSurface,
                      onTap: _toggleSave,
                    ),
                    IconButton(
                      icon: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          colorScheme.onSurface,
                          BlendMode.srcIn,
                        ),
                        child: Lottie.asset(
                          AppIcons.share,
                          height: 20,
                          controller: _shareController,
                          repeat: false,
                          onLoaded: (composition) {
                            _shareController.duration = composition.duration;
                          },
                        ),
                      ),
                      onPressed: _isTextLoading
                          ? null
                          : () {
                              _shareController
                                ..reset()
                                ..forward();

                              _sharePoem();
                            },
                    ),
                  ],
                ),
              ),
            ],
    );
  }

  Widget _buildBottomOverlay() {
    return Column(
      key: _bottomOverlayKey,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_args.hasAudio)
          AudioPlayerWidget(
            key: _audioWidgetKey,
            id: _args.id,
            category: _args.category,
            audioUrl: _args.audioUrl,
            fetchAudioUrl: _args.fetchAudioUrl,
            controller: _audioCtrl,
            title: _args.title,
            verseSyncController: _verseSyncCtrl,
            onRecitationChanged: (recitation) {
              if (recitation.xmlText.isNotEmpty) {
                _verseSyncCtrl.loadSyncPoints(recitation.xmlText);
              }
            },
            onExpansionChanged: (expanded) {
              _setAudioExpanded(expanded);
              _scheduleMeasureBottomOverlay(
                delay: const Duration(milliseconds: 260),
              );
            },
          ),
      ],
    );
  }
}
