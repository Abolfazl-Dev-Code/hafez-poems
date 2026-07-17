import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/text_style.dart';

typedef SelectableItemIdGetter<T> = String Function(T item);
typedef SelectableItemBuilder<T> =
    Widget Function(
      BuildContext context,
      T item,
      bool isSelected,
      bool selectionMode,
    );
typedef DeleteSelectedItems<T> = Future<void> Function(List<T> selectedItems);

class SelectableCardsPage<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final SelectableItemIdGetter<T> idGetter;
  final SelectableItemBuilder<T> itemBuilder;
  final DeleteSelectedItems<T> onDeleteSelected;
  final Future<void> Function()? onRefresh;
  final Widget? emptyWidget;
  final String deleteConfirmMessage;
  final String selectAllText;

  const SelectableCardsPage({
    super.key,
    required this.title,
    required this.items,
    required this.idGetter,
    required this.itemBuilder,
    required this.onDeleteSelected,
    this.onRefresh,
    this.emptyWidget,
    this.deleteConfirmMessage = 'آیا از حذف موارد انتخاب‌شده اطمینان دارید؟',
    this.selectAllText = 'انتخاب همه',
  });

  @override
  State<SelectableCardsPage<T>> createState() => _SelectableCardsPageState<T>();
}

class _SelectableCardsPageState<T> extends State<SelectableCardsPage<T>> {
  final Set<String> _selectedIds = <String>{};

  bool get _selectionMode => _selectedIds.isNotEmpty;

  bool get _allSelected =>
      widget.items.isNotEmpty && _selectedIds.length == widget.items.length;

  bool _isSelected(T item) {
    return _selectedIds.contains(widget.idGetter(item));
  }

  void _onLongPressItem(T item) {
    final id = widget.idGetter(item);
    setState(() {
      _selectedIds.add(id);
    });
  }

  void _onTapItem(T item) {
    if (!_selectionMode) return;

    final id = widget.idGetter(item);
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedIds.clear();
    });
  }

  void _selectAll() {
    setState(() {
      _selectedIds
        ..clear()
        ..addAll(widget.items.map(widget.idGetter));
    });
  }

  List<T> get _selectedItems {
    return widget.items
        .where((item) => _selectedIds.contains(widget.idGetter(item)))
        .toList();
  }

  Future<void> _confirmAndDelete() async {
    final selectedItems = _selectedItems;
    if (selectedItems.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: colorScheme.surface,
            titlePadding: const EdgeInsets.fromLTRB(24, 22, 24, 8),
            contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
            actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            actionsAlignment: MainAxisAlignment.start,
            title: Text(
              'حذف موارد',
              textAlign: TextAlign.right,
              style: AppTextStyles.bodyMediumSetting.copyWith(
                fontSize: 19,
                color: colorScheme.onSurface,
              ),
            ),
            content: Text(
              widget.deleteConfirmMessage,
              textAlign: TextAlign.right,
              style: AppTextStyles.titleMediumSetting.copyWith(
                fontSize: 13,
                color: colorScheme.onSurface.withValues(alpha: 0.85),
                height: 1.8,
              ),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green.shade700,
                  backgroundColor: Colors.green.withValues(alpha: 0.10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Colors.green.withValues(alpha: 0.20),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('لغو'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red.shade700,
                  backgroundColor: Colors.red.withValues(alpha: 0.10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.red.withValues(alpha: 0.20)),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('حذف'),
              ),
            ],
          ),
        );
      },
    );

    if (confirmed == true) {
      await widget.onDeleteSelected(selectedItems);
      if (!mounted) return;
      _clearSelection();
    }
  }

  @override
  void didUpdateWidget(covariant SelectableCardsPage<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final validIds = widget.items.map(widget.idGetter).toSet();
    _selectedIds.removeWhere((id) => !validIds.contains(id));
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;

    return Scaffold(
      appBar: AppBar(
        title: _selectionMode
            ? Text('${_selectedIds.length} انتخاب شده')
            : Text(widget.title),
        actions: [
          if (_selectionMode) ...[
            TextButton(
              onPressed: items.isEmpty
                  ? null
                  : (_allSelected ? _clearSelection : _selectAll),
              child: Text(_allSelected ? 'لغو همه' : widget.selectAllText),
            ),
            IconButton(
              onPressed: _selectedIds.isEmpty ? null : _confirmAndDelete,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ],
      ),
      body: items.isEmpty
          ? (widget.emptyWidget ??
                const Center(child: Text('موردی وجود ندارد')))
          : RefreshIndicator(
              onRefresh: widget.onRefresh ?? () async {},
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = _isSelected(item);

                  return GestureDetector(
                    onLongPress: () => _onLongPressItem(item),
                    onTap: () => _onTapItem(item),
                    child: Stack(
                      children: [
                        widget.itemBuilder(
                          context,
                          item,
                          isSelected,
                          _selectionMode,
                        ),
                        if (_selectionMode)
                          PositionedDirectional(
                            top: 12,
                            end: 12,
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.white,
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.white,
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
