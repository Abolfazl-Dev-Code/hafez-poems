import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/text_style.dart';
import 'package:hive/hive.dart';

mixin SelectionMixin<T extends StatefulWidget> on State<T> {
  final Set<dynamic> selectedKeys = {};

  bool get selectionMode => selectedKeys.isNotEmpty;

  void toggleSelection(dynamic key) => setState(
    () => selectedKeys.contains(key)
        ? selectedKeys.remove(key)
        : selectedKeys.add(key),
  );

  void selectOnly(dynamic key) => setState(() => selectedKeys.add(key));

  void clearSelection() => setState(() => selectedKeys.clear());

  void selectAll(Iterable<dynamic> keys) => setState(
    () => selectedKeys
      ..clear()
      ..addAll(keys),
  );

  void pruneDeletedKeys(Iterable<dynamic> validKeys) {
    final valid = validKeys.toSet();
    if (selectedKeys.any((k) => !valid.contains(k))) {
      setState(() => selectedKeys.removeWhere((k) => !valid.contains(k)));
    }
  }

  Future<void> deleteSelected(BuildContext context, Box<HiveObject> box) async {
    if (selectedKeys.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;

        return Directionality(
          textDirection: TextDirection.ltr,
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
              'آیا از حذف موارد انتخاب‌شده اطمینان دارید؟',
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
            ],
          ),
        );
      },
    );

    if (confirmed == true) {
      final keysToDelete = selectedKeys.toList();

      for (final key in keysToDelete) {
        await box.delete(key);
      }

      clearSelection();
    }
  }
}
