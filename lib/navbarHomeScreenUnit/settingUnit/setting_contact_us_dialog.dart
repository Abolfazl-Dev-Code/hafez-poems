import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_spacing.dart';

void showContactOptions({
  required BuildContext context,
  required VoidCallback onEmailTap,
  required VoidCallback onTelegramTap,
  required VoidCallback onWebsiteTap,
}) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('ایمیل', textAlign: TextAlign.right),
                  subtitle: const Text(
                    'nashenaskhamosh@gmail.com',
                    textAlign: TextAlign.right,
                  ),
                  trailing: const Icon(Icons.chevron_left),
                  onTap: () {
                    Navigator.pop(context);
                    onEmailTap();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.telegram),
                  title: const Text('تلگرام', textAlign: TextAlign.right),
                  subtitle: const Text(
                    't.me/dotb1',
                    textAlign: TextAlign.right,
                  ),
                  trailing: const Icon(Icons.chevron_left),
                  onTap: () {
                    Navigator.pop(context);
                    onTelegramTap();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text('اینستاگرام', textAlign: TextAlign.right),
                  subtitle: const Text(
                    'Should_call_me_nostradamus',
                    textAlign: TextAlign.right,
                  ),
                  trailing: const Icon(Icons.chevron_left),
                  onTap: () {
                    Navigator.pop(context);
                    onWebsiteTap();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
