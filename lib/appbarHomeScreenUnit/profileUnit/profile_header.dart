import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/profileUnit/profile_and_name_editor.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/profileUnit/profile_avatar_picker.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/profileUnit/profile_controller.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/profileUnit/profile_editor_icon_button.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/profileUnit/profile_streak_badge.dart';
import 'package:hafez_poems/onboardingSplashUnit/noise_particles_background.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;
    final ProfileController controller = Get.find<ProfileController>();

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      color: isLight
          ? Colors.white
          : colorScheme.surfaceContainerHighest.withValues(alpha: 0.85),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Stack(
        alignment: AlignmentGeometry.center,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isLight
                      ? [Colors.white, const Color(0xFFF8F1E7)]
                      : [
                          colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.9,
                          ),
                          colorScheme.surfaceContainer.withValues(alpha: 0.7),
                        ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: NoiseParticlesBackground(
              color: colorScheme.primary,
              brightness: theme.brightness, // اضافه کن
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  final path = controller.avatarPath.value;
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.55),
                            width: 1.4,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: colorScheme.primary.withValues(
                            alpha: 0.12,
                          ),
                          backgroundImage: (path != null && path.isNotEmpty)
                              ? FileImage(File(path))
                              : null,
                          child: (path == null || path.isEmpty)
                              ? Icon(
                                  Icons.person_rounded,
                                  size: 42,
                                  color: colorScheme.primary,
                                )
                              : null,
                        ),
                      ),
                      Positioned(
                        right: -4,
                        top: -4,
                        child: GestureDetector(
                          onTap: () => showStreakInfo(
                            context,
                            controller.streakCount.value,
                            controller.bestStreak.value,
                          ),
                          child: StreakBadge(
                            streak: controller.streakCount.value,
                          ),
                        ),
                      ),
                      Positioned(
                        left: -2,
                        bottom: -2,
                        child: Material(
                          color: colorScheme.primary,
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () =>
                                showAvatarPickerSheet(context, controller),
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isLight
                                      ? Colors.white
                                      : colorScheme.surfaceContainerHighest,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.photo_camera_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 14),
                Obx(
                  () => ProfileAndNameEditor(
                    name: controller.userName.value.isEmpty
                        ? 'کاربر عزیز'
                        : controller.userName.value,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(
                  () => Text(
                    controller.bio.value,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.7,
                    ),
                  ),
                ),
              ],
            ),
          ),
          PositionedDirectional(
            top: 12,
            start: 12,
            child: Obx(
              () => EditProfileCornerButton(
                showHint: controller.showEditHint.value,
                onDismissHint: controller.dismissEditHint,
                onTap: () {
                  controller.dismissEditHint();
                  showEditProfileSheet(context, controller);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
