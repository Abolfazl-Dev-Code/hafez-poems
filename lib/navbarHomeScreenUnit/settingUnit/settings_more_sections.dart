import 'package:flutter/material.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/setting_section_card.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/setting_show_about_dialog.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/setting_privacy_dialog.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/setting_tile.dart';

class SettingsMoreSections extends StatelessWidget {
  final String appVersion;
  final VoidCallback onDeleteAllLocalData;
  final VoidCallback onOpenContactOptions;
  final VoidCallback onIntroduceToFriends;

  const SettingsMoreSections({
    super.key,
    required this.appVersion,
    required this.onDeleteAllLocalData,
    required this.onOpenContactOptions,
    required this.onIntroduceToFriends,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // ── مدیریت داده‌ها ─────────────────────────────────────────
        SectionCard(
          title: 'مدیریت داده‌ها',
          icon: Icons.storage_rounded,
          children: [
            SettingTile(
              title: 'حذف تمامی داده‌های محلی',
              subtitle:
                  'علاقه‌مندی‌‌ها، ذخیره‌ها، برگزیده‌‌ها و تمامی گزینه‌های درون بخش تنظیمات پاک می‌شوند.',
              titleColor: colorScheme.error,
              trailing: Icon(Icons.delete_forever_rounded, color: colorScheme.error),
              onTap: onDeleteAllLocalData,
            ),
          ],
        ),

        // ── درباره برنامه ──────────────────────────────────────────
        SectionCard(
          title: 'درباره برنامه',
          icon: Icons.android,
          children: [
            SettingTile(title: 'نسخه برنامه', subtitle: appVersion),
            SettingTile(
              title: 'راه‌های ارتباطی',
              subtitle: 'ایمیل و شبکه‌های ارتباطی',
              trailing: const Icon(Icons.chevron_left_rounded),
              onTap: onOpenContactOptions,
            ),
            SettingTile(
              title: 'درباره ما',
              trailing: const Icon(Icons.chevron_left_rounded),
              onTap: () =>
                  showAboutDialogCustom(context: context, appVersion: appVersion),
            ),
            SettingTile(
              title: 'حریم خصوصی',
              trailing: const Icon(Icons.chevron_left_rounded),
              onTap: () => showPrivacyDialog(context),
            ),
          ],
        ),
        // ── اشتراک‌گذاری و حمایت ──────────────────────────────────
        SectionCard(
          title: 'اشتراک‌گذاری و حمایت',
          icon: Icons.share_rounded,
          children: [
            SettingTile(
              title: 'معرفی به دوستان',
              trailing: const Icon(Icons.ios_share_rounded),
              onTap: onIntroduceToFriends,
            ),
            SettingTile(
              title: 'امتیاز دادن به برنامه',
              subtitle: 'این گزینه پس از انتشار برنامه فعال می‌شود.',
              enabled: false,
              trailing: const Icon(Icons.lock_outline),
            ),
          ],
        ),
      ],
    );
  }
}
