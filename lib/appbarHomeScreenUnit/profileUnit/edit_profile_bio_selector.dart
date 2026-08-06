import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/profileUnit/profile_controller.dart';

class EditProfileBioSelector extends StatelessWidget {
  final ProfileController controller;

  const EditProfileBioSelector({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(() {
      final currentBio = controller.bio.value;
      final customList = controller.customBios;
      final allBios = [...ProfileController.presetBios, ...customList];
      return ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 200),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: allBios.length,
          separatorBuilder: (_, _) => const SizedBox(height: 2),
          itemBuilder: (_, index) {
            final bioText = allBios[index];
            final isSelected = currentBio == bioText;
            final isCustom = customList.contains(bioText);
            return ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              onTap: () => controller.updateBio(bioText),
              leading: Icon(
                isSelected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: isSelected ? colorScheme.primary : null,
              ),
              title: Text(bioText, style: theme.textTheme.bodyMedium),
              trailing: isCustom
                  ? IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 18),
                      onPressed: () => controller.removeCustomBio(bioText),
                    )
                  : null,
            );
          },
        ),
      );
    });
  }
}
