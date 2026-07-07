import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/profileUnit/profile_controller.dart';
import 'package:hafez_poems/theme/color_style.dart';

class ProfileAndNameEditor extends StatelessWidget {
  final String name;

  const ProfileAndNameEditor({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textStyle = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w800,
      color: colorScheme.onSurface,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: textStyle,
            ),
            const SizedBox(height: 3),
          ],
        );
      },
    );
  }
}

// --- باتم‌شیت کامل: عکس + نام + بیو با هم ---
Future<void> showEditProfileSheet(
  BuildContext context,
  ProfileController controller,
) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) => Directionality(
      textDirection: TextDirection.rtl,
      child: _EditProfileSheetContent(controller: controller),
    ),
  );
}

class _EditProfileSheetContent extends StatefulWidget {
  final ProfileController controller;
  const _EditProfileSheetContent({required this.controller});

  @override
  State<_EditProfileSheetContent> createState() =>
      _EditProfileSheetContentState();
}

class _EditProfileSheetContentState extends State<_EditProfileSheetContent> {
  late final TextEditingController _nameController;
  late final TextEditingController _customBioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.controller.userName.value,
    );
    _customBioController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _customBioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final controller = widget.controller;

    final text = _nameController.text;
    final trimmed = text.trim();
    final isTooShort = trimmed.length < 3;
    final isTooLong = text.length > 20;
    final hasError = trimmed.isEmpty || isTooShort || isTooLong;

    String? errorMsg;
    if (trimmed.isEmpty) {
      errorMsg = 'نام نمی‌تواند خالی باشد';
    } else if (isTooShort) {
      errorMsg = 'نام باید حداقل ۴ کاراکتر باشد';
    } else if (isTooLong) {
      errorMsg = 'نام نمی‌تواند بیشتر از ۲۰ کاراکتر باشد';
    }

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ویرایش پروفایل',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Obx(() {
                  final path = controller.avatarPath.value;
                  return CircleAvatar(
                    radius: 32,
                    backgroundColor: colorScheme.primary.withValues(
                      alpha: 0.12,
                    ),
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
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          size: 16,
                        ),
                        label: const Text('حذف عکس'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              'نام :',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              maxLength: 20,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'نام خود را وارد کنید',
                counterText: '',
                border: const OutlineInputBorder(),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.error, width: 2),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.error, width: 2),
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: (hasError && text.isNotEmpty)
                  ? Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: AppColors.error,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              errorMsg ?? '',
                              style: TextStyle(
                                color: AppColors.error,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 22),
            Text(
              "متن دلخواه شما :",
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() {
              final currentBio = controller
                  .bio
                  .value; // ← خوانده‌شده هم‌زمان، حالا trackable است
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
                    final isSelected =
                        currentBio == bioText; // ← استفاده از مقدار snapshot
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
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                size: 18,
                              ),
                              onPressed: () =>
                                  controller.removeCustomBio(bioText),
                            )
                          : null,
                    );
                  },
                ),
              );
            }),
            const SizedBox(height: 8),
            TextField(
              controller: _customBioController,
              maxLength: 60,
              decoration: const InputDecoration(
                labelText: 'جمله‌ی دلخواه خودت رو بنویس',
                border: OutlineInputBorder(),
                counterText: '',
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () async {
                  final txt = _customBioController.text.trim();
                  if (txt.isEmpty) return;
                  await controller.addCustomBio(txt);
                  _customBioController.clear();
                  setState(() {});
                },
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('افزودن و انتخاب'),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: hasError
                    ? null
                    : () async {
                        await controller.updateName(trimmed);
                        if (context.mounted) Navigator.pop(context);
                      },
                child: const Text('ذخیره و بستن'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
