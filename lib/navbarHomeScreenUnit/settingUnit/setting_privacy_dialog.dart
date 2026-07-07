import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/text_style.dart';

void showPrivacyDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final colorScheme = Theme.of(dialogContext).colorScheme;

      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.lock_outline, color: colorScheme.primary, size: 26),
              const SizedBox(width: 10),
              Text(
                'حریم خصوصی',
                style: AppTextStyles.bodyMediumSetting.copyWith(
                  fontSize: 19,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Text(
              'اطلاعات شخصی شما در این برنامه به‌صورت محلی نگهداری می‌شود و بدون رضایت شما '
              'به جایی ارسال نخواهد شد.\n\n'
              'تنظیمات مطالعه، داده‌های ذخیره‌شده و وضعیت اعلان‌ها فقط برای بهبود تجربه کاربری '
              'در داخل دستگاه شما استفاده می‌شوند.',
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
                children: const [
                  Text('متوجه شدم'),
                  SizedBox(width: 4),
                  Icon(Icons.check, size: 18),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
