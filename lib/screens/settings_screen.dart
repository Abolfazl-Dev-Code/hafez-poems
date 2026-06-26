import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hafez_poems/controllers/user_actions_controller.dart';
import 'package:hafez_poems/models/highlight_item.dart';
import 'package:hafez_poems/models/liked_item.dart';
import 'package:hafez_poems/models/saved_item.dart';
import 'package:hafez_poems/services/app_snackbar_service.dart';
import 'package:hafez_poems/services/notification_service.dart';
import 'package:hafez_poems/theme/theme_controller.dart';
import 'package:hafez_poems/widgets/setting_contact_us_dialog.dart';
import 'package:hafez_poems/widgets/setting_delete_dialog.dart';
import 'package:hafez_poems/widgets/setting_privacy_dialog.dart';
import 'package:hafez_poems/widgets/setting_section_card.dart';
import 'package:hafez_poems/widgets/setting_show_about_dialog.dart';
import 'package:hafez_poems/widgets/setting_theme_toggle_mode.dart';
import 'package:hafez_poems/widgets/setting_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key, required this.title});

  final String title;

  @override
  State<SettingPage> createState() => _SettingPageState();
}

// ✅ تغییر ۱: AutomaticKeepAliveClientMixin اضافه شد تا صفحه در حافظه بماند
class _SettingPageState extends State<SettingPage>
    with AutomaticKeepAliveClientMixin {
  static const String _fontSizePrefKey = 'reading_font_size';
  static const String _lineHeightPrefKey = 'reading_line_height';
  static const String _fontFamilyPrefKey = 'reading_font_family';
  static const String _fontColorPrefKey = 'reading_font_color';
  static const String _dailyReminderPrefKey = 'daily_ghazal_reminder_enabled';

  double _fontSize = 13;
  double _lineHeight = 1;
  String _fontFamily = 'vazir';
  int _fontColorValue = 0xFF000000;
  bool _dailyReminderEnabled = false;
  int _reminderHour = 13;
  int _reminderMinute = 0;
  String _appVersion = '...';
  bool _isTogglingReminder = false;

  // ✅ تغییر ۲: AnimationController بلااستفاده حذف شد

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

  // ✅ تغییر ۱: وانت‌کیپ‌الایو برای ماندن صفحه در حافظه
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // ✅ تغییر ۳: لودها موازی اجرا می‌شوند
    Future.wait([_loadSettings(), _loadAppVersion()]);
  }

  // ✅ تغییر ۲: dispose فقط چیزهایی که واقعاً وجود دارند
  @override
  void dispose() {
    super.dispose();
  }

  String get _reminderTimeText {
    final hour = _reminderHour.toString().padLeft(2, '0');
    final minute = _reminderMinute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final validFonts = fontOptions.map((f) => f['value']).toSet();

    final savedFont = prefs.getString(_fontFamilyPrefKey) ?? 'vazir';
    final savedReminder = prefs.getBool(_dailyReminderPrefKey) ?? false;

    // ✅ تغییر ۴: timeout برای جلوگیری از hang شدن
    final isReminderScheduled = await NotificationService.instance
        .isDailyReminderScheduled()
        .timeout(
          const Duration(milliseconds: 300),
          onTimeout: () => savedReminder,
        );

    final reminderEnabled = savedReminder && isReminderScheduled;
    if (savedReminder != reminderEnabled) {
      await prefs.setBool(_dailyReminderPrefKey, reminderEnabled);
    }

    if (!mounted) return;

    setState(() {
      _fontSize = prefs.getDouble(_fontSizePrefKey) ?? 13;
      _lineHeight = prefs.getDouble(_lineHeightPrefKey) ?? 1;
      _fontFamily = validFonts.contains(savedFont) ? savedFont : 'vazir';
      _fontColorValue = prefs.getInt(_fontColorPrefKey) ?? 0xFF000000;
      _dailyReminderEnabled = reminderEnabled;
      _reminderHour = prefs.getInt('notif_hour') ?? 13;
      _reminderMinute = prefs.getInt('notif_minute') ?? 0;
    });
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() {
      _appVersion = '${info.version} (${info.buildNumber})';
    });
  }

  Future<void> _saveFontSize(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizePrefKey, value);
    setState(() => _fontSize = value);
  }

  Future<void> _saveLineHeight(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_lineHeightPrefKey, value);
    setState(() => _lineHeight = value);
  }

  Future<void> _saveFontFamily(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fontFamilyPrefKey, value);
    setState(() => _fontFamily = value);
  }

  Future<void> _saveFontColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_fontColorPrefKey, color.toARGB32());
    setState(() => _fontColorValue = color.toARGB32());
  }

  Future<void> _pickReminderTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _reminderHour, minute: _reminderMinute),
      helpText: 'زمان یادآوری را انتخاب کنید',
    );
    if (picked == null || !mounted) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notif_hour', picked.hour);
    await prefs.setInt('notif_minute', picked.minute);

    setState(() {
      _reminderHour = picked.hour;
      _reminderMinute = picked.minute;
    });

    if (_dailyReminderEnabled) {
      await NotificationService.instance.scheduleDailyReminderAt(
        hour: picked.hour,
        minute: picked.minute,
      );
      if (!mounted) return;
      AppSnackBarService.success(
        context,
        'زمان یادآوری به $_reminderTimeText تغییر کرد',
      );
    }
  }

  Future<void> _toggleReminder(bool enabled) async {
    if (_isTogglingReminder) return;
    setState(() => _isTogglingReminder = true);

    try {
      final prefs = await SharedPreferences.getInstance();

      if (enabled) {
        final granted = await NotificationService.instance
            .requestReminderPermissions();

        if (!granted) {
          if (!mounted) return;
          setState(() => _dailyReminderEnabled = false);
          AppSnackBarService.error(context, 'اجازه ارسال اعلان‌ها داده نشد');
          return;
        }

        await NotificationService.instance.scheduleDailyReminder();
        final isScheduled = await NotificationService.instance
            .isDailyReminderScheduled();
        await prefs.setBool(_dailyReminderPrefKey, isScheduled);

        if (!mounted) return;
        setState(() => _dailyReminderEnabled = isScheduled);
        if (isScheduled) {
          AppSnackBarService.success(context, 'یادآوری روزانه فعال شد');
        }
      } else {
        await NotificationService.instance.cancelDailyReminder();
        final isStillScheduled = await NotificationService.instance
            .isDailyReminderScheduled();
        await prefs.setBool(_dailyReminderPrefKey, isStillScheduled);

        if (!mounted) return;
        setState(() => _dailyReminderEnabled = isStillScheduled);

        if (!isStillScheduled) {
          AppSnackBarService.success(context, 'یادآوری روزانه غیرفعال شد');
        } else {
          AppSnackBarService.error(
            context,
            'غیرفعال‌سازی یادآوری روزانه انجام نشد',
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isTogglingReminder = false);
    }
  }

  Future<void> _showDeleteAllLocalDataDialog() async {
    final confirmed = await showDeleteDataDialog(context);
    if (confirmed == true) await _deleteAllLocalData();
  }

  Future<void> _deleteAllLocalData() async {
    try {
      await Hive.box<LikedItem>(UserActionsController.likedBoxName).clear();
      await Hive.box<SavedItem>(UserActionsController.savedBoxName).clear();
      await Hive.box<HighlightItem>(
        UserActionsController.highlightBoxName,
      ).clear();

      final prefs = await SharedPreferences.getInstance();
      await NotificationService.instance.cancelDailyReminder();
      await prefs.clear();
      await _loadSettings();

      if (!mounted) return;
      AppSnackBarService.success(context, 'تمام داده‌های محلی حذف شد');
    } catch (e) {
      if (!mounted) return;
      AppSnackBarService.error(context, 'خطا در حذف داده‌ها: $e');
    }
  }

  Future<void> _introduceToFriends() async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          text:
              '✨ اگر عاشق شعر و فال حافظی، این برنامه رو حتماً امتحان کن!\n\n'
              '📖 مجموعه کامل غزل‌های حافظ\n'
              '🔮 فال حافظ با رابط کاربری زیبا\n'
              '⚡ سریع، سبک و کاملاً رایگان\n\n'
              '👇 لینک دانلود:\n'
              'https://github.com/Abolfazl-Dev-Code/hafez-poems/releases',
          subject: 'معرفی به دوستان',
        ),
      );
      if (!mounted) return;
      AppSnackBarService.success(context, 'پنجره اشتراک‌گذاری باز شد');
    } catch (e) {
      if (!mounted) return;
      AppSnackBarService.error(context, 'اشتراک‌گذاری انجام نشد');
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      AppSnackBarService.error(context, 'امکان باز کردن لینک وجود ندارد');
    }
  }

  void _openContactOptions() {
    showContactOptions(
      context: context,
      onEmailTap: () => _openUrl('mailto:nashenaskhamosh@gmail.com'),
      onTelegramTap: () => _openUrl('https://t.me/dotb1'),
      onWebsiteTap: () =>
          _openUrl('https://instagram.com/should_call_me_nostradamus'),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ تغییر ۱: این خط الزامی است برای AutomaticKeepAliveClientMixin
    super.build(context);

    final ThemeController themeController = Get.find<ThemeController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    final previewColor = Color(_fontColorValue);

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
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.8),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withValues(
                        alpha: isDark ? 0.22 : 0.08,
                      ),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
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
                                // ✅ key الزامی است — بدون آن AnimatedSwitcher تفاوت را تشخیص نمی‌دهد
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
              SectionCard(
                title: 'تنظیمات مطالعه',
                icon: Icons.text_fields_outlined,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'اندازه قلم: ${_fontSize.toStringAsFixed(0)}',
                      style: textTheme.bodyMedium,
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 2.5,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 7,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 14,
                      ),
                    ),
                    child: Slider(
                      value: _fontSize,
                      min: 10,
                      max: 25,
                      divisions: 15,
                      label: _fontSize.toStringAsFixed(0),
                      onChanged: _saveFontSize,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'فاصله خطوط مصرع‌ها: ${_lineHeight.toStringAsFixed(1)}',
                      style: textTheme.bodyMedium,
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 2.5,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 7,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 14,
                      ),
                    ),
                    child: Slider(
                      value: _lineHeight,
                      min: 1.0,
                      max: 2.2,
                      divisions: 12,
                      label: _lineHeight.toStringAsFixed(1),
                      onChanged: _saveLineHeight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'انتخاب نوع قلم',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.35,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: theme.dividerColor.withValues(alpha: 0.8),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _fontFamily,
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(16),
                        dropdownColor: colorScheme.surface,
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        alignment: Alignment.centerRight,
                        items: fontOptions.map((font) {
                          final value = font['value']!;
                          final label = font['label']!;
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        label,
                                        textAlign: TextAlign.right,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: value,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_fontFamily == value) ...[
                                    const SizedBox(width: 5),
                                    Icon(
                                      Icons.check_circle_rounded,
                                      size: 18,
                                      color: colorScheme.primary,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        selectedItemBuilder: (context) {
                          return fontOptions.map((font) {
                            return Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                font['label']!,
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: font['value'],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            );
                          }).toList();
                        },
                        onChanged: (value) {
                          if (value != null) _saveFontFamily(value);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'رنگ قلم',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _fontColors.map((color) {
                      final selected = color.toARGB32() == _fontColorValue;
                      return GestureDetector(
                        onTap: () => _saveFontColor(color),
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selected
                                  ? colorScheme.primary
                                  : theme.dividerColor,
                              width: selected ? 3 : 1.2,
                            ),
                          ),
                          child: selected
                              ? Icon(
                                  Icons.check,
                                  size: 18,
                                  color: color.computeLuminance() > 0.5
                                      ? Colors.black
                                      : Colors.white,
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.45,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'الا یا ایها الساقی ادر کاساً و ناولها',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: _fontSize,
                        height: _lineHeight,
                        fontFamily: _fontFamily,
                        color: previewColor,
                      ),
                    ),
                  ),
                ],
              ),

              // ── یادآوری ───────────────────────────────────────────────
              SectionCard(
                title: 'یادآوری خواندن اشعار حافظ',
                icon: Icons.notifications_active_rounded,
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _dailyReminderEnabled,
                    onChanged: _isTogglingReminder ? null : _toggleReminder,
                    title: Text(
                      'فعال‌سازی اعلان‌ها',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text(
                      'این گزینه برای ارسال یادآوری روزانه خواندن اشعار است.',
                    ),
                  ),
                  if (_dailyReminderEnabled) ...[
                    const Divider(height: 1),
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _pickReminderTime,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 20,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'زمان یادآوری',
                                  style: textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            Text(
                              _reminderTimeText,
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              // ── مدیریت داده‌ها ─────────────────────────────────────────
              SectionCard(
                title: 'مدیریت داده‌ها',
                icon: Icons.storage_rounded,
                children: [
                  SettingTile(
                    title: 'حذف تمامی داده‌های محلی',
                    subtitle:
                        'علاقه‌مندی‌‌ها، ذخیره‌ها، برگزیده‌‌ها و تنظیمات ذخیره‌شده پاک می‌شوند.',
                    titleColor: colorScheme.error,
                    trailing: Icon(
                      Icons.delete_forever_rounded,
                      color: colorScheme.error,
                    ),
                    onTap: _showDeleteAllLocalDataDialog,
                  ),
                ],
              ),

              // ── درباره برنامه ──────────────────────────────────────────
              SectionCard(
                title: 'درباره برنامه',
                icon: Icons.android,
                children: [
                  SettingTile(title: 'نسخه برنامه', subtitle: _appVersion),
                  SettingTile(
                    title: 'راه‌های ارتباطی',
                    subtitle: 'ایمیل و شبکه‌های ارتباطی',
                    trailing: const Icon(Icons.chevron_left_rounded),
                    onTap: _openContactOptions,
                  ),
                  SettingTile(
                    title: 'درباره ما',
                    trailing: const Icon(Icons.chevron_left_rounded),
                    onTap: () => showAboutDialogCustom(
                      context: context,
                      appVersion: _appVersion,
                    ),
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
                    onTap: _introduceToFriends,
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
          ),
        ),
      ),
    );
  }
}
