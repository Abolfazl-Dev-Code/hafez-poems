import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:hafez_poems/theme/text_style.dart';

Future<bool?> showDeleteDataDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      final colorScheme = Theme.of(context).colorScheme;

      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(
            'حذف تمامی داده‌های محلی',
            style: AppTextStyles.bodyMediumSetting.copyWith(
              fontSize: 19,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.right,
          ),
          content: Text.rich(
            TextSpan(
              style: AppTextStyles.titleMediumSetting.copyWith(
                fontSize: 13,
                color: colorScheme.onSurface,
                height: 1.8,
              ),
              children: [
                const TextSpan(text: 'آیا از '),
                TextSpan(
                  text: 'حذف',
                  style: AppTextStyles.titleMediumSetting.copyWith(
                    fontSize: 13,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(
                  text:
                      ' کامل تمامی داده‌های محلی برنامه اطمینان دارید؟\n'
                      'این عملیات شامل علاقه‌مندی‌‌ها، ذخیره‌ها، برگزیده‌‌ها، موارد صوتی دانلود شده و تنظیمات ذخیره‌شده خواهد بود.',
                ),
              ],
            ),
            textAlign: TextAlign.right,
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green.shade700,
                backgroundColor: Colors.green.withValues(alpha: 0.10),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.smRadius,
                  side: BorderSide(color: Colors.green.withValues(alpha: 0.20)),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('لغو'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red.shade700,
                backgroundColor: Colors.red.withValues(alpha: 0.10),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.smRadius,
                  side: BorderSide(color: Colors.red.withValues(alpha: 0.20)),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('حذف'),
            ),
          ],
        ),
      );
    },
  );
}
