part of 'poem_list_sheet.dart';

extension _PoemListFilterUI on _PoemListSheetState {
  void _showFilterDropdown(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final currentFilter = _filter;

    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;

    final Offset buttonOffset = button.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );
    final Size buttonSize = button.size;
    final Size overlaySize = overlay.size;
    final RelativeRect position = RelativeRect.fromLTRB(
      buttonOffset.dx,
      buttonOffset.dy + buttonSize.height + 4,
      overlaySize.width - buttonOffset.dx - buttonSize.width,
      overlaySize.height - buttonOffset.dy - buttonSize.height,
    );

    showMenu<_ReadFilter>(
      context: context,
      position: position,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
      color: cs.surface,
      items: _ReadFilter.values.map((f) {
        final isActive = currentFilter == f;
        return PopupMenuItem<_ReadFilter>(
          value: f,
          padding: EdgeInsets.only(left: AppSpacing.md),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: 150,
            padding: const EdgeInsets.only(
              left: 10,
              right: 4,
              top: 10,
              bottom: 10,
            ),
            decoration: BoxDecoration(
              color: isActive
                  ? cs.primary.withValues(alpha: 0.08)
                  : Colors.transparent,
              borderRadius: AppRadius.smRadius,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  f.label,
                  textAlign: TextAlign.right,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isActive ? cs.primary : cs.onSurface,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  isActive ? f.activeIcon : f.icon,
                  size: 18,
                  color: isActive
                      ? cs.primary
                      : cs.onSurface.withValues(alpha: 0.55),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    ).then((selected) {
      if (selected != null && selected != _filter) {
        _applyFilter(selected);
      }
    });
  }

  Widget _buildEmptyFiltered(ThemeData theme) {
    final cs = theme.colorScheme;
    final (icon, title, subtitle) = switch (_filter) {
      _ReadFilter.read => (
        Icons.menu_book_rounded,
        'هنوز شعری نخوانده‌اید',
        'اشعاری که باز کنید اینجا نمایش داده می‌شوند',
      ),
      _ReadFilter.unread => (
        Icons.task_alt_rounded,
        'همه‌ی موارد را خوانده‌اید',
        'تمام اشعار این بخش را مطالعه کرده‌اید',
      ),
      _ReadFilter.all => (Icons.library_books_outlined, 'موردی یافت نشد', ''),
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 44, color: cs.primary.withValues(alpha: 0.55)),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.85),
                fontWeight: FontWeight.w600,
              ),
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.45),
                ),
              ),
            ],
            const SizedBox(height: 16),
            TextButton(
              onPressed: _resetFilterToAll,
              child: const Text('نمایش همه'),
            ),
          ],
        ),
      ),
    );
  }
}
