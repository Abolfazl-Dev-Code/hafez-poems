part of 'poem_screen.dart';

extension _PoemScreenReadMarker on _PoemScreenState {
  void _toggleReadUpToHere(int index) {
    setState(() {
      _readUpToLineIndex = _readUpToLineIndex == index ? null : index;
    });
  }

  Future<void> _goToReadMarker() async {
    final index = _readUpToLineIndex;
    if (index == null) return;
    _pauseAutoScroll();
    await _scrollToLineIndex(index, duration: const Duration(milliseconds: 500));
    if (!mounted) return;
    await _flashLineTwice(index);
    if (!mounted) return;
    _scheduleResumeAutoScroll();
  }

  Widget _buildReadUpToHereBanner(
    ThemeData theme,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final index = _readUpToLineIndex;
    if (index == null) return const SizedBox.shrink();

    final current = (index + 1).toString().toPersianNumbers();
    final total = _poemLines.length.toString().toPersianNumbers();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadius.mdRadius,
          onTap: _goToReadMarker,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.12),
              borderRadius: AppRadius.mdRadius,
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.bookmark_rounded,
                  size: 16,
                  color: AppColors.accent,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'شما تا اینجا خوانده‌اید | مصرع $current از $total',
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_left_rounded,
                  size: 18,
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
