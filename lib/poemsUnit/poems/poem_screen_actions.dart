part of 'poem_screen.dart';

extension _PoemScreenActions on _PoemScreenState {
  Future<void> _fetchPoemText() async {
    _setTextLoadingState(isLoading: true, error: '');

    try {
      final text = await _args.fetchText(_args.id);
      if (!mounted) return;
      _setPoemText(text);
      _scheduleScrollToHighlight();
    } catch (_) {
      if (!mounted) return;
      _setTextLoadingState(isLoading: false, error: 'خطا در دریافت متن');
    }
  }

  void _scheduleScrollToHighlight() {
    final targetIndex = _args.highlightLineIndex;
    if (targetIndex == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 350));
      if (!mounted) return;

      await _scrollToLineIndex(
        targetIndex,
        duration: const Duration(milliseconds: 500),
      );

      if (!mounted) return;
      await _flashLineTwice(targetIndex);
    });
  }

  void _loadInitialActionsState() {
    _isLiked.value = _actionController.isLiked(_args.id, _args.category);
    _isSaved.value = _actionController.isSaved(_args.id, _args.category);

    _highlightedLineIndexes.addAll(
      _actionController.getHighlightedLineIndexes(_args.id, _args.category),
    );
  }

  void _scheduleMarkAsRead() {
    _markAsReadTimer = Timer(_PoemScreenState._minReadDuration, () {
      if (!mounted) return;
      _markAsRead();
    });
  }

  void _markAsRead() {
    Get.find<IReadStatusStorage>().markAsRead(_args.id);
  }

  Future<void> _toggleLike() async {
    await _actionController.toggleLike(
      poemId: _args.id,
      category: _args.category,
      poemTitle: _args.title,
      poemText: _poemText,
      audioUrl: _args.audioUrl,
    );
    if (mounted) {
      _setIsLiked(_actionController.isLiked(_args.id, _args.category));
    }
  }

  Future<void> _toggleSave() async {
    await _actionController.toggleSave(
      poemId: _args.id,
      category: _args.category,
      poemTitle: _args.title,
      poemText: _poemText,
      audioUrl: _args.audioUrl,
    );
    if (mounted) {
      _setIsSaved(_actionController.isSaved(_args.id, _args.category));
    }
  }

  Future<void> _copyLine(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    AppSnackBarService.success('مصرع کپی شد');
  }

  Future<void> _toggleHighlight() async {
    if (_selectedLineIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لطفاً ابتدا یک مصرع را انتخاب کنید')),
      );
      return;
    }

    final index = _selectedLineIndex!;
    final lineText = _poemLines[index];

    await _actionController.toggleHighlight(
      poemId: _args.id,
      category: _args.category,
      poemTitle: _args.title,
      poemText: _poemText,
      audioUrl: _args.audioUrl,
      highlightedLine: lineText,
      lineIndex: index,
      color: AppColors.accent,
    );

    if (!mounted) return;
    _updateHighlightedLines();
  }
}
