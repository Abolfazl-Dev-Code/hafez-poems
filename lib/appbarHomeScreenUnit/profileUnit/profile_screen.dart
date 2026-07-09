import 'package:flutter/material.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/profileUnit/profile_controller.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/profileUnit/profile_header.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/profileUnit/profile_informations_cards.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/profileUnit/profile_quote_card.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/profileUnit/profile_single_info_card.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/profileUnit/profile_progress_bar.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/profileUnit/profile_stat_card.dart';
import 'package:hafez_poems/appbarHomeScreenUnit/profileUnit/profile_streak_badge.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/collectionUnit/collection_screen.dart';
import 'package:hafez_poems/homeScreenUnit/section_header.dart';

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
    const EdgeInsetsGeometry sectionHeaderPadding = EdgeInsets.symmetric(
      horizontal: 6,
    );
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
                  const ProfileHeader(),
                  const SizedBox(height: 16),
                  Obx(
                    () => StreakMotivationCard(
                      currentStreak: controller.streakCount.value,
                      bestStreak: controller.bestStreak.value,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SectionHeader(
                    title: 'آمار من',
                    icon: Icons.auto_graph_rounded,
                    padding: sectionHeaderPadding,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: 'علاقه‌مندی‌‌ها',
                          value: controller.likedCount.value,
                          icon: Icons.favorite_rounded,
                          color: Colors.redAccent,
                          onTap: () => Get.to(
                            () => const CollectionScreen(
                              initialTab: 0,
                              showTabs: false,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          title: 'ذخیره‌ها',
                          value: controller.savedCount.value,
                          icon: Icons.bookmark_rounded,
                          color: theme.colorScheme.primary,
                          onTap: () => Get.to(
                            () => const CollectionScreen(
                              initialTab: 1,
                              showTabs: false,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          title: 'برگزیده‌‌ها',
                          value: controller.highlightedCount.value,
                          icon: Icons.highlight_rounded,
                          color: Colors.amber.shade700,
                          onTap: () => Get.to(
                            () => const CollectionScreen(
                              initialTab: 2,
                              showTabs: false,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  SectionHeader(
                    title: 'میزان پیشرفت',
                    icon: Icons.trending_up_rounded,
                    padding: sectionHeaderPadding,
                  ),
                  const SizedBox(height: 12),
                  ProgressOverviewCard(
                    likedProgress: controller.likedRatio.value,
                    savedProgress: controller.savedRatio.value,
                    readProgress: controller.readRatio.value,
                  ),
                  const SizedBox(height: 28),
                  SectionHeader(
                    title: 'فعالیت‌های من',
                    icon: Icons.history_rounded,
                    padding: sectionHeaderPadding,
                  ),
                  const SizedBox(height: 12),
                  InfoCard(
                    title: 'آخرین اشعار علاقه‌مندی‌‌شده',
                    items: controller.recentLikedTitles,
                    emptyText: 'هنوز شعری علاقه‌مندی‌ نشده است',
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
                    title: 'آخرین برگزیده‌‌ها',
                    items: controller.recentHighlightTexts,
                    emptyText: 'هنوز برگزیده‌ی ثبت نشده است',
                    icon: Icons.format_quote_rounded,
                  ),
                  const SizedBox(height: 28),
                  SectionHeader(
                    title: 'علاقه‌مندی ادبی',
                    icon: Icons.menu_book_rounded,
                    padding: sectionHeaderPadding,
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
