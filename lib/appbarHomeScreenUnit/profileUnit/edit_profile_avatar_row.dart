import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/profileUnit/profile_controller.dart';

class EditProfileAvatarRow extends StatelessWidget {
  final ProfileController controller;

  const EditProfileAvatarRow({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Obx(() {
          final path = controller.avatarPath.value;
          return CircleAvatar(
            radius: 32,
            backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
            backgroundImage: (path != null && path.isNotEmpty)
                ? FileImage(File(path))
                : null,
            child: (path == null || path.isEmpty)
                ? Icon(Icons.person_rounded, color: colorScheme.primary)
                : null,
          );
        }),
        const SizedBox(width: 14),
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => controller.pickAndSaveAvatar(),
                icon: const Icon(Icons.photo_library_rounded, size: 16),
                label: const Text('انتخاب عکس'),
              ),
              OutlinedButton.icon(
                onPressed: () => controller.removeAvatar(),
                icon: const Icon(Icons.delete_outline_rounded, size: 16),
                label: const Text('حذف عکس'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
