import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hafez_poems/controllers/profile_controller.dart';
import 'package:hafez_poems/screens/collection_screen.dart';
import 'package:hafez_poems/widgets/profile_widgets.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;
    final textColor = isLight ? Colors.black : colorScheme.onSurface;
    final textTheme = theme.textTheme;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "پروفایل",
            style: textTheme.headlineMedium?.copyWith(color: textColor),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () async {
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isLight
                  ? [const Color(0xFFE1D4C2), const Color(0xFFE1D4C2)]
                  : [const Color(0xFF1E1712), const Color(0xFF1E1712)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Obx(
              () => ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  const _ProfileHeader(bio: 'همراه غزل‌ها و بیت‌های ماندگار'),
                  const SizedBox(height: 24),
                  const SectionHeader(
                    title: 'آمار من',
                    icon: Icons.auto_graph_rounded,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: 'لایک‌ها',
                          value: controller.likedCount.value.toString(),
                          icon: Icons.favorite_rounded,
                          color: Colors.redAccent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          title: 'ذخیره‌ها',
                          value: controller.savedCount.value.toString(),
                          icon: Icons.bookmark_rounded,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          title: 'هایلایت‌ها',
                          value: controller.highlightedCount.value.toString(),
                          icon: Icons.highlight_rounded,
                          color: Colors.amber.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const SectionHeader(
                    title: 'میانبرها',
                    icon: Icons.dashboard_customize_rounded,
                  ),
                  const SizedBox(height: 12),
                  ActionTile(
                    title: 'لایک‌ها',
                    subtitle: 'اشعار لایک‌شده',
                    icon: Icons.favorite_outline_rounded,
                    onTap: () => Get.to(
                      () => const CollectionScreen(
                        initialTab: 0,
                        showTabs: false,
                      ),
                    ),
                  ),
                  ActionTile(
                    title: 'ذخیره‌شده‌ها',
                    subtitle: 'اشعار ذخیره‌شده',
                    icon: Icons.bookmark_outline_rounded,
                    onTap: () => Get.to(
                      () => const CollectionScreen(
                        initialTab: 1,
                        showTabs: false,
                      ),
                    ),
                  ),
                  ActionTile(
                    title: 'هایلایت‌ها',
                    subtitle: 'بیت‌های هایلایت‌شده',
                    icon: Icons.highlight_rounded,
                    onTap: () => Get.to(
                      () => const CollectionScreen(
                        initialTab: 2,
                        showTabs: false,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const SectionHeader(
                    title: 'فعالیت‌های من',
                    icon: Icons.history_rounded,
                  ),
                  const SizedBox(height: 12),
                  InfoCard(
                    title: 'آخرین اشعار لایک‌شده',
                    items: controller.recentLikedTitles,
                    emptyText: 'هنوز شعری لایک نشده است',
                    icon: Icons.favorite_outline_rounded,
                  ),
                  const SizedBox(height: 12),
                  InfoCard(
                    title: 'آخرین اشعار ذخیره‌شده',
                    items: controller.recentSavedTitles,
                    emptyText: 'هنوز شعری ذخیره نشده است',
                    icon: Icons.bookmark_outline_rounded,
                  ),
                  const SizedBox(height: 12),
                  InfoCard(
                    title: 'آخرین هایلایت‌ها',
                    items: controller.recentHighlightTexts,
                    emptyText: 'هنوز هایلایتی ثبت نشده است',
                    icon: Icons.format_quote_rounded,
                  ),
                  const SizedBox(height: 28),
                  const SectionHeader(
                    title: 'علاقه‌مندی ادبی',
                    icon: Icons.menu_book_rounded,
                  ),
                  const SizedBox(height: 12),
                  SingleInfoTile(
                    title: 'بیشترین اشعار خوانده‌شده',
                    value: controller.mostReadTitle.value.isNotEmpty
                        ? controller.mostReadTitle.value
                        : 'داده‌ای موجود نیست',
                    icon: Icons.local_library_rounded,
                  ),
                  const SizedBox(height: 12),
                  QuoteCard(
                    title: 'نقل‌قول منتخب',
                    quote: controller.favoriteQuote.value,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String bio;

  const _ProfileHeader({required this.bio});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;
    final ProfileController controller = Get.find<ProfileController>();

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      color: isLight
          ? Colors.white
          : colorScheme.surfaceContainerHighest.withValues(alpha: 0.85),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: isLight
                ? [Colors.white, const Color(0xFFF8F1E7)]
                : [
                    colorScheme.surfaceContainerHighest.withValues(alpha: 0.9),
                    colorScheme.surfaceContainer.withValues(alpha: 0.7),
                  ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          children: [
            Obx(() {
              final path = controller.avatarPath.value;
              return Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  CircleAvatar(
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
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: Material(
                      color: colorScheme.primary,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () async {
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
                                      leading: const Icon(
                                        Icons.photo_library_rounded,
                                      ),
                                      title: const Text('انتخاب عکس پروفایل'),
                                      onTap: () async {
                                        Navigator.pop(context);
                                        await controller.pickAndSaveAvatar();
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.delete_outline_rounded,
                                      ),
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
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.edit_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 10),
            Obx(
              () => EditableProfileName(
                name: controller.userName.value,
                onEdit: () => showEditNameDialog(context, controller),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              bio,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
