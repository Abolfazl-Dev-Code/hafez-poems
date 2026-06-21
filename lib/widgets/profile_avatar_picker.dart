import 'package:flutter/material.dart';
import 'package:hafez_poems/controllers/profile_controller.dart';

Future<void> showAvatarPickerSheet(
  BuildContext context,
  ProfileController controller,
) async {
  await showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (_) => SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: const Text('انتخاب عکس پروفایل'),
              onTap: () async {
                Navigator.pop(context);
                await controller.pickAndSaveAvatar();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded),
              title: const Text('حذف عکس پروفایل'),
              onTap: () async {
                Navigator.pop(context);
                await controller.removeAvatar();
              },
            ),
          ],
        ),
      ),
    ),
  );
}
