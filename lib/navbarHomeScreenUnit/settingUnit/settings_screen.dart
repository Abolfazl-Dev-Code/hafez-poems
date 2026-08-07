import 'package:flutter/material.dart';
import 'package:hafez_poems/theme/app_shadows.dart';
import 'package:hafez_poems/theme/app_radius.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/app_snackbar_service.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/notification_service.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/setting_contact_us_dialog.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/setting_delete_dialog.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/setting_theme_toggle_mode.dart';
import 'package:hafez_poems/theme/theme_controller.dart';
import 'package:hafez_poems/core/data/contracts/i_keyed_item_storage.dart';
import 'package:hafez_poems/models/highlight_item.dart';
import 'package:hafez_poems/models/liked_item.dart';
import 'package:hafez_poems/models/saved_item.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/settings_reading_section.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/settings_reminder_section.dart';
import 'package:hafez_poems/navbarHomeScreenUnit/settingUnit/settings_more_sections.dart';

part 'settings_actions.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key, required this.title});

  final String title;

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>
    with AutomaticKeepAliveClientMixin {
  static const String _fontSizePrefKey = 'reading_font_size';
  static const String _lineHeightPrefKey = 'reading_line_height';
  static const String _fontFamilyPrefKey = 'reading_font_family';
  static const String _fontColorPrefKey = 'reading_font_color';
  static const String _dailyReminderPrefKey = 'daily_ghazal_reminder_enabled';
  static const String _reminderHourPrefKey = 'notif_hour';
  static const String _reminderMinutePrefKey = 'notif_minute';

  double _fontSize = 13;
  double _lineHeight = 1;
  String _fontFamily = 'vazir';
  int _fontColorValue = 0xFF000000;
  bool _dailyReminderEnabled = false;
  int _reminderHour = 13;
  int _reminderMinute = 0;
  String _appVersion = '...';
  bool _isTogglingReminder = false;

  static const fontOptions = [
    {'label': 'وزیر', 'value': 'vazir'},
    {'label': 'مروارید', 'value': 'morvarid'},
    {'label': 'ایران', 'value': 'iran'},
    {'label': 'هدا', 'value': 'hoda'},
    {'label': 'ایران گرد', 'value': 'iranrounded'},
    {'label': 'محبوبه', 'value': 'mahbobe'},
    {'label': 'روستا', 'value': 'roosta'},
  ];

  final List<Color> _fontColors = const [
    Color(0xFF000000),
    Color(0xFF1F2937),
    Color(0xFF374151),
    Color(0xFF6B21A8),
    Color(0xFF0F766E),
    Color(0xFFB91C1C),
    Color(0xFFFFFFFF),
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    Future.wait([_loadSettings(), _loadAppVersion()]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _applyLoadedSettings({
    required double fontSize,
    required double lineHeight,
    required String fontFamily,
    required int fontColorValue,
    required bool dailyReminderEnabled,
    required int reminderHour,
    required int reminderMinute,
  }) {
    setState(() {
      _fontSize = fontSize;
      _lineHeight = lineHeight;
      _fontFamily = fontFamily;
      _fontColorValue = fontColorValue;
      _dailyReminderEnabled = dailyReminderEnabled;
      _reminderHour = reminderHour;
      _reminderMinute = reminderMinute;
    });
  }

  void _setAppVersion(String version) {
    setState(() => _appVersion = version);
  }

  void _setFontSize(double value) {
    setState(() => _fontSize = value);
  }

  void _setLineHeight(double value) {
    setState(() => _lineHeight = value);
  }

  void _setFontFamily(String value) {
    setState(() => _fontFamily = value);
  }

  void _setFontColorValue(int value) {
    setState(() => _fontColorValue = value);
  }

  void _setReminderTime(int hour, int minute) {
    setState(() {
      _reminderHour = hour;
      _reminderMinute = minute;
    });
  }

  void _setDailyReminderEnabled(bool value) {
    setState(() => _dailyReminderEnabled = value);
  }

  void _setIsTogglingReminder(bool value) {
    setState(() => _isTogglingReminder = value);
  }

  String get _reminderTimeText {
    final hour = _reminderHour.toString().padLeft(2, '0');
    final minute = _reminderMinute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final ThemeController themeController = Get.find<ThemeController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 65),
          child: Column(
            children: [
              // ── کارت تغییر تم ──────────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: AppRadius.lgRadius,
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.8),
                  ),
                  boxShadow: AppShadows.card(context),
                ),
                child: Obx(() {
                  final darkMode = themeController.isDarkMode.value;
                  return Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'حالت نمایش',
                              style: textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              transitionBuilder: (child, animation) =>
                                  FadeTransition(
                                    opacity: animation,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0, 0.3),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    ),
                                  ),
                              child: Text(
                                darkMode
                                    ? 'حالت تیره فعال است'
                                    : 'حالت روشن فعال است',
                                key: ValueKey(darkMode),
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.72,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ThemeModeIconToggle(
                        isDarkMode: darkMode,
                        onTap: () {
                          final newDarkMode = !darkMode;
                          themeController.toggleTheme(newDarkMode);
                          if (newDarkMode) {
                            _saveFontColor(const Color(0xFFFFFFFF));
                          } else {
                            _saveFontColor(const Color(0xFF000000));
                          }
                        },
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 16),
              // ── تنظیمات مطالعه ────────────────────────────────────────
              SettingsReadingSection(
                fontSize: _fontSize,
                lineHeight: _lineHeight,
                fontFamily: _fontFamily,
                fontColorValue: _fontColorValue,
                fontOptions: fontOptions,
                fontColors: _fontColors,
                onFontSizeChanged: _saveFontSize,
                onLineHeightChanged: _saveLineHeight,
                onFontFamilyChanged: _saveFontFamily,
                onFontColorChanged: _saveFontColor,
              ),

              // ── یادآوری ───────────────────────────────────────────────
              SettingsReminderSection(
                dailyReminderEnabled: _dailyReminderEnabled,
                isTogglingReminder: _isTogglingReminder,
                reminderTimeText: _reminderTimeText,
                onToggle: _toggleReminder,
                onPickTime: _pickReminderTime,
              ),
              // ── مدیریت داده‌ها / درباره برنامه / اشتراک‌گذاری ──────────
              SettingsMoreSections(
                appVersion: _appVersion,
                onDeleteAllLocalData: _showDeleteAllLocalDataDialog,
                onOpenContactOptions: _openContactOptions,
                onIntroduceToFriends: _introduceToFriends,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
