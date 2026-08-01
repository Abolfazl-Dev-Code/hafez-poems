import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:hafez_poems/theme/text_style.dart';

void showAboutDialogCustom({
  required BuildContext context,
  required String appVersion,
}) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final colorScheme = Theme.of(dialogContext).colorScheme;

      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.xlRadius,
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 10),
          actionsPadding: const EdgeInsets.only(left: 16, bottom: 10),
          title: Row(
            children: [
              Icon(
                Icons.menu_book_rounded,
                color: colorScheme.primary,
                size: 26,
              ),
              const SizedBox(width: 10),
              Text(
                'درباره ما',
                style: AppTextStyles.bodyMediumSetting.copyWith(
                  fontSize: 19,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Text(
              'این برنامه با هدف ایجاد تجربه‌ای آرام و دلنشین برای خواندن دیوان حافظ طراحی شده است.\n\n'
              'تلاش ما این است که مطالعه شعر فارسی را ساده‌تر، زیباتر و شخصی‌سازی‌شده‌تر کنیم تا هر کاربر بتواند '
              'با فضای شعر و ادب فارسی ارتباطی عمیق‌تر برقرار کند.',
              textAlign: TextAlign.right,
              style: AppTextStyles.titleMediumSetting.copyWith(
                height: 1.8,
                fontSize: 14,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [Text('بستن')],
              ),
            ),
          ],
        ),
      );
    },
  );
}
